% вычисляет сумму многочленов передаваемые параметры а и b - uint_iLen
function iMult = gmult(a, b, unicalc)
	% расприновка
	%index_of = unicalc{1,1};
	%alpha_to = unicalc{1,2};
	%GF =unicalc{1,3}

	if (a == 0) | (b == 0) 
		iMult = 0; % умножение на ноль
		return
	end

	% нулей не было
    asdf = unicalc{1,1}(a)+unicalc{1,1}(b)-2;
	iPow = mod(unicalc{1,1}(a)+unicalc{1,1}(b)-2,unicalc{1,3}-1);
    % по степени ищем
    iMult = unicalc{1,2}(iPow+1);	% единица нужно, т.к. нумерация массивов с 1 и используется сумма по модулю

% not ML	
% endfunction

