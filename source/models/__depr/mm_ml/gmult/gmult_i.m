function y = gmult_i(a, b, index_of, alpha_to)
%#eml

% глобальные только таблицы
 if (a == uint8(0)) || (b == uint8(0)) 
     y = uint8(0); % умножение на ноль
 	return
 end
tmp_0 = index_of(a)-uint8(1);   % чистая степень не больше 254
tmp_1 = index_of(b)-uint8(1);   % чистая степень не больше 254
tmp_2 = uint8(254)-tmp_0; % -1 т.к. индексация массивов с 1 и степень будет на 1 меньше
%%%
if tmp_2 < tmp_1 % можно уложится
    compary = tmp_1-tmp_2;
else    % невлазим index_of(b)-tmp_1-1 = на сколько не влазим
    compary = tmp_0+tmp_1+uint8(1); % просто складываем индексы переполнения не будет
end
y = alpha_to(compary); 