@echo off
:loop
echo MSP-EXP430F5438 Programming Tool
echo Press CTRL+C to terminate job.
pause
DownloadTool.exe -f MSP-EXP430F5438.txt -w -v -g -i USB -t SBW4
goto loop

