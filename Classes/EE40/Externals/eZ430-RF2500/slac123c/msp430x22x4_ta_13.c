//******************************************************************************
//  MSP430F22x4 Demo - Timer_A, Toggle P1.1/TA0, Up/Down Mode, DCO SMCLK
//
//  Description: Toggle P1.1 using hardware TA0 output. Timer_A is configured
//  for up/down mode with TACCR0 defining period, TA0 also output on P1.1. In
//  this example, TACCR0 is loaded with 250 and TA0 will toggle P1.1 at
//  TACLK/2*250. Thus the output frequency on P1.1 will be the TACLK/1000.
//  No CPU or software resources required.
//  ACLK = n/a, SMCLK = MCLK = TACLK = default DCO ~1.2MHz
//  As coded with TACLK = SMCLK, P1.1 output frequency is ~1200000/1000
//
//           MSP430F22x4
//         -----------------
//     /|\|              XIN|-
//      | |                 |
//      --|RST          XOUT|-
//        |                 |
//        |         P1.1/TA0|--> SMCLK/1000
//
//  A. Dannenberg
//  Texas Instruments Inc.
//  April 2006
//  Built with CCE Version: 3.2.0 and IAR Embedded Workbench Version: 3.41A
//******************************************************************************
#include "msp430x22x4.h"

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD;                 // Stop WDT
  P1DIR |= 0x02;                            // P1.1 output
  P1SEL |= 0x02;                            // P1.1 option select
  TACCTL0 = OUTMOD_4;                       // TACCR0 toggle mode
  TACCR0 = 250;
  TACTL = TASSEL_2 + MC_3;                  // SMCLK, up-downmode

  __bis_SR_register(CPUOFF);                // CPU off
}
