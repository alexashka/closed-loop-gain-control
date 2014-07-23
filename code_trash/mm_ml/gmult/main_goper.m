
function main_goper(a, b)
addpath(cat(2,pwd,'\src'));

%
a = 1;
b = 2;
p_sourse = [1 0 0 0 1 1 1 0 1];		% x8+x+1'
p = bitroute(p_sourse, length(p_sourse));	% для рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p); 	% переводим в uint
m = length(p)-1;	% порядок неприводимого многочлена
GF = 2^m;			% число элементов в поле 2^(степень непривод многочлена)
% генерация таблицы
[index_of alpha_to] = getLook_up(p_sourse);
% объединение элементов
% в функциях не видно этих переменных, поэтому их компактно упаковываем для передачи
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
% проверка
out = [];
for i = 0:10
  q = gpow(b, i, unicalc);
  out = [out q];
end
out
%gmult(a,b, unicalc)
%dec2bin(gmult(a,b, unicalc))