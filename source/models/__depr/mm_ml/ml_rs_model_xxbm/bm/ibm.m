   % конвееризованные вариант алгоритма Б.-Месси
 % "High-Speed Low-Complexity Reed-Solomon Decoder
 % using Pipelined Berlekamp-Massey Algorithm and Its 
 % Folded Architecture"
 clear;  clc;
 K = 9;  t = 3;  % информационных символов, сколько ошибок хотим исправить
 p_sourse = [1 0 0 1 1];  % x4+x+1 gf(16)
 
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
 
 %%%%%%%%%%% Вычисления %%%%%%%%%%%%%
 % init
 %%% выделение массивов %%%
 delta = zeros(3*t+2, 2*t+1);
 lamb = zeros(3*t+2, 2*t+1);
 b = zeros(3*t+2, 2*t+1);
 k = zeros(1, 2*t+1);
 gamma = zeros(1, 2*t+1);
 
 % заполнение
 lamb(0+1, 0+1) = 1;
 b(0+1, 0+1) = 1;
 k(0+1) = 0;
 gamma(0+1) = 1;
 
 % calc
 
 % main cycle
 for r = 0:2*t-1  % пусть такая нумерация
   % step 1
   sum = 0; 
   for i = 0:t
     tmp = mod(r-i, t);
     sum = gsum(sum, gmult(s((tmp)+1), lamb(i+1, (r)+1), unicalc), unicalc); 
   end
   delta((r)+1) = sum;
   sum
   % step 2
   for i = 0:t
     if i ~= 0 
     lamb((i)+1, (r+1)+1) = gsum(gmult(gamma((r)+1),lamb((i)+1, (r)+1), unicalc),...
         gmult(delta((r)+1), b((i-1)+1, (r)+1),unicalc), unicalc);
     else
       lamb((i)+1, (r+1)+1) = gmult(gamma((r)+1),lamb((i)+1, (r)+1), unicalc);    
     end
   end
   % step 3
   if (delta((r)+1) ~= 0) && (k((r)+1) >= 0)
      for i = 0:t
        b((i)+1, (r+1)+1) = lamb((i)+1, (r)+1);
      end
      gamma((r+1)+1) = delta((r)+1);
      k((r+1)+1) = gsum(k((r)+1),1, unicalc);
   else
      for i = 0:t
        if i ~= 0 
          b((i)+1, (r+1)+1) = lamb((i+1)+1, (r)+1);
        else
          b((i)+1, (r+1)+1) = 0;  
        end
      end
      gamma((r+1)+1) = gamma((r)+1);
      k((r+1)+1) = gsum(k((r)+1),1, unicalc);
   end
 end
 lamb