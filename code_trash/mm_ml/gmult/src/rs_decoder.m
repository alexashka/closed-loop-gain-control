% на входе приянтое слово и полином для генерации look-up таблицы; чис
% инф. симв, число испр ошибок
% возвращаем массив ячеек для поледующей
function RetArrCells = rs_decoder(C, p_sourse, K, t)
% инициализация
p = bitroute(p_sourse, length(p_sourse));	% для рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p); 	% переводим в uint
m = length(p)-1;	% порядок неприводимого многочлена
GF = 2^m;			% число элементов в поле 2^(степень непривод многочлена)
% Варианты 
% 1. числом байт в слове и сколько хотим испаравить ошибок
% 2. еще как то
T = 2*t; 		% число проверочных символов
N = T+K;		% число символов в кодовом слове
j0 = 0;			% начальная степень
% генерация таблицы
[index_of alpha_to] = getLook_up(p_sourse);
% объединение элементов
% в функциях не видно этих переменных, поэтому их компактно упаковываем для передачи
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
%%% декодирование %%%
tmp = [];
for i = 1:length(C)
	tmp = [tmp i-1];
end
RetArrCells(1,1) = {tmp};
RetArrCells(1,2) = {C};

%%% decoder %%%
% синдромы их 2t
for j = 1:T;
	s(j) = 0;
	for i = 1:length(C)
		s(j) = gmult(alpha_to(1+j0+j-1), s(j), unicalc);
		s(j) = gsum(C(i), s(j), unicalc);
	end
end
% синдромы
RetArrCells(1,3) = {s} ;

%%% Мэсси %%%
if sum(s) ~= 0  % есть что исправлять
	% начальные установки
	lambda(1) = 1;
	for j = 2:T
		lambda(j) = 0;   
	end
	for j = 1:T
		tau(j) = 0; 
	end
	lambda_deg = 0; 
	idx_i = -1;     % ??
	l_er = 0; 
	discrep = 0; 		% невязка
	for j = 3:T
		prev_lambda(j) = 0; 
	end
	prev_lambda(1) = 0;
	prev_lambda(2) = 1;
	% сдвигаем влево коффициенты полинома lambda на 1, тоже
	prev_lambda_deg = lambda_deg+1; 
	% степень lambda после сдвига =+1
% основные вычисления (цикл)
for i_round = 1:T       % цикл по компанентам синдрома
	if lambda_deg < l_er
		upper_bound = lambda_deg;
	else
		upper_bound = l_er;
	end
	discrep = 0; 		% невязку обнуляем
	for i = 1:upper_bound+1
		mpp = gmult(s(i_round-i+1),lambda(i), unicalc);
		discrep = gsum(discrep, mpp, unicalc); 		% невязку считаем
    end
    % ненулевая невязка
	if discrep ~= 0		
		for k = 1:T
			mpp = gmult(discrep, prev_lambda(k), unicalc);
			tau(k) = gsum(lambda(k), mpp, unicalc);
			if tau(k) ~= 0  % расчет степени
				tau_deg = k-1;
			end
		end
		% далее..
		if l_er < (i_round-idx_i-1)
			mpp = i_round-idx_i-1; 
			idx_i = i_round-l_er-1; 
			l_er = mpp;

         	% previous_lambda = lambda / discrepancy;
         	for k = 1:T
              	prev_lambda(k) = gdiv(lambda(k), discrep, unicalc);
            end
         	prev_lambda_deg = lambda_deg; 
        end 
        % сохарняем нашу лямбду
		lambda = tau;
		tau = zeros(1, length(tau));    % обнуляем
     	lambda_deg = tau_deg;
    end
    % сдвигаем второй регистр
    prev_lambda = [0 prev_lambda];
    prev_lambda(:,T+1) = []; % вырезаем последний элементо
	prev_lambda_deg=prev_lambda_deg+1; 
end
% расчет локатора закончен
% нужно бы проверить возможность исправления ошибок в принципе
% локаторы
RetArrCells(1,4) = {lambda};


