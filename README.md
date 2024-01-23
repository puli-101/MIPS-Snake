Classic Snake Game

To execute: Open a 256x256 bitmap on a MIPS emulator (like Mars), then open the input window and execute the program.

Specifically, under the "Tools" tab open "Keyboard and Display MMIO Simulator" (for inputing under the KEYBOARD field) and "Bitmap Display" for displaying. Set up the display such that "Unit Width/Height in Pixels" is 16, "Display Width/Height in Pixels" is 256 and "Base address for display" is 0x10010000 (static data). Connect both MMIO Simulator and Display to MIPS and Assemble.

This project started as a coursework project at the University of Strasbourg. 

