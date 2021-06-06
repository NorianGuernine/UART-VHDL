----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2021 22:01:09
-- Design Name: 
-- Module Name: UART_RX - Behavioral
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

entity UART_RX is
    Port(clk, rst, RX: in std_logic;
        parity: in std_logic_vector(1 downto 0);
        timeout_value: in std_logic_vector(31 downto 0);
        error_parity,timeout,end_reception: out std_logic;
        RXREG: out std_logic_vector(7 downto 0));
end UART_RX;

architecture Behavioral of UART_RX is

signal sCptTimeout,stimeout, cptBit, cptBit_1: integer := 0;
signal strame: std_logic_vector(9 downto 0) := "0000000000"; 
signal serror_timeout,sRX,send_reception,serror_parity, strame_ready: std_logic := '0';
signal sparity: std_logic_vector(1 downto 0);
signal sdata: std_logic_vector(7 downto 0) := "00000000"; 

begin
stimeout <= to_integer(unsigned(timeout_value));
sRX <= RX;
sparity <= parity;


timeout_process:process(clk,rst)    --timeout
begin
    if rst = '1' then
        sCptTimeout <= 0;    

    elsif rising_edge(clk) then
        if cptBit_1 = cptBit then
            sCptTimeout <= sCptTimeout +1;  --If no reception of the first bit, the timeout counter is incremented.
        else
            sCptTimeout <= 0;
        end if;
    
        if sCptTimeout = stimeout then
            serror_timeout <= '1';
            sCptTimeout <= 0;
        else 
            serror_timeout <= '0';
        end if;
    end if;
end process;

reception:process(clk,rst)   --Process for recovering the bits in the frame
begin

    if rst = '1' then
        cptBit <= 0;  
        cptBit_1 <= 0;
        strame <= "0000000000";  
        send_reception <= '0';
        
    elsif rising_edge(clk) then
        if send_reception = '1' then
            send_reception <= '0';
        else
            if sRX = '0' and cptBit = 0  then   --Reception of first bit
                strame <= "0000000000"; 
                strame(cptBit) <= sRX;
                cptBit <= cptBit +1;
            elsif cptBit > 0 then               --Reception of the rest of the trame
                strame(cptBit) <= sRX;
                cptBit <= cptBit +1;
                if sparity = "11" or sparity = "00" then 
                    if cptBit >= 8 then            --Reset counter at the end of reception
                        cptBit <= 0;
                        send_reception <= '1';
                    end if;                   
                else
                    if cptBit >= 9 then            --Reset counter at the end of reception
                        cptBit <= 0;
                        send_reception <= '1';
                    end if;
                end if;
            end if;
        end if;
    cptBit_1 <= cptBit;
    end if;
end process;

parity_process:process(clk,rst) --Parity bit: "00" or "11"= no parity bit, "01" = odd parity, "10" = even parity
variable nb_bits_1 : integer := 0;
begin
    if rst = '1' then
        nb_bits_1:= 0;
        serror_parity <= '0';
        sdata <= "00000000";
    elsif rising_edge(clk) then
        if send_reception = '1' then
            nb_bits_1 := 0;
            for D in 1 to 8 loop    --Counting the number of bits at 1
                if strame(D) = '1' then
                    nb_bits_1 := nb_bits_1 + 1;
                end if;
            end loop; 
            
            if sparity = "01" then      --Error checking
                if (nb_bits_1 mod 2) = 0 then
                    serror_parity <= not strame(9);
                else
                    serror_parity <= strame(9);
                end if;
            elsif sparity = "10" then       --Error checking
                if (nb_bits_1 mod 2) = 0 then
                    serror_parity <= strame(9);
                else
                    serror_parity <= not strame(9);
                end if;
            else                            --If there is no parity mode we put 0.
                serror_parity <= '0';
            end if;
            strame_ready <= '1';
            sdata <= strame(8 downto 1); --For output
        else
            serror_parity <= '0';
            sdata <= "00000000";
            strame_ready <= '0';
        end if;
        
    end if;
end process;

RXREG <= sdata;
timeout <= serror_timeout;
error_parity <= serror_parity;
end_reception <= strame_ready;
end Behavioral;