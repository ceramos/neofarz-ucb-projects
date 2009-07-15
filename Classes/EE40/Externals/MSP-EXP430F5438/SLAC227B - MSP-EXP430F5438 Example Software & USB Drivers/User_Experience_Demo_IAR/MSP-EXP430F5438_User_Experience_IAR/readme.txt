MSP-EXP430F5438 Experimenter's Board User Experience Demo

Author: D. Dang
Texas Instruments Inc.
Ver 1.00 - May 2008
Built with Code Composer Essentials CCE v3.2

TABLE OF CONTENTS:
1. Project File Listing
2. IAR Migration Consideration
2.1 Global Variable Initialization
2.2 Pointer Addressing for CPUX
2.2.1 Assigning a Pointer to a location less than 0xFFFF
2.2.2 Assigning a Pointer to a location greater than 0xFFF
2.2.3 Dereferencing a Pointer
2.3 Placing variables in INFOB Flash
********************************************************************************
1. Project File Listing:
PROJECT ROOT DIRECTORY:
|
|--MSP-EXP430F5438 HAL        : folder containing driver files (Hardware Abstraction Layer)
   |--cc2500.h                : header file for Chipcon CC2500 EMK or EZ430-RF daughterboard  
   |--hal_adc.h               : ADC driver header file     
   |--hal_adc.c               : ADC driver source file
   |--hal_board.h             : Ports/Power Management/Clock System header file
   |--hal_board.c             : Ports/Power Management/Clock System source file
   |--hal_buttons.h           : Button driver header file
   |--hal_buttons.c           : Button driver source file
   |--hal_lcd_fonts.h         : ASCII font for LCD 
   |--hal_lcd.h               : LCD driver header file
   |--hal_lcd.c               : LCD driver source file
   |--hal_rf.h                : RF driver header file
   |--hal_rf.c                : RF driver source file
   |--hal_usb.h               : USB driver header file
   |--hal_usb.c               : USB driver source file
   |--hal_MSP-EXP430F5438.h   : Master header file to be singly included in MSP-EXP430F5438 HAL project
|--UserExperienceDemo         : folder containing User Experience Code
   |--flashUtils.h            : Flash utilities header file
   |--flashUtils.c            : Flash utilities source file
   |--audio.c                 : Voice Recorder and Playback
   |--balanceBall.c           : Use accelerometer to control a ball on LCD 
   |--clock.c                 : Analog & digital clocks
   |--menuSetting.c           : Menu for user settings and calibrations
   |--PMM.c                   : Select VCORE and DCO speed in active mode
   |--usbTest.c               : UART USB communication with PC host
   |--UserExperience.c        : main file, GUI, menu, and event handlers.
|--main.c                     : calls UserExperience.c
|--disclaimer.txt             : TI disclaimer
|--readme.txt                 : this file

********************************************************************************
2. IAR Porting Migration
While CCEv3 and IAR are mostly compatible, there are still a few minor differences
that need to be addressed to make this code fully functional in IAR.
**********************************
2.1 Global Variable Initialization
CCEv3 does not initialize global variables unless specified. On the other hand, 
IAR zero-fills global variables by default at startup (CSTART). This process
takes place before the main program starts to run and hold the Watch Dog Timer. 
For large array in RAM (the LCD_MEM array), this variable initializing process 
might require longer time than allowed by Watch Dog Timer. This would result in 
a reset. 
To prevent this from happening in IAR, the low level intrinsic __no_init
can be used in the variable declaration to prevent initialization.
For example:
  __no_init int LCD_MEM[100*17];
Another solution for this problem is to use the low level intrinsic
__low_level_init() to stop the Watch Dog Timer before initializing the variables
For example:
void __low_level_init()
{
	WDTCTL = WDTPW + WDTHOLD;
}

**********************************
2.2 Pointer Addressing for CPUX

The difference in definition of pointer adressing methods in CCEv3 and IAR 
mainly affects DMA registers. 

2.2.1 Assigning a Pointer to a location less than 0xFFFF
In CCEv3:
  DMA0SA = (void (*)())ADC12MEM0_;          // Src address = ADC12 module
where ADC12MEM0_ is the address of register ADC12MEM0.
The equivalent C instruction for IAR would be:
  DMA0SA = (unsigned int)&ADC12MEM0;        // Src address = ADC12 module
  
2.2.2 Assigning a Pointer to a location greater than 0xFFFF
In CCEv3:
  DMA0DA = (void (*)())MemstartTest;
In IAR: 
  __data16_write_addr((unsigned short)&DMA0DA, MemstartTest );  

2.2.3 Dereferencing a Pointer
In CCEv3:
	TBCCR4 = (*( (unsigned char*)PlaybackPtr) );
In IAR:
	TBCCR4 = __data20_read_char(PlaybackPtr++  );	

2.3 Placing variables in INFOB Flash
This project stores ADC12 calibrations and user settings into INFOB Flash. In
CCEv3, this procedure requires three steps for each variable.
    i. Assign the variable into data section
       #pragma DATA_SECTION(variableName, ".infoB");
   ii. Allocate appropriate size in bits for the variable
       #pragma DATA_ALIGN(variableName, variableSize); //variableSize = 8-16-32 bits
  iii. Declare the variable
       int/char/long/etc variableName;
           		
In IAR, this procedure can be handled as follows.

#pragma dataseg=INFOB
__no_init int/char/long/etc firstVariableName;
__no_init int/char/long/etc secondVariableName;
. . .
#pragma dataseg=default
