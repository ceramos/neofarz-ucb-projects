//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Firmware/SystemACE/Hardware/SysACERegAccess.v $
//	Version:	$Revision: 11035 $
//	Author:		Farzad Fatollahi-Fard (http://www.neofarz.com)
//	Copyright:	Copyright 2003-2009 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2003-2009, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

`timescale 1ns / 1ps

//------------------------------------------------------------------------------
//	Module:		Transceiver
//	Desc:		CC2420 Transceiver Interface
//------------------------------------------------------------------------------
module Transceiver	(
					// System
					Clock, Reset,
					
					// SPI
					SClk, CS_, SI, SO,
					
					// CC2420 Control Signals
					VReg_En, Rf_Reset_,
					FIFO, FIFOP, SFD, CCA,
					Channel, SrcAddr, DestAddr,
					
					// Random Crap
					BigIn, Ready, Start, OutBig, EndSession, SenderAddr, RecipientAddr
					);
	
	input Clock, Reset;
	output Ready;
	input Start;
	
	//SPI
	input SO;
	output SI, CS_, SClk;
	
	//Control
	output VReg_En, Rf_Reset_;
	input FIFO, FIFOP, SFD, CCA;
	input [3:0] Channel;
	input [7:0] SrcAddr, DestAddr;
	
	// Transmission
	input [255:0] BigIn;
	input Start;
	output Ready;
	
	// Receipt
	output [255:0] OutBig;
	output [7:0] SenderAddr, RecipientAddr;
	output EndSession;
	
endmodule
