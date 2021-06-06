----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.06.2021 12:39:16
-- Design Name: 
-- Module Name: tb_DEMO - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_DEMO is
--  Port ( );
end tb_DEMO;

architecture Behavioral of tb_DEMO is
component DEMO is
    Port ( CLK100MHZ,uart_txd_in : in STD_LOGIC;
           ja,sw: in STD_LOGIC_VECTOR(1 downto 0);
           uart_rxd_out : out STD_LOGIC);
end component;

signal clk, sRX: std_logic := '1';
signal sTX: std_logic := '0';
signal strame: std_logic_vector(10 downto 0) := "10110101001"; 
signal cpt: integer := 0;

begin

sRX<=strame(cpt);
c1: DEMO port map(CLK100MHZ => clk, uart_txd_in => sRX, ja => "00", sw => "01", uart_rxd_out => sTX);

stimulis: process
begin
    clk <= not clk;
    wait for 5ns;       
end process stimulis;

baudrate_clk:process
begin
    wait for 8.68us; --Bit duration for baudrate of 115200
    cpt <= cpt +1;        
    if cpt >= 10 then
        cpt <= 0;
    end if;   
end process;

end Behavioral;
