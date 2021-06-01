----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2021 20:53:48
-- Design Name: 
-- Module Name: baudclk - Behavioral
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

entity baudclk is
    Port ( clk, rst : in STD_LOGIC;
           baudrate_clk_ticks: in std_logic_vector(31 downto 0);
           baudclk : out STD_LOGIC);
end baudclk;

architecture Behavioral of baudclk is
signal cpt_clk,sbaud_clk_ticks: integer := 0;
signal sbaud_clk: std_logic := '0';

begin
    sbaud_clk_ticks <= to_integer(unsigned(baudrate_clk_ticks));
    process(clk,rst)
    begin
        if rst = '1' then
            cpt_clk <= 0;
            sbaud_clk <= '0';
        elsif rising_edge(clk) then
            cpt_clk <= cpt_clk +1;
            if cpt_clk >= (sbaud_clk_ticks-1) then
                cpt_clk <= 0;
                sbaud_clk <= not sbaud_clk;
            end if;
        end if;
    end process;
    baudclk <= sbaud_clk;

end Behavioral;
