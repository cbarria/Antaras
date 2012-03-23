function [Z_compl f] = Zf_txt(Zfic_name)
%extrae impedancia(compleja) y frecuencia

Z = load(Zfic_name);

Z_compl = Z(:,2)+j*Z(:,3);
f = Z(:,1);

end
