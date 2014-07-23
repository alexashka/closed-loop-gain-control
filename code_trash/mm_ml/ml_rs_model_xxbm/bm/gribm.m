 % RiBM
 
 clear;  
 % "High-Speed Low-Complexity Reed-Solomon Decoder
 % using Pipelined Berlekamp-Massey Algorithm and Its 
 % Folded Architecture"
 K = 9;  t = 3;  % информационных символов, сколько ошибок хотим исправить
 p_sourse = [1 0 0 1 1];  % x4+x+1 gf(16)
 %
 bm_ini;  % просто инициаизаци€  
 %%% загрузка синдромов %%%%%%%%
 load sindroms;
 load lambdas;
 load omegas;
 
 %%%%%%%%%%% ¬ычислени€ %%%%%%%%%%%%%
 % init
 %%% выделение массивов %%%
 delta = zeros(3*t+2, 2*t+1);
 ttt = zeros(3*t+2, 2*t+1);
 k = zeros(1, 2*t+1);
 gamma = zeros(1, 2*t+1);
 
 % заполнение
 delta((3*t)+1, 0+1) = 1;
 ttt((3*t)+1, 0+1) = 1;
 k(0+1) = 0;
 gamma(0+1) = 1;
 
 for i = 0:2*t-1%+1
     delta(i+1, 0+1) = s((i)+1);
     ttt(i+1, 0+1) = s((i)+1);
 end
 % calc
 
 % main cycle
 for r = 0:2*t-1  % пусть така€ нумераци€
   % step 1
   for i = 0:3*t
     delta((i)+1, (r+1)+1) = ...
         gsum(gmult(gamma((r)+1), delta((i+1)+1, (r)+1), unicalc),...
              gmult(delta(0+1,(r)+1), ttt((i)+1, (r)+1), unicalc), unicalc);
           
   end
   % step 2
   if (delta(0+1, (r)+1) ~= 0) && (k((r)+1) >= 0) 
      for i = 0:3*t
        ttt((i)+1, (r+1)+1) = delta((i+1)+1, (r)+1);
      end
      gamma((r+1)+1) = delta(0+1, (r)+1);
      k((r+1)+1) = -k((r)+1)-1;
   else
      for i = 0:3*t  % дельта не сдвигаетс€
        ttt((i)+1, (r+1)+1) = ttt((i)+1, (r)+1);
      end
      gamma((r+1)+1) = gamma((r)+1);
      k((r+1)+1) = k((r)+1)+1;
   end
 end
delta