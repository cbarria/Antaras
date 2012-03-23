ALSA_GTK = `pkg-config --cflags --libs alsa` `pkg-config --cflags --libs gtk+-2.0`
GTKMM = `pkg-config --cflags --libs gtkmm-2.4`
PAQ = `pkg-config --cflags --libs paq`
FAUST = -I/usr/local/lib/faust/

gen/antaras.cpp:
	faust -a alsa-gtk.cpp -double antaras.dsp > gen/antaras.cpp

standalone: gen/antaras.cpp 
	g++ -Wall gen/antaras.cpp $(ALSA_GTK) $(FAUST) $(CFLAGS) -lm -o antaras.out

svg:
	rm -rf *-svg    
	faust -svg -sn antaras.dsp

clean:
	rm -rf *.so *.out *.m gen/* *-svg alsa-gtk *.png outputs.txt

run:
	make clean; make; make standalone; ./antaras.out 

plot:
	faust -a src/newplot.cpp -double antaras.dsp > gen/antarasplot.cpp
	g++ -O3 gen/antarasplot.cpp -o antarasplot.out
	

