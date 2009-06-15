//-----------------------------------------------------------------------
//	File:		$RCSfile: FPGA_TOP2+.v,v $
//	Version:	$Revision: 1.2 $
//	Desc:		Top level interface from a Xilinx XCV2000-E FG680
//			FPGA to the U.C. Berkeley CalLinx2+ board.
//	Author:		Greg Gibeling
//	Copyright:	Copyright 2003-2004 UC Berkeley
//	This copyright header must appear in all derivative works.
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Section:	Change Log
//-----------------------------------------------------------------------
//	$Log: FPGA_TOP2+.v,v $
//	Revision 1.2  2004/09/23 00:28:46  SYSTEM
//	Added clockfreq parameters
//	
//	Revision 1.1  2004/09/22 22:06:50  SYSTEM
//	Created Checkpoint1
//	
//	Revision 1.8  2004/09/17 05:39:10  Administrator
//	Updated and fixed
//	Added bit timeout capabilities
//	
//	Revision 1.7  2004/09/15 03:08:14  Administrator
//	Added pinout for data line
//	
//	Revision 1.6  2004/08/30 15:48:23  Administrator
//	Added defparam for N64 CUT.clockfreq
//	Minor reformatting
//	
//	Revision 1.5  2004/08/11 19:26:53  SYSTEM
//	Added PWM output to LEDs based on Joystick
//	
//	Revision 1.4  2004/08/04 01:35:20  SYSTEM
//	Fixed comment typo
//	
//	Revision 1.3  2004/07/30 01:21:41  SYSTEM
//	Reformated
//	Added Comments
//	Updated to newest FPGA_TOP2+
//	
//	Revision 1.11  2004/07/30 01:15:39  SYSTEM
//	Reformated
//	Added Comments
//	Added Pullups for Simulation
//	
//	Revision 1.10  2004/07/29 18:01:53  Administrator
//	Relocated LCE_E and LCD_RW for CaLinx+ RevB
//	
//	Revision 1.9  2004/07/26 23:46:45  Administrator
//	Added pullups to I2C and PS2 lines
//	
//	Revision 1.8  2004/07/01 17:35:54  Administrator
//	Fixed xc_loc on COM2 TX and RX
//	
//	Revision 1.7  2004/07/01 16:22:54  Administrator
//	Made PS2_CLK an inout
//	Made COM_Invalid an input and marked it active low
//	
//	Revision 1.6  2004/06/28 23:43:12  Administrator
//	Fixed instantiation of FPGA_TOP to FPGA_TOP_PLUS
//	
//	Revision 1.5  2004/06/28 23:41:28  Administrator
//	Finished xc_loc directives
//	Set correct pin directions
//	
//	Revision 1.4  2004/06/25 23:11:22  Administrator
//	Removed useless const.v include
//	
//	Revision 1.3  2004/06/18 23:27:50  Administrator
//	Filled in xc_locs on the new pins
//	Need to check active low and port directions
//	
//	Revision 1.2  2004/06/17 17:36:18  Administrator
//	Added Proper Headers
//	Note that this file is still VERY incomplete
//	Few of the CaLinx2+ I/Os have actually been added
//	Renamed the module to FPGA_TOP2_PLUS
//	
//-----------------------------------------------------------------------

