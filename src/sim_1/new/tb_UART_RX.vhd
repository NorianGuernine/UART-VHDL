----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2021 18:28:17
-- Design Name: 
-- Module Name: tb_UART_RX - Behavioral
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

entity tb_UART_RX is
--  Port ( );
end tb_UART_RX;

architecture Behavioral of tb_UART_RX is
component UART_RX
    Port(clk, rst, RX: in std_logic;
        parity: in std_logic_vector(1 downto 0);
        timeout_value: in std_logic_vector(31 downto 0);
        error_parity,timeout,end_reception: out std_logic;
        RXREG: out std_logic_vector(7 downto 0));
end component;

component baudclk
    Port ( clk, rst : in STD_LOGIC;
           baudrate_clk_ticks: in std_logic_vector(31 downto 0);
           baudclk : out STD_LOGIC);
end component;
signal sRX,clkbaudrate,serror_RX,stimeout,send_reception,end_emission: std_logic := '0';
signal sclk: std_logic := '1';
signal stimeout_value: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal sbaud_tick_clk: std_logic_vector(31 downto 0);
signal strame: std_logic_vector(10 downto 0) := "10110101001"; 
signal rdata: std_logic_vector(7 downto 0) := "00000000";
signal cpt: integer := 0;
signal sparity : std_logic_vector(1 downto 0) := "00";

begin
    sRX<=strame(cpt);
    sbaud_tick_clk <= std_logic_vector(to_unsigned(434,32));
    stimeout_value <= std_logic_vector(to_unsigned(15,32));
    c1: baudclk port map(clk => sclk, rst => '0',baudrate_clk_ticks => sbaud_tick_clk, baudclk => clkbaudrate);
    c2: UART_RX port map(clk =>clkbaudrate, rst => '0', RX => sRX, parity => sparity, timeout_value =>stimeout_value, error_parity =>serror_RX,end_reception => send_reception, timeout => stimeout,RXREG =>rdata);
    
    stimulis:process
    begin
        sclk <= '1';
        wait for 5ns;
        sclk <= '0';
        wait for 5ns;
    end process;
    
    baudrate_clk:process
    begin
        wait for 8.68us; --Bit duration for baudrate of 115200
        if end_emission = '0' then
            cpt <= cpt +1;        
            if cpt >= 10 then
                cpt <= 0;
            end if;  
        end if;   
    end process;
    
    simulis_parity:process
    begin
        sparity <= "00";
        wait for 95us;
        sparity <= "01";
        wait for 95us;
        sparity <= "10";
        wait for 95us;
    end process;
    
    stimulis_bitparity: process
    begin
        wait for 285us;
        if end_emission = '0' then
            strame(10) <= not strame(10);
        end if;
    end process;
    
    stimulis_end_emission:process
    begin
        wait for 570us;
        end_emission <= '1';
    end process;
    


end Behavioral;
