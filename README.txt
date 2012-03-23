requirements:
- Python: 
         Matplotlib
         Numpy


The Antara we are trying to match impedance to is described above.

7599 tuyau 4 ouvert. two measurements where performed, first one from 10 to 4000Hz and
second one from 3000Hz to 8000Hz in step of 1/10 hz. Average was applied in the 1Khz zone between the
measurements. Down-sample x10 was applied to the measurements to meet simulations requirement.

Geometrical Description: (don't speak french)

Diamètre de la cavité arrière a1 (mm)=18.000000
Diamètre de la cavité avant a2 (mm)=16.000000
Longueur de la cavité fermée l1 (mm)=21.400000
Longueur de la cavité ouverte l2 (mm)=13.000000

Assuming:

Length for first cavity: 13.0     [mm]
Length for the close cavity: 21.4 [mm]
Radius for first cavity: 9.0      [mm]
Radius for second cavity: 8.0     [mm]

Instructions:

1.- Check for the ZF.txt file generated in Matlab with the Antaras.m script. 
2.- always make clean the project, if it is the first time
3.- make plot, to compile the faust code into a C++ executable.
4.- python plot.py, to generate graphics.
5.- check for graphics generated inside /gen




