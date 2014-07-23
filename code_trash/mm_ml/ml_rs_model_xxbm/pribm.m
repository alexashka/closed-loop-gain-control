 % конвееризованные вариант алгоритма Б.-Месси
 % "High-Speed Low-Complexity Reed-Solomon Decoder
 % using Pipelined Berlekamp-Massey Algorithm and Its 
 % Folded Architecture"
 
 % похоже просто конвееризовали умножители, поэтому тактов стало
 % в два раза больше
 clear;  clc;
 
  K = 239;  t = 8;				
  p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
 
 p = bitroute(p_sourse, length(p_sourse));  % для рассчетов удобно перевернуть биты в массиве
 ip = arbit2dec(p);   % переводим в uint
 m = length(p)-1;  % порядок неприводимого многочлена
 GF = 2^m;      % число элементов в поле 2^(степень непривод многочлена)
 % Варианты 
 % 1. числом байт в слове и сколько хотим испаравить ошибок
 % 2. еще как то
 T = 2*t;     % число проверочных символов
 N = T+K;    % число символов в кодовом слове
 j0 = 1;      % начальная степень
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
 
 %%%%%%%%%%% Вычисления %%%%%%%%%%%%%
 % init
 %%% выделение массивов %%%
 delta = zeros(3*t+2, 8*t+1);
 ttt = zeros(3*t+2, 8*t+1);
 k = zeros(1, 8*t+1);
 gamma = zeros(1, 8*t+1);
 
 % заполнение
 delta(3*t+0+1, 0+1) = 1;
 k(0+1) = 0;
 gamma(0+1) = 1;
 
 for i = 0:2*t-1
     delta(i+1, 0+1) = s(i+0+1);
     ttt(i+1, 0+1) = s(i+0+1);
 end
 % calc
 
 % main cycle
 for r = 0:4*t-1  % пусть такая нумерация
   % step 1
   for i = 0:3*t
     delta((i)+1, (2*r+2)+1) = ...
         gsum(gmult(gamma((2*r)+1),... 
                    delta((i+1)+1, (2*r)+1), ...
                    unicalc),...
              gmult(delta((0)+1,(2*r)+1),...
                    ttt((i)+1, (2*r)+1),... 
                    unicalc),... 
         unicalc);
     delta((i)+1, (2*r+1)+1) = 0;
   end
   % step 2
   if (delta(0+1, (r)+1) ~= 0) && (k((r)+1) >= 0)
      for i = 0:3*t
        ttt((i)+1, (r+1)+1) = delta((i+1)+1, (r)+1);
      end
      gamma((2*r+2)+1) = delta(0+1, (2*r)+1);
      gamma((2*r+1)+1) = 0;
      delta(0+1,(2*r+1)+1) = 0;
      k((2*r+2)+1) = -k((2*r)+1)-1;
      k((2*r+1)+1) = 0;
   else
      for i = 0:3*t
        ttt((i)+1, (r+1)+1) = ttt((i)+1, (r)+1);
      end
      gamma((2*r+2)+1) = gamma((2*r)+1);
      gamma((2*r+1)+1) = 0;
      delta(0+1,(2*r+1)+1) = 0;
      k((2*r+2)+1) = k((2*r)+1)+1;
      k((2*r+1)+1) = 0;
   end
 end
 delta
 
 