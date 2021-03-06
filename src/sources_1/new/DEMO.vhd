----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2021 19:23:17
-- Design Name: 
-- Module Name: SEND_RECEIVE_DATA - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DEMO is
    Port ( CLK100MHZ,uart_txd_in : in STD_LOGIC;
           sw: in STD_LOGIC_VECTOR(1 downto 0);
           uart_rxd_out : out STD_LOGIC;
           ja : out STD_LOGIC_VECTOR(0 downto 0));
end DEMO;

architecture Behavioral of DEMO is
component baudclk
    Port ( clk, rst : in STD_LOGIC;
           baudrate_clk_ticks: in std_logic_vector(31 downto 0);
           baudclk : out STD_LOGIC);
end component;

component UART_TX
    Port(clk,rst,set: in std_logic;
        parity: in std_logic_vector(1 downto 0);
        data: in std_logic_vector(7 downto 0);
        TX,end_transmission: out std_logic);
end component;

component UART_RX
    Port(clk, rst, RX: in std_logic;
        parity: in std_logic_vector(1 downto 0);
        timeout_value: in std_logic_vector(31 downto 0);
        error_parity,timeout,end_reception: out std_logic;
        RXREG: out std_logic_vector(7 downto 0));
end component;
signal sbaud_tick_clk,stimeout_value: std_logic_vector(31 downto 0);
signal rdata, sauvegarde: std_logic_vector(7 downto 0) := "00000000";
signal sclk, sTX,clkbaudrate, serror_RX, stimeout,sRX, send_reception, send_transmission: std_logic;
signal readytosend : std_logic := '0';
signal ssw: std_logic_vector(1 downto 0);

begin
    sclk <= CLK100MHZ;
    ssw <= sw;
    sRX <= uart_txd_in;
    stimeout_value <= std_logic_vector(to_unsigned(1150, 32));
    sbaud_tick_clk <= std_logic_vector(to_unsigned(434,32));
    c1: baudclk port map(clk => sclk, rst => '0',baudrate_clk_ticks => sbaud_tick_clk, baudclk => clkbaudrate);
    c2: UART_RX port map(clk =>clkbaudrate, rst => '0', RX => sRX, parity => "01", timeout_value =>stimeout_value, error_parity =>serror_RX,end_reception => send_reception, timeout => stimeout,RXREG =>rdata);
    c3: UART_TX port map(clk=> clkbaudrate,rst => '0',set => readytosend, data=> sauvegarde, parity =>"01", TX => sTX, end_transmission => send_transmission);
    uart_rxd_out <= sTX;
    ja(0) <= sTX;
    
    recup_data:process(sclk,send_reception)
    begin
        if rising_edge(send_reception) then
            sauvegarde <= rdata;
        end if;
    end process;
    
    send_data:process(sclk)
    begin
        
        if rising_edge(sclk) then
            if send_reception = '1' then
                readytosend <= '1';
            else 
                readytosend <= '0';
            end if;
        end if;
    end process;
    

end Behavioral;
