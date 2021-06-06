----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2021 21:47:17
-- Design Name: 
-- Module Name: UART - Behavioral
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

entity UART_TX is 
    Port(clk,rst,set: in std_logic;
        parity: in std_logic_vector(1 downto 0);
        data: in std_logic_vector(7 downto 0);
        TX,end_transmission: out std_logic);
end UART_TX;

architecture Behavioral of UART_TX is
signal cpt_TX,cpt_TX_1, ssendOk: integer := 0;  
signal nb_bit_emission : integer := 9;     
signal trame : std_logic_vector(10 downto 0) := "10000000000";
signal send_transmission,set_1: std_logic := '0';
signal sTX : std_logic := '1';
signal sparity : std_logic_vector(1 downto 0);

begin
    
    trame(8 downto 1) <= data;
    sparity <= parity;
    
    autorisation:process(rst,set,clk)   --Determines if we can transmit.    
    begin
        if rst = '1' then
            ssendOk <= 0;
        else  
            if rising_edge(set) then 
                ssendOk <= 1;
            end if;
            if send_transmission = '1' then
                ssendOk <= 0;
            end if;
        end if;  
    end process;
    
    emission:process(clk,rst)   --Parity bit: "00" or "11"= no parity bit, "01" = odd parity, "10" = even parity
    variable nb_bits_1 : integer := 0;
    begin
        if rst = '1' then
            cpt_TX <= 0;
            cpt_TX_1 <= 0;
            sTX <= '1';
            nb_bits_1 := 0;
            trame(9) <= '0';
            send_transmission <= '0';
        elsif rising_edge(clk) then
            if send_transmission = '1' then 
                send_transmission <= '0';
            end if;
            if ssendOk = 1 then
                    if cpt_TX = 0 then
                        for D in 1 to 8 loop
                            if trame(D) = '1' then
                                nb_bits_1 := nb_bits_1 + 1;
                            end if;
                        end loop; 
                        if sparity = "01" then      --Error checking
                            nb_bit_emission <= 9;
                            if (nb_bits_1 mod 2) = 0 then
                                trame(9) <= '1';
                            else
                                trame(9) <= '0';
                            end if;
                        elsif sparity = "10" then      --Error checking
                            nb_bit_emission <= 9;
                            if (nb_bits_1 mod 2) = 0 then
                                trame(9) <= '0';
                            else
                                trame(9) <= '1';
                            end if;
                        else                            --If there is no parity mode we put 0.
                            nb_bit_emission <= 8;
                            trame(9) <= '1';
                        end if;
                    end if;
                    sTX <= trame(cpt_TX);
                    cpt_TX <= cpt_TX +1;
                    cpt_TX_1 <= cpt_TX; 
                    if cpt_TX > nb_bit_emission  then
                        cpt_TX <= 0; 
                        send_transmission <= '1';  
                    else
                        send_transmission <= '0'; 
                    end if;
            end if;
        nb_bits_1 := 0;
        end if;
    end process;
    
    TX <= sTX;
    end_transmission <= send_transmission;
end Behavioral;
