p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
p = bitroute(p_sourse, length(p_sourse));	% дл€ рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p_sourse); 	% переводим в uint
m = length(p)-1;	% пор€док неприводимого многочлена
GF = 2^m;			% число элементов в поле 2^(степень непривод многочлена)
[index_of alpha_to] = getLook_up(p_sourse);
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
%%%%%
rom_inver = zeros(1, GF);
fid_inv = fopen('rs_255_pow.vec', 'wt');
fwrite(fid_inv, ['wire [`WIDTH-1:0] ArrConsPow [`XX-1:0];' char(10)]);  % объ€вление массва
for i = 0:254
  rom_inver(i+1) = gpow(alpha_to(2), i, unicalc);
  fwrite(fid_inv, ['  assign ArrConsPow[' num2str(i) '] = %b' ...
    num2str(dec2bin(rom_inver(i+1))) ';' char(10)]);   
end
fclose(fid_inv);
% прошивка ром
fid_inv = fopen('rs_255_rom_inv.vec', 'wt');
fwrite(fid_inv, ['wire [`WIDTH-1:0] ArrConsPow [`XX-1:0];' char(10)]);  % объ€вление массва
fwrite(fid_inv, ['  8%b' num2str(dec2bin(0)) ': data_out <= 8%b' ...
    num2str(dec2bin(1)) ';' char(10)]); 
for i = 1:255
  rom_inver(i) = ginv(i, unicalc);
  fwrite(fid_inv, ['  8%b' num2str(dec2bin(i)) ': data_out <= 8%b' ...
    num2str(dec2bin(rom_inver(i))) ';' char(10)]);   
end
fclose(fid_inv);