//-----------------------------------------------------------------------
//	Module:		FPGA_TOP2_PLUS
//	Desc:		This is the root module on the VirtexE XCV2000E
//			chip on the CalLinx2 board.  This includes all of
//			the pin assignments and I/O.
//-----------------------------------------------------------------------
module FPGA_TOP2_PLUS(
			//-----------------------------------------------
			//	Clock Inputs
			//-----------------------------------------------
			Y5_CLK,		// IN(1b), 27MHz Video Crystal
			Y4_CLK,		// IN(1b), Crystal at lower left
			Y3_CLK,		// IN(1b), Crystal at top right
			J18_CLK,	// IN(1b), SMA Connector at lower right
			//-----------------------------------------------

			//-----------------------------------------------
			//	RJ45 LEDs [Bank 2 Left Top]
			//-----------------------------------------------
			RJ45_TRC_,	// OUT(2b), LEDs on the Top Right
			RJ45_BRC_,	// OUT(2b), LEDs on the Bottom Right
			RJ45_TLC_,	// OUT(2b), LEDs on the Top Left
			RJ45_BLC_,	// OUT(2b), LEDs on the Bottom Left
			//-----------------------------------------------

			//-----------------------------------------------
			//	Ethernet Physical Layer [Bank 0,1 Top]
			//-----------------------------------------------
			// These signals provide a serial readout of the Ethernet
			// chips LED outputs.  The chip will drive the PHY_LEDENA
			// output high and then clock out 24bits of LED status
			// data, driving both PHY_LEDDAT and PHY_LEDCLK
			PHY_LEDCLK,	// IN(1b), Clock
			PHY_LEDDAT,	// IN(1b), Data
			PHY_LEDENA,	// IN(1b), Enable

			PHY_ADD,	// OUT(3b), Address set (0 for CalLinx)

			PHY_MDIO,	// INOUT(1b), MII Data Bus
			PHY_MDINT_,	// IN(1b), MII Control Interrupt
			PHY_MDC,	// OUT(1b), MII Clock
			PHY_MDDIS,	// OUT(1b), MII Disable

			PHY_PWRDN,	// OUT(1b), Powerdown Control
			PHY_RESET,	// OUT(1b), Active Low Reset
			PHY_FDE,	// OUT(1b), Full Duplex Enable
			PHY_AUTOENA,	// OUT(1b), Auto Negotiation Enable
			PHY_BYPSCR,	// OUT(1b), Bypass Scrambler
			PHY_CFG,	// OUT(3b), Phy Chip config lines

			PHY_LED0_,	// IN(3b), LEDs for port 0
			PHY_LED1_,	// IN(3b), LEDs for port 1
			PHY_LED2_,	// IN(3b), LEDs for port 2
			PHY_LED3_,	// IN(3b), LEDs for port 3
			PHY_RXD0,	// IN(4b), Receive Data port 0
			PHY_RXD1,	// IN(4b), Receive Data port 1
			PHY_RXD2,	// IN(4b), Receive Data port 2
			PHY_RXD3,	// IN(4b), Receive Data port 3
			PHY_RX_DV,	// IN(4b), Receive Data Valid[Port]
	   		PHY_RX_CLK,	// IN(4b), Receive Data Clock[Port]
			PHY_RX_ER,	// IN(4b), Receive Error[Port]
			PHY_TX_ER,	// OUT(4b), Transmit Error[Port]
	   		PHY_TX_CLK,	// IN(4b), Transmit Data Clock[Port]
			PHY_TX_EN,	// OUT(4b), Transmit Data Clock[Port]
			PHY_TXD0,	// OUT(4b), Transmit Data port 0
			PHY_TXD1,	// OUT(4b), Transmit Data port 1
			PHY_TXD2,	// OUT(4b), Transmit Data port 2
			PHY_TXD3,	// OUT(4b), Transmit Data port 4
	   		PHY_COL,	// IN(4b), Collision Detect
  			PHY_CRS,	// IN(4b), Carrier Sense
			PHY_TRSTE,	// OUT(4b), Tristate Control[Port]
			//-----------------------------------------------

			//-----------------------------------------------
			//	Audio Codec [Bank 1 Top-Left]
			//-----------------------------------------------
			AP_SDATA_OUT,	// OUT(1b), AC97 Serial Data Output
			AP_BIT_CLOCK,	// IN(1b), 12.288MHz bit clock
			AP_SDATA_IN,	// IN(1b), AC97 Serial Data Input
			AP_SYNC,	// OUT(1b), AC97 Serial interface sync
			AP_RESET_,	// OUT(1b), Audio Codec Reset
			AP_PC_BEEP,	// OUT(1b), Used to generate beeps
			AA_MUTE,	// OUT(1b), Audio Amp Mute
			//-----------------------------------------------

			//-----------------------------------------------
			//	SDRAM [Bank 7 Top-Right]
			//-----------------------------------------------
			RAM1_DQ,	// INOUT(32b), Data Bus
			RAM1_CLK,	// OUT(1b), Clock
			RAM1_CLKE,	// OUT(1b), Clock Enable
			RAM1_DQMH,	// OUT(1b), Mask the high byte of RAM1_DQ
			RAM1_DQML,	// OUT(1b), Mask the low byte of RAM1_DQ
			RAM1_CS_,	// OUT(1b), Chip Select
			RAM1_RAS_,	// OUT(1b), Row Address Select
			RAM1_CAS_,	// OUT(1b), Column Address Select
			RAM1_WE_,	// OUT(1b), Write Enable
			RAM1_BA,	// OUT(2b), Bank Address
			RAM1_A,		// OUT(12b), Address

			RAM2_DQ,	// INOUT(32b), Data Bus
			RAM2_CLK,	// OUT(1b), Clock
			RAM2_CLKE,	// OUT(1b), Clock Enable
			RAM2_DQMH,	// OUT(1b), Mask the high byte of RAM2_DQ
			RAM2_DQML,	// OUT(1b), Mask the low byte of RAM2_DQ
			RAM2_CS_,	// OUT(1b), Chip Select
			RAM2_RAS_,	// OUT(1b), Row Address Select
			RAM2_CAS_,	// OUT(1b), Column Address Select
			RAM2_WE_,	// OUT(1b), Write Enable
			RAM2_BA,	// OUT(2b), Bank Address
			RAM2_A,		// OUT(12b), Address
			//-----------------------------------------------

			//-----------------------------------------------
			//	Buttons and DIPSwitches [Bank 7,6 Right]
			//-----------------------------------------------
			SW9_,		// IN(8b), Active Low DIP Switch #9
			SW10_,		// IN(8b), Active Low DIP Switch #10
			SW_,		// IN(8b), Active Low Push Buttons
			//-----------------------------------------------

			//-----------------------------------------------
			//	System ACE Chip [Bank 2 Left-Top]
			//-----------------------------------------------
			ACE_MPBRDY,
			ACE_MPIRQ,
			ACE_MPCE_B,
			ACE_MPWE_B,
			ACE_MPOE_B,
			ACE_MPA,	// (7b)
			ACE_MPD,	// (16b)
			//-----------------------------------------------

			//-----------------------------------------------
			//	Video Encoder [Bank 3 Left-Bottom]
			//-----------------------------------------------
			VE_P,		// OUT(10b), ITU656/601 Video Data Out
			VE_SCLK,	// INOUT(1b), I2C Clock
			VE_SDA,		// INOUT(1b), I2C Data
			VE_PAL_NTSC,	// OUT(1b), PAL/NTSC Video Standard Select
			VE_RESET_B_,	// OUT(1b), Reset
			VE_HSYNC_B_,	// OUT(1b), Ununsed
			VE_VSYNC_B_,	// OUT(1b), Ununsed
			VE_BLANK_B_,	// OUT(1b), Ununsed
			VE_SCRESET,	// OUT(1b), Ununsed
			VE_CLKIN,	// OUT(1b), Clock out the ADV7194
			//-----------------------------------------------

			//-----------------------------------------------
			//	Video Decoder [Bank 3 Left-Bottom]
			//-----------------------------------------------
			VD_LLC,		// IN(2b), Line Locked Clocks
			VD_P,		// IN(10b), ITU656/601 Video Data In
			VD_SCLK,	// INOUT(1b), I2C Clock
			VD_SDA,		// INOUT(1b), I2C Data
			VD_ISO,		// OUT(1b), Input Switchover
			VD_RESET_B_,	// OUT(1b), Reset
			VD_XTAL,	// OUT(1b), Clock output

			VD_AEF,
			VD_AFF,
			VD_CLKIN,
			VD_DV,
			VD_HFF,
			VD_RD,
			//-----------------------------------------------

			//-----------------------------------------------
			//	USB Interface
			//-----------------------------------------------
			USB_MODE,
			USB_SPEED,
			USB_SUSPEND,

			USB_RCV,
			USB_VM,
			USB_VP,

			USB_OE_,
			USB_VMO_FSEO,
			USB_VPO,
			//-----------------------------------------------

			//-----------------------------------------------
			//	General Purpose LEDs
			//-----------------------------------------------
			LED_,		// OUT(8b), D1-D8 Active Low LEDs
			//-----------------------------------------------

			//-----------------------------------------------
			//	7 Segment LEDs x8 [Bank 4,5 Bottom]
			//-----------------------------------------------
			SEG1,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG2,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG3,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG4,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG5,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG6,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG7,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG8,		// OUT(7b), Active High (MSb is Seg 'a')
			SEG_POINT,	// OUT(8b), Active High (MSb is SEG8_)
			SEG_COM_,	// OUT(8b), Active Low (MSb is SEG8_)
			//-----------------------------------------------

			//-----------------------------------------------
			//	Analog to Digital Converter
			//-----------------------------------------------
			ADC_CS,		// OUT(1b), Active Low Chip Select
			ADC_DIN,	// OUT(1b), Data to the ADC
			ADC_SCLK,	// OUT(1b), SPI Clock
			ADC_DOUT,	// IN(1b), Data from the ADC
			//-----------------------------------------------

			//-----------------------------------------------
			//	16x2 Character LCD
			//-----------------------------------------------
			LCD_DB,		// INOUT(8b), Data Bus
			LCD_E,		// OUT(1b), Enable
			LCD_RW,		// OUT(1b), Read/~Write
			LCD_RS,		// OUT(1b), Register Select
			LCD_BACKLIGHT,	// OUT(1b), Backlight Control
			//-----------------------------------------------

			//-----------------------------------------------
			//	PS/2 Port
			//-----------------------------------------------
			PS2_CLK,	// INOUT(1b), Clock from the PS2 Device
			PS2_DQ,		// INOUT(1b), Serial Data
			//-----------------------------------------------

			//-----------------------------------------------
			//	Chipcon CC2420 802.15.4 RF Transceiver
			//-----------------------------------------------
			RF_RESET_,	// OUT(1b), Active Low Reset
			RF_SFD,		// IN(1b), Start Frame Delimeter
			RF_CCA,		// IN(1b), Clear Channel Assesment
			RF_FIFOP,	// IN(1b), RX FIFO Status
			RF_FIFO,	// IN(1b), RX FIFO Status
			RF_CS_,		// OUT(1b), Active Low Chip Select
			RF_SCLK,	// OUT(1b), SPI Clock
			RF_SI,		// OUT(1b), SPI Data
			RF_SO,		// IN(1b), SPI Data
			RF_VREG_EN,	// OUT(1b), Voltage Regulator Enable
			//-----------------------------------------------

			//-----------------------------------------------
			//	Serial Ports
			//-----------------------------------------------
			COM1_RX,
			COM1_TX,
			COM2_TX,
			COM_Invalid_,
			COM2_RX,
			//-----------------------------------------------

			//-----------------------------------------------
			//	N64 Controllers
			//-----------------------------------------------
			N64_DQ,
			//-----------------------------------------------

			//-----------------------------------------------
			//	Test-Point Headers Around FPGA
			//-----------------------------------------------
			PINOUT_TOP,
			PINOUT_BOTTOM_CLOSE,
			PINOUT_BOTTOM_FAR,
			PINOUT_RIGHT
			//-----------------------------------------------
	); /* synthesis syn_noprune=1 */

	//---------------------------------------------------------------
	//	Clock Inputs
	//---------------------------------------------------------------
	input			Y5_CLK;			/*synthesis xc_loc = "A20"*/
	input			Y4_CLK;			/*synthesis xc_loc = "AU22"*/
	input			Y3_CLK;			/*synthesis xc_loc = "D21"*/
	input			J18_CLK;		/*synthesis xc_loc = "AW19"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	RJ45 LEDs
	//---------------------------------------------------------------
	output	[2:1]		RJ45_TRC_;		/*synthesis xc_loc = "E1,D3"*/
	output	[2:1]		RJ45_BRC_;		/*synthesis xc_loc = "F1,E2"*/
	output	[2:1]		RJ45_TLC_;		/*synthesis xc_loc = "F3,F2"*/
	output	[2:1]		RJ45_BLC_;		/*synthesis xc_loc = "G1,F4"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Ethernet Physical Layer
	//---------------------------------------------------------------
	input 	 		PHY_LEDCLK;		/*synthesis xc_loc = "D14"*/
	input			PHY_LEDDAT;		/*synthesis xc_loc = "A15"*/
	input			PHY_LEDENA;		/*synthesis xc_loc = "B15"*/

	output	[4:2]		PHY_ADD;		/*synthesis xc_loc = "A16,D15,C15"*/

	inout			PHY_MDIO;		/*synthesis xc_loc = "B32"*/
	input			PHY_MDINT_;		/*synthesis xc_loc = "A32"*/
	output			PHY_MDC;		/*synthesis xc_loc = "D33"*/
	output			PHY_MDDIS;		/*synthesis xc_loc = "C33"*/

	output			PHY_PWRDN;		/*synthesis xc_loc = "B33"*/
	output			PHY_RESET;		/*synthesis xc_loc = "A34"*/
	output			PHY_FDE;		/*synthesis xc_loc = "D35"*/
	output			PHY_AUTOENA;		/*synthesis xc_loc = "C35"*/
	output			PHY_BYPSCR;		/*synthesis xc_loc = "B35"*/
	output	[2:0]		PHY_CFG;		/*synthesis xc_loc = "A35,B36,A36"*/

	input	[2:0]		PHY_LED0_;		/*synthesis xc_pullup = 1 xc_loc = "C14,B14,A14"*/
	input	[2:0]		PHY_LED1_;		/*synthesis xc_pullup = 1 xc_loc = "D13,C13,B13"*/
	input	[2:0]		PHY_LED2_;		/*synthesis xc_pullup = 1 xc_loc = "A13,C12,B12"*/
	input	[2:0]		PHY_LED3_;		/*synthesis xc_pullup = 1 xc_loc = "A12,D11,C11"*/

	input	[3:0]		PHY_RXD0;		/*synthesis xc_loc = "B16,C16,D16,A17"*/
	input	[3:0]		PHY_RXD1;		/*synthesis xc_loc = "D19,C21,B20,B21"*/
	input	[3:0]		PHY_RXD2;		/*synthesis xc_loc = "C24,B24,A24,D25"*/
	input	[3:0]		PHY_RXD3;		/*synthesis xc_loc = "B28,A28,D29,C29"*/
	input	[3:0]		PHY_RX_DV;		/*synthesis xc_loc = "B29,C25,A21,B17"*/
	input	[3:0]		PHY_RX_CLK;		/*synthesis syn_noclockbuf = 1 xc_loc = "A29,B25,E22,C17"*/
	input	[3:0]		PHY_RX_ER;		/*synthesis xc_loc = "D30,A25,D22,D17"*/
	output	[3:0]		PHY_TX_ER;		/*synthesis xc_loc = "C30,D26,C22,E17"*/
	input	[3:0]		PHY_TX_CLK;		/*synthesis syn_noclockbuf = 1 xc_loc = "B30,C26,B22,A18"*/
	output	[3:0]		PHY_TX_EN;		/*synthesis xc_loc = "A30,B26,A22,B18"*/
	output	[3:0]		PHY_TXD0;		/*synthesis xc_loc = "A19,E18,D18,C18"*/
	output	[3:0]		PHY_TXD1;		/*synthesis xc_loc = "B23,C23,D23,E23"*/
	output	[3:0]		PHY_TXD2;		/*synthesis xc_loc = "B27,C27,D27,A26"*/
	output	[3:0]		PHY_TXD3;		/*synthesis xc_loc = "A31,B31,C31,D31"*/
	input	[3:0]		PHY_COL;		/*synthesis xc_loc = "D32,A27,A23,B19"*/
	input	[3:0]		PHY_CRS;		/*synthesis xc_loc = "C32,C28,D24,C19"*/
	output	[3:0]		PHY_TRSTE;		/*synthesis xc_loc = "A33,D34,C34,B34"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Audio Codec
	//---------------------------------------------------------------
	output			AP_SDATA_OUT;		/*synthesis xc_loc = "A4"*/
	input			AP_BIT_CLOCK;		/*synthesis xc_loc = "A5"*/
	input			AP_SDATA_IN;		/*synthesis xc_loc = "B5"*/
	output			AP_SYNC;		/*synthesis xc_loc = "C5"*/
	output			AP_RESET_;		/*synthesis xc_loc = "A6"*/
	output			AP_PC_BEEP;		/*synthesis xc_loc = "B6"*/
	output			AA_MUTE;		/*synthesis xc_loc = "D1"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	SDRAM
	//---------------------------------------------------------------
	inout	[15:0]		RAM1_DQ;		/*synthesis xc_loc = "G36,G37,G38,G39,F36,F37,F38,F39,E37,E38,E39,D37,D38,D39,C38,B37"*/
	output			RAM1_CLK;		/*synthesis xc_loc = "N38"*/
	output			RAM1_CLKE;		/*synthesis xc_loc = "N39"*/
	output			RAM1_DQMH;		/*synthesis xc_loc = "N37"*/
	output			RAM1_DQML;		/*synthesis xc_loc = "N36"*/
	output			RAM1_CS_;		/*synthesis xc_loc = "W37"*/
	output			RAM1_RAS_;		/*synthesis xc_loc = "P37"*/
	output			RAM1_CAS_;		/*synthesis xc_loc = "P38"*/
	output			RAM1_WE_;		/*synthesis xc_loc = "P39"*/
	output	[1:0]		RAM1_BA;		/*synthesis xc_loc = "AA37,W36"*/
	output	[12:0]		RAM1_A;			/*synthesis xc_loc = "AC36,AC35,AB39,AB38,AB37,AB36,AB35,AA39,AA38,AA36,Y39,Y38,W39"*/

	inout	[15:0]		RAM2_DQ;		/*synthesis xc_loc = "L36,L37,L38,L39,K36,K37,K38,K39,J36,J37,J38,J39,H36,H37,H38,H39"*/
	output			RAM2_CLK;		/*synthesis xc_loc = "M39"*/
	output			RAM2_CLKE;		/*synthesis xc_loc = "M38"*/
	output			RAM2_DQMH;		/*synthesis xc_loc = "M37"*/
	output			RAM2_DQML;		/*synthesis xc_loc = "P36"*/
	output			RAM2_CS_;		/*synthesis xc_loc = "R36"*/
	output			RAM2_RAS_;		/*synthesis xc_loc = "R37"*/
	output			RAM2_CAS_;		/*synthesis xc_loc = "R38"*/
	output			RAM2_WE_;		/*synthesis xc_loc = "R39"*/
	output	[1:0]		RAM2_BA;		/*synthesis xc_loc = "T38,T39"*/
	output	[12:0]		RAM2_A;			/*synthesis xc_loc = "W38,V35,V36,V37,V38,V39,U35,U36,U37,U38,U39,T36,T37"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Buttons and DIP Switches
	//---------------------------------------------------------------
	input	[8:1]		SW9_;			/*synthesis xc_loc = "AN37,AN36,AM39,AM38,AM37,AM36,AL39,AL38"*/
	input	[8:1]		SW10_;			/*synthesis xc_loc = "AR37,AR36,AP39,AP38,AP37,AP36,AN39,AN38"*/
	input	[8:1]		SW_;			/*synthesis xc_loc = "AT39,AT38,AR39,AR38,AF36,AE39,AE38,AE37"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	System ACE Chip
	//---------------------------------------------------------------
	input			ACE_MPBRDY;		/*synthesis xc_loc = "M2"*/
	output			ACE_MPIRQ;		/*synthesis xc_loc = "M3"*/
	output			ACE_MPCE_B;		/*synthesis xc_loc = "N1"*/
	output			ACE_MPWE_B;		/*synthesis xc_loc = "N2"*/
	output			ACE_MPOE_B;		/*synthesis xc_loc = "N3"*/
	output	[6:0]		ACE_MPA;		/*synthesis xc_loc = "T1,R4,R3,R2,P2,P1,N4"*/
	inout	[15:0]		ACE_MPD;		/*synthesis xc_loc = "W4,W3,W2,V5,V4,V3,V2,V1,U5,U4,U3,U2,U1,T4,T3,T2"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Video Encoder
	//---------------------------------------------------------------
	output	[9:0]		VE_P;			/*synthesis xc_loc = "AM3,AM4,AL1,AL2,AL3,AL4,AK1,AK2,AK3,AK4"*/
	inout			VE_SCLK;		/*synthesis xc_loc = "AM2" xc_pullup = 1*/
	inout			VE_SDA;			/*synthesis xc_loc = "AM1" xc_pullup = 1*/
	output			VE_PAL_NTSC;		/*synthesis xc_loc = "AN4"*/
	output			VE_RESET_B_;		/*synthesis xc_loc = "AN3"*/
	output			VE_HSYNC_B_;		/*synthesis xc_loc = "AN2"*/
	output			VE_VSYNC_B_;		/*synthesis xc_loc = "AN1"*/
	output			VE_BLANK_B_;		/*synthesis xc_loc = "AP4"*/
	output			VE_SCRESET;		/*synthesis xc_loc = "AP3"*/
	output			VE_CLKIN;		/*synthesis xc_loc = "AP2"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Video Decoder
	//---------------------------------------------------------------
	input	[2:1]		VD_LLC;			/*synthesis xc_loc = "AA3,AB2"*/
	input	[9:0]		VD_P;			/*synthesis xc_loc = "AC5,AB1,AB3,AB4,AB5,AA1,AA2,Y1,Y2,W1"*/
	inout			VD_SCLK;		/*synthesis xc_loc = "AC4" xc_pullup = 1*/
	inout			VD_SDA;			/*synthesis xc_loc = "AC3" xc_pullup = 1*/
	output			VD_ISO;			/*synthesis xc_loc = "AC2"*/
	output			VD_RESET_B_;		/*synthesis xc_loc = "AC1"*/
	output			VD_XTAL;		/*synthesis xc_loc = "AA4"*/

	output			VD_AEF;			/*synthesis xc_loc = "D6"*/
	output			VD_AFF;			/*synthesis xc_loc = "B7"*/
	output			VD_CLKIN;		/*synthesis xc_loc = "C6"*/
	output			VD_DV;			/*synthesis xc_loc = "C7"*/
	output			VD_HFF;			/*synthesis xc_loc = "A7"*/
	output			VD_RD;			/*synthesis xc_loc = "D7"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	USB Interface (CHECK THIS)
	//---------------------------------------------------------------
	output			USB_MODE;		/*synthesis xc_loc = "A10"*/
	output			USB_SPEED;		/*synthesis xc_loc = "D8"*/
	output			USB_SUSPEND;		/*synthesis xc_loc = "A9"*/

	input			USB_RCV;		/*synthesis xc_loc = "C8"*/
	input			USB_VM;			/*synthesis xc_loc = "C9"*/
	input			USB_VP;			/*synthesis xc_loc = "B9"*/

	output			USB_OE_;		/*synthesis xc_loc = "D9"*/
	output			USB_VMO_FSEO;		/*synthesis xc_loc = "B8"*/
	output			USB_VPO;		/*synthesis xc_loc = "A8"*/
	//---------------------------------------------------------------	

	//---------------------------------------------------------------
	//	General Purpose LEDs
	//---------------------------------------------------------------
	output	[8:1]		LED_;			/*synthesis xc_loc = "AE36,AD39,AD38,AD37,AD36,AC39,AC38,AC37"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	7 segment LEDs x8
	//---------------------------------------------------------------
	output	[6:0]		SEG1;			/*synthesis xc_loc = "AV8,AW8,AU8,AT8,AV9,AU9,AT9"*/
	output	[6:0]		SEG2;			/*synthesis xc_loc = "AU10,AV10,AT10,AW11,AU11,AT11,AW12"*/
	output	[6:0]		SEG3;			/*synthesis xc_loc = "AT18,AR18,AU18,AV18,AR17,AT17,AU17"*/
	output	[6:0]		SEG4;			/*synthesis xc_loc = "AU21,AT19,AT21,AV20,AV21,AW21,AR22"*/
	output	[6:0]		SEG5;			/*synthesis xc_loc = "AW28,AT29,AV28,AU28,AV27,AU27,AT27"*/
	output	[6:0]		SEG6;			/*synthesis xc_loc = "AT31,AU31,AW30,AV30,AT30,AW29,AV29"*/
	output	[6:0]		SEG7;			/*synthesis xc_loc = "AU33,AV33,AT33,AW32,AU32,AT32,AW31"*/
	output	[6:0]		SEG8;			/*synthesis xc_loc = "AU36,AV36,AW35,AV35,AV34,AU34,AT34"*/
	output	[8:1]		SEG_POINT;		/*synthesis xc_loc = "AW34,AV32,AU30,AW27,AW20,AW18,AV11,AW9"*/
	output	[8:1]		SEG_COM_;		/*synthesis xc_loc = "AW36,AW33,AV31,AU29,AU19,AV19,AW10,AT7"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Analog to Digital Converter
	//---------------------------------------------------------------
	output			ADC_CS;			/*synthesis xc_loc = "AD4"*/
	output			ADC_DIN;		/*synthesis xc_loc = "AD2"*/
	output			ADC_SCLK;		/*synthesis xc_loc = "AD1"*/
	input			ADC_DOUT;		/*synthesis xc_loc = "AE4"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	16x2 Character LCD
	//---------------------------------------------------------------
	inout	[7:0]		LCD_DB;			/*synthesis xc_loc = "AE3,AE2,AE1,AF4,AF3,AF2,AF1,AG4"*/
	output			LCD_E;			/*synthesis xc_loc = "AG1"*/
	output			LCD_RW;			/*synthesis xc_loc = "AG3"*/
	output			LCD_RS;			/*synthesis xc_loc = "AH3"*/
	output			LCD_BACKLIGHT;		/*synthesis xc_loc = "AH2"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	PS/2 Port
	//---------------------------------------------------------------
	inout			PS2_CLK;		/*synthesis xc_loc = "AJ4" xc_pullup = 1*/
	inout			PS2_DQ;			/*synthesis xc_loc = "AJ3" xc_pullup = 1*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Chipcon CC2420 802.15.4 RF Transceiver
	//---------------------------------------------------------------
	output			RF_RESET_;		/*synthesis xc_loc = "AP1"*/
	input			RF_SFD;			/*synthesis xc_loc = "AR3"*/
	input			RF_CCA;			/*synthesis xc_loc = "AR2"*/
	input			RF_FIFOP;		/*synthesis xc_loc = "AR1"*/
	inout			RF_FIFO;		/*synthesis xc_loc = "AT3"*/
	output			RF_CS_;			/*synthesis xc_loc = "AT2"*/
	output			RF_SCLK;		/*synthesis xc_loc = "AT1"*/
	output			RF_SI;			/*synthesis xc_loc = "AV3"*/
	input			RF_SO;			/*synthesis xc_loc = "AW4"*/
	output			RF_VREG_EN;		/*synthesis xc_loc = "AV4"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Serial Ports
	//---------------------------------------------------------------
	input			COM1_RX;		/*synthesis xc_loc = "AV5"*/
	output			COM1_TX;		/*synthesis xc_loc = "AW6"*/
	output			COM2_TX;		/*synthesis xc_loc = "AV6"*/
	input			COM_Invalid_;		/*synthesis xc_loc = "AU6"*/
	input			COM2_RX;		/*synthesis xc_loc = "AT6"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	N64 Controllers
	//---------------------------------------------------------------
	inout	[2:1]		N64_DQ;			/*synthesis xc_loc = "AU7,AV7"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Debug Headers   
	//---------------------------------------------------------------
	inout	[19:0]		PINOUT_TOP;		/*synthesis xc_loc = "M1,L4,L3,L2,L1,K4,K3,K2,K1,J4,J3,J2,J1,H4,H3,H2,H1,G4,G3,G2"*/
	inout	[19:0]		PINOUT_BOTTOM_CLOSE;	/*synthesis xc_loc = "AT22,AV22,AW22,AR23,AT23,AU23,AV23,AW23,AT24,AU24,AV24,AW24,AT25,AU25,AV25,AW25,AT26,AU26,AV26,AW26"*/
	inout	[19:0]		PINOUT_BOTTOM_FAR;	/*synthesis xc_loc = "AV12,AU12,AW13,AV13,AU13,AT13,AW14,AV14,AU14,AT14,AW15,AV15,AU15,AT15,AW16,AV16,AU16,AT16,AW17,AV17"*/
	inout	[19:0]		PINOUT_RIGHT;		/*synthesis xc_loc = "AF37,AF38,AF39,AG36,AG37,AG38,AG39,AH37,AH38,AH39,AJ36,AJ37,AJ38,AJ39,AK36,AK37,AK38,AK39,AL36,AL37"*/
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Wires
	//---------------------------------------------------------------
	wire			Clock, Reset;
	wire switch2, switch3;
	//---------------------------------------------------------------
	
	
	//---------------------------------------------------------------
	//	ChipScope
	//---------------------------------------------------------------
	
	wire [35:0]		ILAControl;
	wire [31:0]		Data;
	wire [7:0]		curState;
	wire [7:0]		Debug;
	
	icon	i_icon(.control0(ILAControl));
	 
	 ila i_ila
    (
      .control(ILAControl),
      .clk(Clock),
      .trig0(Data)
    );
	
	

	//---------------------------------------------------------------
	//	Assigns
	//---------------------------------------------------------------
	assign	SEG_COM_ =			8'h00;
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//	Input Buffers
	//---------------------------------------------------------------
	BUFG		ClockBuf(.I(		Y5_CLK),
				.O(		Clock));

	ButtonParse	Parser1(	.In(		~SW_[1]),
				            .Out(		Reset),
				            .Clock(		Clock),
				            .Reset(		1'b0),
				            .Enable(	1'b1)),
					Parser2(	.In(		~SW_[2]),
				            .Out(		switch2),
				            .Clock(		Clock),
				            .Reset(		1'b0),
				            .Enable(	1'b1)),
					Parser3(	.In(		~SW_[3]),
				            .Out(		switch3),
				            .Clock(		Clock),
				            .Reset(		1'b0),
				            .Enable(	1'b1));
	defparam	Parser1.width =		1,
	         Parser2.width =		1,
				Parser3.width =		1;
	//---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//	Chipcon
	//---------------------------------------------------------------
	
	//---Wire & reg declarations
	reg  [255:0] lastBigOut;
	reg  [31:0]	errCount;
	reg  [31:0]	count;
	wire [31:0] out;
	wire [23:0] countTxTimes;
	wire [23:0] countSend;
	wire [7:0] srcAddr, destAddr;
	wire [3:0] channel;
	wire [1:0] countDisp; 
	wire EndSession;
	wire sfdDelay, ccaDelay, fifoDelay, fifopDelay,
	     newData, ready, start, startDelay,
		  chInputEn, addrEn,
		  send;	

	reg [6:0] SEG1, SEG2;
	reg [3:0] dispThr, dispFou, dispFiv, dispSix, dispSev, dispEig;
   reg rEn;
	//---

   //---IO registers for signals from CC2420
	IORegister sfdDelay(.Clock(Clock), .Reset(Reset),
	                    .Set(1'b0), .Enable(1'b1),
							  .In(RF_SFD), .Out(sfdDelay)),
				  ccaDelay(.Clock(Clock), .Reset(Reset),
	                    .Set(1'b0), .Enable(1'b1),
							  .In(RF_CCA), .Out(ccaDelay)),
				  fifoDelay(.Clock(Clock), .Reset(Reset),
	                     .Set(1'b0), .Enable(1'b1),
							   .In(RF_FIFO), .Out(fifoDelay)),
				  fifopDelay(.Clock(Clock), .Reset(Reset),
	                      .Set(1'b0), .Enable(1'b1),
							    .In(RF_FIFOP), .Out(fifopDelay));

	
   //---Transceiver instantiation  
	wire [255:0] OutBig;
	
	reg  [255:0] BigIn;
	wire [7:0] mysrc;
	wire [7:0] mydst;
	wire [7:0] SenderAddr;
	wire [7:0] RecipientAddr;
	
	Tranceiver chipcon(	
							 .Channel(~SW9_[8:5]),												        	//channel
                      .SrcAddr({4'hF, ~SW10_[8:5]}), .DestAddr({4'hF, ~SW10_[4:1]}),	//addressing			    
						    .FIFO(fifoDelay), .FIFOP(fifopDelay),						           	//status indicators
							 .SFD(sfdDelay), .CCA(ccaDelay),
						    .SClk(RF_SCLK), .CS_(RF_CS_), .SI(RF_SI), .SO(RF_SO),           	//SPI interface
						    .VReg_En(RF_VREG_EN), .Rf_Reset_(RF_RESET_),			           	//init. signals
						    .Clock(Clock), .Reset(Reset), 
							 
							 //Interface:
							 .BigIn(BigIn), .Ready(ready), .Start((count == 0)),
							 .OutBig(OutBig), .EndSession(EndSession),
							 .SenderAddr(SenderAddr), .RecipientAddr(RecipientAddr));

	always @ (posedge Clock) begin
		if (Reset) begin
			count <= 0;
			BigIn <= 0;
			errCount <= 0;
			lastBigOut <= 0;
		end
		else begin
			count <= count + 1;
			if (count == (~SW9_[3] ? 32'd108000 : 32'd1080000)) begin										// SW10_[3] toggles between 250 and 25 packets/sec
				count <= 0;
				BigIn <= BigIn + 1;
			end
		end
		if (EndSession) begin
			errCount <= (OutBig == 0 | lastBigOut == 0) ? 0 : errCount + (OutBig + ~lastBigOut);	// Count if not first packet and value gap > 1
			lastBigOut <= OutBig;
			dispEig <= OutBig[3:0];
			dispSev <= OutBig[7:4];
			dispSix <= OutBig[11:8];
			dispFiv <= OutBig[15:12];
			dispFou <= OutBig[19:16];
			dispThr <= OutBig[23:20];
		end
	end

	Bin2HexLED thr(.Bin(~SW9_[1] ? dispThr : ~SW9_[2] ? errCount[23:20] : BigIn[23:20]), .SegLED(SEG3)),
	           fou(.Bin(~SW9_[1] ? dispFou : ~SW9_[2] ? errCount[19:16] : BigIn[19:16]), .SegLED(SEG4)), 
				  fiv(.Bin(~SW9_[1] ? dispFiv : ~SW9_[2] ? errCount[15:12] : BigIn[15:12]), .SegLED(SEG5)),
	           six(.Bin(~SW9_[1] ? dispSix : ~SW9_[2] ? errCount[11:8] : BigIn[11:8]), .SegLED(SEG6)),
	           sev(.Bin(~SW9_[1] ? dispSev : ~SW9_[2] ? errCount[7:4] : BigIn[7:4]), .SegLED(SEG7)),
	           eig(.Bin(~SW9_[1] ? dispEig : ~SW9_[2] ? errCount[3:0] : BigIn[3:0]), .SegLED(SEG8));
	
   //---Quick visual indicator of reception status & RX FIFO overflow
	assign LED_[8:1] = ~{RF_FIFO,6'b0,RF_FIFOP};
   //---

endmodule
//-----------------------------------------------------------------------