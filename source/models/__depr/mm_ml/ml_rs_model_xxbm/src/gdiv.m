function iDiv = gdiv(a, b, unicalc)
	% распиновка
	%index_of = unicalc{1,1};
	%alpha_to = unicalc{1,2};
	%GF = unicalc{1,3};
	if(a == 0) 
		iDiv = 0; % деление разрешно ноль
        return
	end
	if(b == 0) 
		iDiv = '! деление на ноль'; % !! деление на ноль
		return
	end
	% проверку прошли
	idiff = unicalc{1,1}(a)-unicalc{1,1}(b);
	if idiff < 0	% отрицательные результат
		idiff = idiff+unicalc{1,3}-1;
	end
	iDiv = unicalc{1,2}(idiff+1);
% endfunction