%%% Чень %%%
poly_degre = lambda_deg; 
root_list_size = 1; 
bEq = 0;
i = 0;
root = [];
for k = 1:GF-1
    if bEq == 0    % сигнализирует о том, что все ошибки найдены
        % вычисяем Lambda(Alpha^i)
        result = 0;
        for k = 1:lambda_deg+1
            alpha_k = gpow(alpha_to(i+1),k-1,unicalc);
            % подставляем
            % (alpha^i)^k
            mpp = gmult(lambda(k),alpha_k, unicalc);
            result = gsum(result, mpp, unicalc);
        end
        % принимаем решение
        if  result == 0  
            root(root_list_size) = i+1;
            root_list_size = root_list_size+1;
        end
        if root_list_size == poly_degre+1  
            bEq = 1;
        end
    end
    i = i+1;
end

if length(root) == lambda_deg % декодировать можно
    RetArrCells(1,1) = {num2str(length(root))}; % число ошибок
% позиции
    
%%% Форни %%%;
omega = zeros(1, K);
lambda_buf = [lambda zeros(1,K-length(lambda))];
for j = 1:T
	for i = 1:K     % число информационных сисволов
    	omega(i) = gsum(omega(i), gmult(s(j), lambda_buf(i), unicalc) ,unicalc);
	end 
	% сдвигаем локатор
	lambda_buf = [0 lambda_buf];
	lambda_buf(:,K+1) = [];
end

%% нужно взять по мудулю x^T = x^6 т.е T элементов
%% призводная ? вычисляется странновато
for i = 1:lambda_deg	
	if mod(i,2) ~= 0 
		lambda_der(i)=lambda(i+1);
	else          
		lambda_der(i)=0;
	end
end
% производная
RetArrCells(1,6) = {lambda_der};

% подстановка 
for i = 1:root_list_size-1	% по числу ошибок ?? странно с -1
	alpha_invert(i)=alpha_to(root(i));%+1);
	numerator = 0;
end

% подстввляем в числитель
mpp = 0;
for j = 1:root_list_size-1
	for k = 1:T		% будут нелевые  1 1 1 0 0 0
		mpp = gsum(mpp,  gmult(omega(k), gpow(alpha_invert(j), k-1, unicalc), unicalc), unicalc);
	end
	numerator(j) = mpp;
	mpp = 0;
end
% подствляем в знаменатель
mpp = 0;
for j = 1:root_list_size-1
	for k = 1:length(lambda_der)		% будут нелевые  1 1 1 0 0 0
		mpp = gsum(mpp,  gmult(lambda_der(k), gpow(alpha_invert(j), k-1, unicalc), unicalc), unicalc);
	end
	denominator(j) = mpp;
	mpp = 0;
end
% деление и корректирующий полинм
for j = 1:root_list_size-1
	correct_poly(j) = gdiv(numerator(j), denominator(j), unicalc); % значение
end
corpp = zeros(1,N);
% перетасовка root
for k = 1:length(root)
    if root(k) == 1
        root_tmp(k) =  K+t*2;  
    else
        root_tmp(k) = mod((root(k)-1),K+t*2);
    end
end
RetArrCells(1,5) = {root_tmp-1};
%%%% исправление ошибок %%%%
for  k = 1:length(root)
	C(root_tmp(k)) = myxor(correct_poly(k), C(root_tmp(k)), 8);
	corpp(root_tmp(k)) = correct_poly(k);
end
% корректирцющий
RetArrCells(1,7) = {corpp};


%% 
else    % декодировать нельзя
  RetArrCells(1,1) = {'! Not decoding'}; 
end
%%%% If ошитбки есть
else
     RetArrCells(1,1) = {'! No errors'}; 
end
% итоги
RetArrCells(1,8) = {C};



%%%%%% impl %%%%
% 1. как можно вызывов функций (length....)
% 2. меньше переменных
% 3. убарть ячейки
