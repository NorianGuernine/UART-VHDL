----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2021 22:10:34
-- Design Name: 
-- Module Name: testbench - Behavioral
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

entity tb_UART_TX is
--  Port ( );
end tb_UART_TX;

architecture Behavioral of tb_UART_TX is
component UART_TX
    Port(clk,rst,set: in std_logic;
        parity: in std_logic_vector(1 downto 0);
        data: in std_logic_vector(7 downto 0);
        TX,end_transmission: out std_logic);
end component;

component baudclk
    Port ( clk, rst : in STD_LOGIC;
           baudrate_clk_ticks: in std_logic_vector(31 downto 0);
           baudclk : out STD_LOGIC);
end component;

signal sclk, clkbaudrate,ssend, send_transmission: std_logic := '0';
signal sTX : std_logic := '1';
signal sparity: std_logic_vector(1 downto 0) := "00";
signal sdata: std_logic_vector(7 downto 0);
signal sbaud_tick_clk: std_logic_vector(31 downto 0);
signal cpt_parity: integer := 2;
signal cpt_data: integer := 66;

begin 
    sdata <= std_logic_vector(to_unsigned(cpt_data, 8));
    sparity <= std_logic_vector(to_unsigned(cpt_parity,2));
    sbaud_tick_clk <= std_logic_vector(to_unsigned(217,32)); --Clock/baudrate  pour avoir front montant /!\ remplacer par or front descendant et donc ne plus diviser par 2
    --Init du composant
    c1: baudclk port map(clk => sclk, rst => '0',baudrate_clk_ticks => sbaud_tick_clk, baudclk => clkbaudrate);
    c2: UART_TX port map(clk=> clkbaudrate,rst => '0',set => ssend, data=> sdata, parity =>sparity, TX => sTX, end_transmission => send_transmission);
    
    tb: process
    begin 
        sclk <= not sclk;
        wait for 10ns;       
    end process tb;

    tb2: process
    begin
        wait for 8.67us;
        ssend <= '1';
        wait for 8.67us;
        ssend <= '0';
        wait for 104us;
        ssend <= '1';
    end process;
    
    tb3: process(send_transmission)
    begin
        if rising_edge(send_transmission) then
            cpt_parity <= cpt_parity +1;
            if cpt_parity >=2 then
                cpt_data <= cpt_data +1;
                cpt_parity <= 0;
            end if;
        end if;
    end process;
    

end Behavioral;
