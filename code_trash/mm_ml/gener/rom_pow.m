p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
p = bitroute(p_sourse, length(p_sourse));	% для рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p_sourse); 	% переводим в uint
m = length(p)-1;	% порядок неприводимого многочлена
GF = 2^m;			% число элементов в поле 2^(степень непривод многочлена)
[index_of alpha_to] = getLook_up(p_sourse);
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
%%%%%
rom_inver = zeros(1, GF-1);
fid_inv = fopen('rs_255_inv.vec', 'wt');
fwrite(fid_inv, [num2str(dec2bin(rom_inver(0))) char(10)]);  
for i = 1:255
  rom_inver(i) = ginv(i, unicalc);
  fwrite(fid_inv, [num2str(dec2bin(rom_inver(i))) char(10)]);   
end
fclose(fid_inv);