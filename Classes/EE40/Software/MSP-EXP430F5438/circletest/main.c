
//#include "io430.h"
#include  <msp430x54x.h>
#include "MSP-EXP430F5438 HAL\hal_MSP-EXP430F5438.h"

void printChar(int input, int x, int y, char color)
{
  int b;
  char c[9];
  c[8]='\0';
  for(b=0; b<8; ++b)
  {
				c[b]='0'+(0x01 & (input>>(7-b)));
				halLcdPrintXY(c,x,y,color);
	}
}

void balanceBall(void)
{
  int x, y, dx, dy, dz, redrawCounter;
  unsigned char quit = 0;
  
  halAccelerometerInit();                     
  
  halButtonsInterruptDisable( BUTTON_ALL );
  halButtonsInterruptEnable( BUTTON_SELECT );
//  buttonsPressed  = 0;

  //Starting location of the Ball  
  x = 80;
  y = 16;
                   
  halLcdClearScreen();
//  halLcdImage(TI_BUG, 14, 106, 10, 0);  
  halLcdCircle( x, y, 2, PIXEL_ON);
      halLcdCircle( x, y, 3, PIXEL_ON);
      halLcdCircle( x, y, 4, PIXEL_ON);
      halLcdCircle( x, y, 5, PIXEL_ON);
      halLcdCircle( x, y, 6, PIXEL_ON);
//  RTCExit64Hz = 1;
//  RTCPS0CTL |= RT0PSIE; 
  redrawCounter = 0;
  halAdcSetQuitFromISR( 0 );

  dx=3;
  dy=2;
  
  while (!quit)  
  {
//    halAdcStartRead(); 
    
//    __bis_SR_register(LPM0_bits + GIE);      
//    __no_operation(); 
    
//    if (buttonsPressed & BUTTON_SELECT || buttonsPressed & BUTTON_S1)
  //    quit = 1;
      
//    halAccelerometerRead( &dx, &dy, &dz );   
//    dx >>= 5;
//    dy >>= 5;
    if ( ( ABS(dx) > 2 ) || ( ABS(dy) > 2 ) ) 
    {
      halLcdCircle( x, y, 7, PIXEL_OFF);
      halLcdCircle( x, y, 6, PIXEL_OFF);
      halLcdCircle( x, y, 5, PIXEL_OFF);
      halLcdCircle( x, y, 4, PIXEL_OFF);
      halLcdCircle( x, y, 3, PIXEL_OFF);
      halLcdCircle( x, y, 2, PIXEL_OFF);
      halLcdCircle( x, y, 1, PIXEL_OFF);
      x -= dx;
      y += dy;
      
      if (x<0 || x >= LCD_COL)   
      {
		x += dx;
	  	dx *= -1;
	  }
      if (y <0 || y >= LCD_ROW)
	  {
        y -= dy;
		dy *= -1;
	  }
     
      halLcdCircle( x, y, 2, PIXEL_ON);
      halLcdCircle( x, y, 3, PIXEL_ON);
      halLcdCircle( x, y, 4, PIXEL_ON);
      halLcdCircle( x, y, 5, PIXEL_ON);
      halLcdCircle( x, y, 6, PIXEL_ON);
    }
/*	if (++redrawCounter == 320)             //Redraw canvas after ~5s
	{
	  halLcdClearScreen();
  	  halLcdImage(TI_BUG, 14, 106, 10, 0);
  	  redrawCounter = 0;  			
  	  halLcdCircle( x, y, 2, PIXEL_ON);
      halLcdCircle( x, y, 3, PIXEL_ON);
      halLcdCircle( x, y, 4, PIXEL_ON);
      halLcdCircle( x, y, 5, PIXEL_ON);
      halLcdCircle( x, y, 6, PIXEL_ON);
	}*/
  }
  
//  RTCPS0CTL &= ~RT0PSIE; 
//  RTCExit64Hz = 0; 
}

void accelTest()
{ 
  int dx, dy, dz;
  halAccelerometerInit();                     
  
  halAdcSetQuitFromISR( 0 );
 
  while (1)  
  {
	halAdcStartRead(); 
    halAccelerometerRead( &dx, &dy, &dz );
	printChar(dx,8,20,0x04);
  }
}

int main( void )
{
  int i=10000;
  int b;
  char buttons;
  char color;
  char c[9];
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;
  
  //Initialize clock and peripherals 
  halBoardInit();	
  halBoardStartXT1();	
  halBoardSetSystemClock(SYSCLK_16MHZ);
  
//  loadSettings();
  
  //Initialize LCD and backlight 	 
  halLcdInit();			 
  halLcdBackLightInit();	
//  halLcdSetBackLight(lcdBackLightLevelSettingLOCAL);
//  halLcdSetContrast(lcdContrastSettingLOCAL);
  halLcdClearScreen(); 
//  halLcdImage(TI_BUG, 14, 106, 10, 0);
  
  //Initialize buttons
//  buttonDebounce = 1;
  halButtonsInit( BUTTON_ALL );
    halBoardInit();  
  halButtonsInit( BUTTON_ALL );
  halLcdInit();       
  halLcdClearScreen(); 
	c[8]='\0';
//	accelTest();  // display accelerometer value
  balanceBall();  // bouncing ball; accelerometer input removed
  // button testing routine
  	for(;;){
		i--;
		if(0==i && buttons != halButtonsPressed()){
//			halLcdPrint("The robots are comingAA",color);
//			halLcdPrintXY("The robots are comingAA",7,3,color);
			buttons=halButtonsPressed();
			for(b=0; b<8; ++b){
				c[b]='0'+(0x01 & (buttons>>b));
				halLcdPrintXY(c,8,20,color);
			}
			if(color == 0x04) color=0x05;
			else color=0x04;
			i=10000;
		}
	}

  return 0;
}
