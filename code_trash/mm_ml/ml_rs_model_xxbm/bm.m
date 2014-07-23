  % конвееризованные вариант алгоритма Б.-Месси
 % "High-Speed Low-Complexity Reed-Solomon Decoder
 % using Pipelined Berlekamp-Massey Algorithm and Its 
 % Folded Architecture"
 clear;  clc;
%  K = 9;  t = 3;  % информационных символов, сколько ошибок хотим исправить
%  p_sourse = [1 0 0 1 1];  % x4+x+1 gf(16)
 K = 207;  t = 24;				
  p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
 p = bitroute(p_sourse, length(p_sourse));	% для рассчетов удобно перевернуть биты в массиве
 ip = arbit2dec(p); 	% переводим в uint
 m = length(p)-1;	% порядок неприводимого многочлена
 GF = 2^m;			% число элементов в поле 2^(степень непривод многочлена)
 % Варианты 
 % 1. числом байт в слове и сколько хотим испаравить ошибок
 % 2. еще как то
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
 %%% загрузка синдромов %%%%%%%%
 load sindroms;
 load lambdas;
 load omegas; 

% просто переменные
  lambda_deg = 0;  l_er = 0; 
  discrep = 0;  % невязка
  % начальные установки
  lambda = [1 zeros(1, T/2)];
  prev_lambda = [0 1 zeros(1, T/2-1)]; % B(x) сразу сдвигаем
  tau = zeros(1, T); 
  % основные вычисления (цикл)
  for i_round = 1:T  % цикл по компанентам синдрома
    discrep = 0;  % невязку обнуляем
    for i = 1:l_er+1
      mpp = gmult(s(i_round-i+1),lambda(i), unicalc);
      discrep = myxor(discrep, mpp,8);  % невязку считаем
    end
    % ненулевая невязка. корректируем веса
    if discrep ~= 0
      for k = 1:T/2+1 % нужен ли такой предел 
        mpp = gmult(discrep, prev_lambda(k), unicalc);
        tau(k) = myxor(lambda(k), mpp, 8);
        if tau(k) ~= 0  % расчет степени
          lambda_deg = k-1; % сразу считаем степень лямбды
        end
      end
      % далее непоянтно
      if 2*l_er < i_round 
        l_er = i_round-l_er;
        for k = 1:T/2+1
          prev_lambda(k) = gdiv(lambda(k), discrep, unicalc);
        end
      end 
      % сохарняем нашу лямбду
      lambda = tau;
      tau = zeros(1, length(tau));    % обнуляем
    end
    % сдвигаем второй регистр
    prev_lambda = [0 prev_lambda];
    prev_lambda(:,end) = []; % вырезаем последний элементо
    % prev_lambda_deg = prev_lambda_deg+1; 
  end
  % расчет локатора закончен
  % нужно бы проверить возможность исправления ошибок в принципе
  % локаторы
lambda_deg