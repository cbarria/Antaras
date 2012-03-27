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

def write(filename, data1, data2):
    r = csv.writer(open(filename, 'wb'))
    r.writerow(data1)
    r.writerow(data2)

def ceros(data):
    newdata = [] 
    for k in range(0,len(data)):
        if data[k] != 0:
           newdata.append(data[k])
    return newdata

def error(data1, data2):
    err1 = [7991]
    err2 = 0
    data1 = data1[10:len(data2)+10]
    for l in range(1, len(data1)):
             err1.append( pow( data1[l] - data2[l],2 ) )
             err2 = err2 + err1[l]        
    print "Error: " + str(err2/len(data1)*100) + "%"
    #print "Longitud Data 1: " + str(len(data1)) + " Longitud Data 2: " + str(len(data2))        

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
    
    length1 = [ 0.0214,0.15, 0.21, 0.21]
    length2 = [ 0.013 ,0.28, 0.13, 0.13]
    radius1 = [ 0.008 ,0.07, 0.09, 0.08]
    radius2 = [ 0.009 ,0.09, 0.08, 0.09]
    samples = 16384
  
    for j in range(0, len(length1)):   
 
          os.system("./antarasplot.out" + " -length1 " + str(length1[j]) + " -length2 " + str(length2[j]) + " -radius1 " + str(radius1[j]) + " -radius2 " + str(radius2[j]) + " -n " + str(samples)) 
          data = read('gen/outputs.txt')
          pressure = data[0]
          velocity = data[1]
          
          write('gen/newout' + str(j) + '.txt', pressure, velocity)    
 
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

          error(z,z_orig) #testing
	
          plt.subplot(211)  
          plt.plot(freq,z)
          plt.xlim([10, 8000])
          plt.ylim([0, 1.1])
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
          plt.ylim([0, 1.1])
          plt.grid(True, which="both", ls="-")
          
          plt.savefig('gen/test' + str(j) + '.png')
          plt.close()
          print 'gen/test' + str(j) + '.png Generated. ' #+ str(freq[z.argmin()])
    return

 
if __name__ == '__main__':    
    main()
