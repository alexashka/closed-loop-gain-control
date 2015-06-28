% приписываем пути
addpath(cat(2,pwd,'\src'));
clear;  clc;

% исходные данные
names = {'-- Errors : ' '-- data_in[]  ' '-- sidd_[]    ' '-- lambb_[]   '...
        	'-- root_[]    ' '-- lamdd_[]   ' '-- corpp_[]   ' '-- out_dec[]  '};
%%% выбор вырианта вычисления %%%
bType = 3;  % !!! 1 пока
% 1 - (15,9); 2 - drm ; 3 -  укороченные над gf8

switch bType
%%% (15, 9) %%%
case {1}
  % исходные данные
  K = 9;  t = 3;  % информационных символов, сколько ошибок хотим исправить
  p_sourse = [1 0 0 1 1];  % x4+x+1 gf(16)
  
  %%%%%%%%
  fid_r = fopen('test_dec_15_8.mif', 'r');
  A = fgets(fid_r);  % читаем построчно
  iData = mifstr2decarr(A);  % данные из файла готовые к декодированию

  %%% декодирование %%%
  fprintf('Декодирование начато...\n');
  q = rs_decoder(iData, p_sourse, K, t)
  
%%% DRM %%%
case {2}
  % исходные данные
  K = 207;  t = 24;				
  p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
  
  %%%%%%%%%%%%%%%
  fid_r = fopen('rs_sym_drm_er.mif', 'r');
  fid_tb = fopen('rs_drm_tb.vec', 'wt'); 
  
  % в один массив
%   Tmp = []; 
%   for i = 1:16  % чтение данных из файла
%     A = fgets(fid_r);  u = mifstr2decarr(A);  Tmp = [Tmp u];
%   end
  Tmp = [];
  for i = 1:K  % входные данные
    Tmp = [Tmp i];    
  end
  
  fprintf('Кодирование начато...');
  Tmp = rs_coder(Tmp,p_sourse, K, t);
  fprintf('Ok!\n');
  %%% !point запись входного тестового вектора
  for j = 1:length(Tmp)  
    fwrite(fid_tb, [num2str(dec2bin(Tmp(j))) char([10])]);
  end
  for i = 1:24
    Tmp(i) = 0;  % erroring
  end
  %%% декодирование %%%
  fprintf('Декодирование начато...\n');
  q = rs_decoder(Tmp, p_sourse, K, t);
case {3}
  % параметры кода
  K = 239;  t = 8;  % сколько ошибок хотим исправить
  p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1'
  
  %%%%%%%%%  
  fid_r = fopen('rs_sym_dvbt_er.mif', 'r');
  
  Tmp = [];
  for i = 1:K  % входные данные
    Tmp = [Tmp i];    
  end
  %%% кодирование %%%
  fprintf('Кодирование начато...');
  w = rs_coder(Tmp,p_sourse, K, t);
  w
  %37   133   225   126    37    59   132   133    56   168   179     4     9    99    79   148
  fprintf('Ok!\n');
   for i = 1:5  % erroring
     w(i) = 00;
   end
   w(end-3) = 0;
   w(end-2) = 0;
   w(end-0) = 0;
   
   %fhgfh
  %%% декодирование %%%
  fprintf('Декодирование начато...\n');
  q = rs_decoder(w, p_sourse, K, t);
end
 % сохраняем результаты
  fprintf('Запись файла с результатами - Monitor.mif...');
  fid = fopen('Monitor.mif', 'wt');
    smesh = 0;  r = 0;
    fwrite(fid, [names{1,1} q{1,1} char([10 10])]); 
    for i = 1:7
      fwrite(fid, [names{1,i+1} char([10])]);
      [cBuf, r] = int2hexchar(q{1,i+1}, smesh);
      if mod(r, 32) == 0  smesh = smesh+r+1;
      else smesh = smesh+r; end
      fwrite(fid, [cBuf char([10 10])]);
    end
	fprintf('Ок\n');  close('all');
% просмотр файла
%edit Monitor.mif 
%! notepad Monitor.mif 

