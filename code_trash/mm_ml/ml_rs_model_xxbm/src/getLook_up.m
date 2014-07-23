% генерурует look-up таблицу
function [index_of alpha_to] = getLook_up(p_sourse)


% инициализация
p = bitroute(p_sourse, length(p_sourse));	% для рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p); 	% переводим в uint
m = length(p)-1;	% максимальные порядок неприводимого многочлена 
GF = 2^m;		% число элементов в поле 2^(степень непривод многочлена)
overflow = arbit2dec([zeros(1,m) 1]); 	% для проверки переполнения

%%% Вычисления %%%

% сперва look-up таблица для умножения-деления
% поиск по alpha^i
tmp = 1; %
for i=1:GF-1		% досчитывае остальные
	% 1. сдвигаем
	% 2. если переполнение суммируем по модулю
	% 3. если нет то элемент посчитан 
	% 4. индексируем

	% принимаем решение о переобразовании
	if(tmp >= overflow)
		tmp = myxor(tmp, ip, m);
		alpha_to(i) = tmp;
		index_of(alpha_to(i)) = i;
		tmp =  myshl(tmp,m+1); 	% сдвигаем предыдущий (здесь размерность расширяем, чтобы опред. перен.)
	else
		alpha_to(i) = tmp;
		index_of(alpha_to(i)) = i;
		tmp =  myshl(tmp,m+1); 	% сдвигаем предыдущий (здесь размерность расширяем, чтобы опред. перен.)
	end
end


% вывод всей таблицы
tmp = [];
for i=1:GF-1
	tmp = cat(1, tmp, [ i index_of(i)-1 alpha_to(i) bitroute(dec2arbit(alpha_to(i),m), m) ]);
end
look_up = tmp; 	% [адреса  нумерация степень(алфы)  алфа_десятичное_предст коэфф_многочл ]


% endfunction
