[FILENAME1, PATHNAME1] = uigetfile('*.txt', 'Archivo de impedancia 1');
[FILENAME2, PATHNAME2] = uigetfile('*.txt', 'Archivo de impedancia 2');

Zfic_name1 = [PATHNAME1 FILENAME1];
Zfic_name2 = [PATHNAME2 FILENAME2];

%[z1 f1] = Zf_txt('Impedance1.txt');
%[z2 f2] = Zf_txt('Impedance2.txt');

[z1 f1] = admittance_f(Zfic_name1);
[z2 f2] = admittance_f(Zfic_name2);

f1_range = f1(1:29900); 
z1_range = abs(z1(1:29900));             % 10.000 Hz to 2999.9 Hz

f2_range = f1(29901:end);
z2_range = abs(z1(29901:end));           % 3000.0 Hz to 4000.0 Hz

f3_range = f2(1:10001);
z3_range = abs(z2(1:10001));             % 3000.0 hz to 4000.0 Hz
 
f4_range = f2(10002:end);
z4_range = abs(z2(10002:end));           % 4000.1 Hz to 8000.0 Hz

z23_range = (z2_range + z3_range)./2 ;   % (avrg) new range 3000.0 Hz to 4000.0 Hz

full_z_range = [z1_range; z23_range; z4_range]; %concatenar
full_f_range = [f1_range; f2_range ; f4_range]; %concatenar

down_z = downsample(full_z_range,10); %downsampling x10
down_f = downsample(full_f_range,10); %downsampling x10

plot(full_f_range,full_z_range);
figure
plot(down_f, down_z, 'r');

file = [down_f down_z];

dlmwrite('ZF.txt', file, 'precision', '%.5f', 'delimiter', '\t')
