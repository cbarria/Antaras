SR = 44100.0;

length1 = [ 57.3 ];
length2 = [ 57.3 ];
radius1 = [ 4.0 ];
radius2 = [ 2.7 ];
samples = 44100;

antara = load('src/ZF.txt');

for i=1:length(length1);
    options = [' -length1 ' num2str(length1(i)) ' -length2 ' num2str(length2(i)) ' -radius1 ' num2str(radius1(i)) ' -radius2 ' num2str(radius2(i)) ' -n ' num2str(samples)];   
    system(['./antarasplot.out' options]);  
    
    faust_p = csvread('gen/outputs.txt');
    
    
    NFFT = 2^(nextpow2( length(faust_p) )); %weird... should be 16384, not 16386
    p = fft(faust_p, NFFT)/length(faust_p);
    f = SR/2*linspace(0,1,NFFT/2+1);
    P = abs( p( 1:NFFT/2+1 ) );
    
    P = P/max(P);
    P2 = antara(:,2) /max(antara(:,2));
    
    figure
    plot(f,P,'r')
    xlim([10 8000]);
    ylim([0 1.1]);
    
    hold on
    
    plot( antara(:,1), P2 )
    xlim([10 8000]);
    ylim([0 1.1]);
end    