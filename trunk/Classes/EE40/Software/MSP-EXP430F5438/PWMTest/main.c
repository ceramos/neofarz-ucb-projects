#include <msp430x54x.h>
#include "MSP-EXP430F5438 HAL\hal_MSP-EXP430F5438.h"

/**********************************************************************//**
 * @brief  Checks for the board revision and returns a value < 0 if wrong
 *         revision is specified in main.c 
 * 
 * @param  none 
 *  
 * @return Whether or not the board revision matches the software
 * - 0 - The board revision does not match the software
 * - 1 - The board revision matches the software
 *************************************************************************/
unsigned char assert_board_version( void ) {
  P8DIR &= ~BIT7;                           // Set P8.7 input
  P8OUT |= BIT7;                            // Set pullup resistor
  P8REN |= BIT7;                            // Enable pull up resistors 
  
  #ifdef REV_02
    if(!(P8IN & BIT7))                      // Board rev = 0_02? 
      return 0;
  #else 
    if((P8IN & BIT7))                       // Board rev = 0_03? 
      return 0;
  #endif    
  
  P8DIR |= BIT7;                            // Set P8.7 output
  P8OUT &= ~BIT7;                           // Set P8.7 = 0 
  P8REN &= ~BIT7;                           // Disable pull up resistors   

  return 1; 
}


int main( void ) {
  char color = 0x04;
  /* Check for the version of the board */ 
  /*
  if(!assert_board_version())
    while(1);  
  */
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;
  
  // Initialize the Board
  halBoardInit();
  
  //Initialize clock and peripherals 
  halBoardInit();  
  halBoardStartXT1();	
  halBoardSetSystemClock(SYSCLK_16MHZ);
    
  //Initialize LCD and backlight    
  halLcdInit();       
  halLcdBackLightInit();  
  halLcdClearScreen(); 
  
  //Initialize buttons
  halButtonsInit( BUTTON_ALL );
  //halButtonsInterruptEnable( BUTTON_ALL );
  
  while (1) {
    halLcdPrintXY("Sup, Bitches\0",8,20,color);
  }
  
  return 0;
}
