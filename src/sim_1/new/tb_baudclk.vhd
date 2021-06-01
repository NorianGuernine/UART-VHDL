----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.05.2021 23:38:27
-- Design Name: 
-- Module Name: tb_baudclk - Behavioral
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

entity tb_baudclk is
--  Port ( );
end tb_baudclk;

architecture Behavioral of tb_baudclk is
component baudclk
    Port ( clk, rst : in STD_LOGIC;
           baudrate_clk_ticks: in std_logic_vector(31 downto 0);
           baudclk : out STD_LOGIC);
end component;

signal sclk,clkbaudrate,srst: std_logic := '0';
signal sbaud_tick_clk: std_logic_vector(31 downto 0);


begin
    sbaud_tick_clk <= std_logic_vector(to_unsigned(4,32));
    c1: baudclk port map(clk => sclk, rst => srst,baudrate_clk_ticks => sbaud_tick_clk, baudclk => clkbaudrate);
    
    stimulis:process
    begin
        sclk <= '0';
        wait for 10ns;
        sclk <= '1';
        wait for 10ns;
    end process;


end Behavioral;
