import csv
import sys, os
import numpy as np
import matplotlib.pyplot as plt
from numpy import *
from numpy.fft import *

def read(filename):
    f = csv.reader(open(filename, 'rU')) 
    values = []
    for row in f:
        temp = [float(cell) for cell in row]
        values.append(temp)
    return values
    f.close()

def read_orig(origfile):
    z = []
    f = [] 
    f_orig = np.loadtxt(origfile,delimiter = '\t', usecols=(0,1), unpack=True)
    for i in range(0, len(f_orig[0,:])):
             z.append(f_orig[1,i])
             f.append(f_orig[0,i])            
             #print "frecuency : " + str(f_orig[0,i]) + " value : " + str(f_orig[1,i]) 
    return z, f    

def main():
    z_orig, f_orig = read_orig('src/ZF.txt')
    
    length1 = [ 0.214  ,   0.15, 0.21 , 0.0214]
    length2 = [ 0.13   ,   0.28, 0.13, 0.012]
    radius1 = [ 0.08   ,   0.07, 0.09,  0.008]
    radius2 = [ 0.09   ,   0.09, 0.08,  0.009]
    samples = 16384*4
  
    for j in range(0, len(length1)):   
 
          os.system("./antarasplot.out" + " -length1 " + str(length1[j]) + " -length2 " + str(length2[j]) + " -radius1 " + str(radius1[j]) + " -radius2 " + str(radius2[j]) + " -n " + str(samples)) 
          data = read('gen/outputs.txt')
          pressure = data[0];
          velocity = data[1];    
 
          SR = 44100.0
          length_pressure = len(pressure)
          window = np.blackman(length_pressure)
   
          ywp = window*pressure
          ywu = window*velocity
    
          fft_p = fft(ywp)
          fft_u = fft(ywu)
     
          nyquist = SR/2   
          freq = ( r_[1.0:length_pressure/2] / (length_pressure/2)*nyquist )
 
          range_p = r_[ 1:int(floor( length_pressure/2 )) ]
     
          p = abs( fft_p[ range_p ] )
          u = abs( fft_u[ range_p ] )
       
          z =  p/u

          z = z/max(z)                #escalar entre 0-1
          z_orig = z_orig/max(z_orig) #tambien

          plt.subplot(211)  
          plt.plot(freq,z)
          plt.xlim([10, 8000])
          #plt.xscale('log')
          plt.grid(True, which="both", ls="-")
          plt.title('Impedance Faust Simulation v/s Real Instrument')
    
          #plt.subplot(312)
          #plt.plot(freq,p)
          #plt.xlim([0, 4000])
          #plt.grid(True, which="both", ls="-")
          #plt.xscale('log')

          plt.subplot(212)
          plt.plot(f_orig,z_orig)
          plt.xlim([10, 8000])
          plt.grid(True, which="both", ls="-")
          #plt.xscale('log')
          plt.savefig('gen/test' + str(j) + '.png')
          plt.close()
          print 'gen/test' + str(j) + '.png Generated.'
    return

 
if __name__ == '__main__':    
    main()
