import("music.lib"); //adsr
import("math.lib"); //tanh
import("effect.lib"); //dcblocker

//parameters
RHO = 1.2;
SOUND_SPEED = 343.54;
TWO_SOUND_SPEED = 687.08;
ONE_OVER_RHO_C = 1.0 / (RHO * SOUND_SPEED);


gate = button("Play"); // on-off
length1 = hslider("Length_1", 27, 1, 35, 0.1);
length2 = hslider("Length_2", 28, 1, 35, 0.1);
radius1 = hslider("Radius_1", 9, 1, 20, 0.1);
radius2 = hslider("Radius_2", 7, 1, 20, 0.1);


//delays
   uptube1 = fdelay(4096, (length1 * SR)/(TWO_SOUND_SPEED));
   downtube1 = fdelay(4096, (length1 * SR)/(TWO_SOUND_SPEED));

   uptube2 = fdelay(4096, (length2 * SR) / (TWO_SOUND_SPEED) );
   downtube2 = fdelay(4096, (length2 * SR) / (TWO_SOUND_SPEED) );

// filters
lossesFilter = iir((b0,b1,b2,b3),(a1,a2,a3))
with {
    a1 = -0.33623476246554;
    a2 = -0.71257915055968;
    a3 = 0.14508304017256;
    b0 = 0.83820223947141;
    b1 = -0.16888603248373;
    b2 = -0.64759781930259;
    b3 =  0.07424498608506;
};

endReflection = iir((b0,b1,b2),(a1,a2))
with {
    a1 = -0.3587; 
    a2 = -0.0918;
    b0 = -0.1254;
    b1 = -0.3237;
    b2 = -0.1003;
};

// 2portj
portj = (_, _) <: (_,_,_,_) : (_,(_-_)*kr,_) : (_, (_ <: (_,_)) ,_ ) : (_+_, _+_)
with {

   kr = ((radius2*radius2) - (radius1*radius1)) / ((radius2*radius2) + (radius1*radius1));

};

// resonador
res = inmix <: (uptube1, downtube2, _) : (portj,_) : (uptube2, downtube1,_) <: (_,_,!,!,_,_) : outmix
with {
    
   inmix(dt1, ut2, input) = (dt1+input, ut2, dt1);
  
   outmix(ut2, dt1, outn, outp) = (dt1, ut2, outn, outp);

};

// calc
calc(out, in) = (out, in) <: (_,! , _,_, _,_) : (! , (_+_) , (_-_)*ONE_OVER_RHO_C ); // solo Pp y Vac

resonator = ((res~_(endReflection)):(!,_,_,_))~_(lossesFilter): !,_,_ : calc;

process = (1-1') : resonator;
//process = gate * noise : resonator; 
