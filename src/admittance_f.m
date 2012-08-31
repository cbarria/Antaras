function [admittance f] = admittance_f(Zfic_name)
%extrae impedancia(compleja) y frecuencia
Z = load(Zfic_name);

admittance = 1./ sqrt( Z(:,2).^2 + Z(:,3).^2 ) ;
f = Z(:,1);

end