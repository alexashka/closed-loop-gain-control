% на входе приянтое слово и полином для генерации look-up таблицы; чис
% инф. симв, число испр ошибок
% возвращаем массив ячеек для поледующей
function outWord = rs_coder(A, p_sourse, K, t)
% инициализация
p = bitroute(p_sourse, length(p_sourse));	% для рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p); 	% переводим в uint
m = length(p)-1;	% порядок неприводимого многочлена
GF = 2^m;			% число элементов в поле 2^(степень непривод многочлена)
T = 2*t; 		% число проверочных символов
N = T+K;		% число символов в кодовом слове
j0 = 1;			% начальная степень
% генерация таблицы
[index_of alpha_to] = getLook_up(p_sourse);
% объединение элементов
% в функциях не видно этих переменных, поэтому их компактно упаковываем для передачи
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
% временный для первого умножения
itmpR = [zeros(1, T-2) 1 alpha_to(1+j0)];
% временный для второго умножения, он же будет содержат результат
itmpM = [zeros(1, T-2) 1 alpha_to(1+j0)];

% Начало цикла
for i=1:T-1	% (число скобок - 1)
	% 1. результат сдивгаем но сохраняем
	% 2. умножаем сохр. рез на..
	% 3. сложение и сохраненив массиве результата
	% два элемента (следующая скобка)
	itmp2 = [1 alpha_to(1+j0+i)]; % начинаме с (1, alpha^2)(0,0,1,alpha^1)
	% массив для сдвига
	iRout = itmpM;
	iRout(:,1) =[]; % вырезаем превый элементо
	iRout = [iRout 0]; 
	% умножение с накоплением
	for i=1:T
		itmpR(i) = gmult(itmpM(i), itmp2(2), unicalc);
		itmpM(i) = gsum(iRout(i), itmpR(i), unicalc);
	end
end
itmpM;	% результат [... g1 g0]
%%% до этого вспомогательные операции

%%%% кодирование %%%%
g = itmpM;
regLen = length(g);	% длина регистра
g =  bitroute(g,regLen);

%%% деление %%%
for i=1:regLen
	Rest(i) = 0; 	% обнуляем линию
end
% делим
for i=1:K	% считаем только столько тактов стоклько информационных символов
	ifeedback = gsum(Rest(regLen),A(i),unicalc);
	% такт
	for j=1:regLen-1
		tmp = gmult(ifeedback, g(regLen+1-j), unicalc);	% на входе сумматоров
		tmp = gsum(Rest(regLen-j), tmp, unicalc);
        Rest(regLen+1-j) = tmp; 		% сохнаняемся итог
    end
    tmp = gmult(ifeedback, g(1), unicalc);  % последнее значение такое
    Rest(1) = tmp; 		% сохнаняемся итог
end

% итого кодовое слово
outWord = cat(2, A, bitroute(Rest, length(Rest)));