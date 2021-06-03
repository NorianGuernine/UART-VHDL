# UART-VHDL

## Baudclk
This is the clock for the duration of one bit as a function of the baudrate.

In: 
* clk : FPGA clock.
* rst : Reset the clock on a rising edge of the input bit.
* baudrate_clk_ticks : Number of rising edge on the input clock to change the state of the baudrate clock
The calculation is as follows: <img src="https://render.githubusercontent.com/render/math?math=baudrateclkticks = \frac{\frac{ClockFrequency}{Baudrate}}{2}">

	Example for a baud rate of 115200 bits/s and a 50MHz clock:


	<img src="https://render.githubusercontent.com/render/math?math=baudrateclkticks = \frac{\frac{50*10^{6}}{115200}}{2} = 217.01 \approx 217">

Out:
* baudclk : Clock at baudrate frequency.

## UART_RX
This is the Rx component

In:
* clk : Clock at baudrate frequency.
* rst : Reset the clock on a rising edge of the input bit.
* RX : Bit from transmitter.
* parity : Parity mode.
* timeout_value : <img src="https://render.githubusercontent.com/render/math?math=timeout = \frac{Duration Of The Desired Timeout}{Duration Of A Bit}">

	Example for a baud rate of 115200 bits/s (bit duration of 8.7µs) and a desired timeout duration of 130µs:
	
	<img src="https://render.githubusercontent.com/render/math?math=timeout = \frac{130}{8.7} = 14.94 \approx 15 baudclock">
* error_parity : Is equal to 1 if the parity bit does not correspond to the frame, 0 otherwise
* end_reception : Equals 1 when the frame is fully received and the parity bit is calculated. Remains high for the duration of a clock cycle (from one rising edge to another).
* timeout : Equals 1 when the timeout duration is reached. Remains high for the duration of a clock cycle (from one rising edge to another).
* RXREG : Corresponds to the data transmitted in the frame. The data is kept for the duration of a clock cycle (from one rising edge to another).

### Simulation

No parity:

![Simu_without_parity](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/RxNoParity.png)

Odd parity with frame = 0x509 = 0101 1010 1001 :

![Simu_odd_parity](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Rx0x5a9Odd.png)

Even parity with frame = 0x509 = 0101 1010 1001 :
![Simu_even_parit](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Rx0x5a9Even.png)

Odd parity with frame = 0x1A9 = 0001 1010 1001 :
![Simu_odd_pariy_good](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Rx0x1a9Odd.png)

Even parity with frame = 0x1A9 = 0001 1010 1001 :
![Simu_even_pariy_error](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Rx0x1a9Even.png)

Timeout at 130µs : 
![timeout](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/RxTimeout.png)

## UART_TX

This is the Tx Component.

In:

* clk : Clock at baudrate frequency.
* rst : Reset the clock on a rising edge of the input bit.
* set : Send the data on a rising edge of set.
* data : Data to send.
* parity : Parity mode.

Out:

* TX : Frame bit sent.
* end_transmission : Goes to 1 when the frame has been sent. Remains at 1 for a clock cycle ((from one rising edge to another).

### Simulation

No parity :
 
![SimuTx_without_parity](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Tx0x43NoParity.png)

Odd parity for data = 0x43 : 

![SimuTx_odd_0x43](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Tx0x43Odd.png)

Even parity for data = 0x43 : 

![SimuTx_even_0x43](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Tx0x43Even.png)

Odd parity for data = 0x44 :

![SimuTx_odd_0x44](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Tx0x44Odd.png)

Even parity for data = 0x44 : 

![SimuTx_odd_0x44](https://github.com/NorianGuernine/UART-VHDL/blob/main/Pictures/Tx0x44Even.png)




