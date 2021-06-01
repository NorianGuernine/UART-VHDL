----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2021 19:47:46
-- Design Name: 
-- Module Name: tb_DATA_RX_TX - Behavioral
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

entity tb_DATA_RX_TX is
--  Port ( );
end tb_DATA_RX_TX;

architecture Behavioral of tb_DATA_RX_TX is

component SEND_RECEIVE_DATA 
    Port ( CLK100MHZ,uart_txd_in : in STD_LOGIC;
           uart_rxd_out : out STD_LOGIC);
end component;

signal sclk,sbaudrateclk,sTX,sRX: std_logic := '0';
signal strame: std_logic_vector(10 downto 0) := "11011010100";
signal cpt,cptbaudclock: integer := 0;


begin

c1:SEND_RECEIVE_DATA port map(CLK100MHZ=> sclk,uart_txd_in => sRX, uart_rxd_out => sTX);


stimulis:process
begin
    sclk <= not sclk;
    cptbaudclock <= cptbaudclock +1;
    if cptbaudclock = 868 then 
        sbaudrateclk <= not sbaudrateclk;  
        cptbaudclock <= 0;
    end if;      
    wait for 10ns;
end process;

stimulis2:process(sbaudrateclk)
begin
    if rising_edge(sbaudrateclk) then
            sRX <= strame(cpt);
            cpt <= cpt + 1;
            if cpt >= 10 then
                cpt <= 0;
            end if;
    end if;
end process;

end Behavioral;
