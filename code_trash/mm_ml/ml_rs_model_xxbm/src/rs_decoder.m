% на входе приянтое слово и полином для генерации look-up таблицы; чис
% инф. симв, число испр ошибок
% возвращаем массив ячеек для поледующей
function RetArrCells = rs_decoder(C, p_sourse, K, t)
% инициализация
p = bitroute(p_sourse, length(p_sourse));    % для рассчетов удобно перевернуть биты в массиве
ip = arbit2dec(p);     % переводим в uint
m = length(p)-1;    % порядок неприводимого многочлена
GF = 2^m;            % число элементов в поле 2^(степень непривод многочлена)
% Варианты 
% 1. числом байт в слове и сколько хотим испаравить ошибок
% 2. еще как то
% 2*t;         % число проверочных символов
N = 2*t+K;        % число символов в кодовом слове
j0 = 1;            % начальная степень
% генерация таблицы
[index_of alpha_to] = getLook_up(p_sourse);
% объединение элементов
% в функциях не видно этих переменных, поэтому их компактно упаковываем для передачи
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 

% присвоение номеров
tmp = [];
for i = 1:length(C)
    tmp = [tmp i-1];
end
RetArrCells(1,1) = {tmp};   
RetArrCells(1,2) = {C};  %! С_n-1 +...+C_0

fid_tb = fopen('rs_255_full8_roots.vec', 'wt');  % запись кодового слова
for i = 1:length(C)
  fwrite(fid_tb, [num2str(dec2bin(C(i))) char(10)]);  
end
fclose(fid_tb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Decoder %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Cиндромы их 2t %%%%%%%%%%%%%%%%%%%
fprintf('Вычисление синдромов...')

fid_tb = fopen('rs_drm_roots.vec', 'wt');
fid_tb_sin = fopen('rs_drm_s_serial.vec', 'wt');
tmp = [];
for j = 1:2*t
  s(j) = 0;
  % !point запись корни
  alpha_to(1+j0+j-1);
  fwrite(fid_tb, ['assign ' num2str(dec2bin(alpha_to(1+j0+j-1))) char(10)]);  
  for i = 1:length(C)
    if j == 1  % !point одна серия синдромов
      fwrite(fid_tb_sin, [num2str(dec2bin(s(j))) char(10)]);   
    end
    s(j) = gmult(alpha_to(1+j0+j-1), s(j), unicalc);
    s(j) = gsum(C(i), s(j), unicalc);
	if(j == 1)
	  tmp = [tmp s(j)];
	end
  end
end
tmp

fclose(fid_tb);
fclose(fid_tb_sin);
% синдромы
%asfsdf
RetArrCells(1,3) = {s} ;
bitroute(s, length(s))
save sindroms s;
fprintf('Ок\n')

if sum(s) ~= 0  % есть что исправлять

%%%%%%%%%%%%%%%%%%%%%%%%%% RiBM %%%%%%%%%%%%%%%%%%%%%%%%%

  fprintf('Расчет полинома локаторов...')
  [lambda, omega] = gribm(t, s, unicalc)  % подключение Месси  
  % считаме степень  

  lambda_deg = -1; 
  for j = 0:t
    if lambda(j+1) ~= 0
      lambda_deg = j;   
    end
  end

 RetArrCells(1,4) = {lambda};
 fprintf('Ок\n')
 save lambdas lambda;
   
%%%%%%%%%%%%%%%%%%%%%%%%% Чень %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf('Нахождение конрей полинома локаторов...')
  
  omega_deg = lambda_deg-1;
  fid_pow = fopen('rs_drm_pow0.vec', 'wt');
  num_roots = 0;
  for k = 0:GF-2  % по степеням будет
      % вычисяем Lambda(Alpha^i) пользуемся степенной финкцией
      alpha_k = gpow(alpha_to(2), k, unicalc);
      fwrite(fid_pow, [num2str(dec2bin(alpha_k)) char(10)]);  
      result = 0;
      for j = 1:lambda_deg+1 % по числу коэффициентов в омеге
          % подставляем (alpha^i)^k
          result = gmult(alpha_k, result, unicalc);
          result = myxor(lambda(j), result, 8);
	  end
      if result == 0  % Корень найден
        root_inv(num_roots+1) = alpha_k;  % x_i^(-1) ! нет! это нормальные корни
        root_pow(num_roots+1) = k;  % положения ошибок
        num_roots = num_roots+1;  % число корней
      end
  end

  fclose(fid_pow);
  %%%%%%%% Принятие решения о декодировании %%%%%%%%%

  if num_roots == lambda_deg   % декодировать можно 
      RetArrCells(1,1) = {num2str(num_roots)}; % число ошибок
      fprintf('Ок\n')
  
  %%%%%%%%%%%%%%%%%%%%%%% Форни %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % x*der(x)
    for i = 1:lambda_deg
        if bitand(i,1) ~= 0  % проверка на четность 
          lambda_der(i)=lambda(i+1);
        else
          lambda_der(i)=0;  
        end
    end
	lambda
	omega'
	lambda_der = [0 lambda_der]; % сдвинутая
    % производная
    RetArrCells(1,6) = {lambda_der};
    
    fprintf('Алгоритм Форни...');  
    % подстввляем в Omega
	omega = bitroute(omega, length(omega)); % старшими вперед
      for j = 1:num_roots
       numerator(j) = 0;
       for k = 1:8%lambda_deg  % для каждой позиции вычисляем 
         numerator(j) = gmult(ginv(root_inv(j), unicalc),numerator(j), unicalc);
         numerator(j) = myxor(omega(k), numerator(j), 8);
       end
      end
	  numerator
    % подствляем в знаменатель здесь вроде бы как и было
	lambda_der = bitroute(lambda_der, length(lambda_der))  % подстановка идет по старшинству степеней
    for j = 1:num_roots
      denominator(j) = 0;
      for k = 1:lambda_deg+1
        denominator(j) = gmult(ginv(root_inv(j), unicalc),denominator(j) , unicalc);
        denominator(j) = myxor(lambda_der(k), denominator(j) , 8);
      end
	  denominator(j) = ginv(denominator(j), unicalc);
    end
	denominator %= bitroute(denominator, length(denominator));


% деление и корректирующий полинм
% вроде бы можно и без деления
tt = gpow(alpha_to(2), 2*t+1 , unicalc)  % "+1" очень странна может ее можно и убрать
for j = 1:num_roots
    gpow(ginv(root_inv(j), unicalc), 2*t+1 , unicalc)
    numerator(j) = gmult(numerator(j), gpow(ginv(root_inv(j), unicalc), 2*t+1 , unicalc), unicalc);
    correct_poly(j) = gmult(numerator(j), denominator(j), unicalc); % значение
end

corpp = zeros(1,N);
fprintf('Ок\n')

%%%%%%%%%%%%%%%%%%%%% Исправление ошибок %%%%%%%%%%%%%%%%%%%
fprintf('Исправление ошибок...');
%%%% !!!! разворот
C = bitroute(C, length(C));
for k = 1:num_roots
      C(root_pow(k)+1) = myxor(correct_poly(k), C(root_pow(k)+1), 8);
      corpp(root_pow(k)+1) = correct_poly(k); 
end
C = bitroute(C, length(C));
fprintf('Ок\n');


%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%

%%%%% для реализации не нужно %%%%%
% для удобства вывода не понятно
RetArrCells(1,5) = {root_inv};
% корректирцющий
RetArrCells(1,7) = {bitroute(corpp, length(corpp))};
% 
else    % декодировать нельзя
  RetArrCells(1,1) = {'! Not decoding'};
  fprintf('! Not decoding\n');
end
%%%% If ошитбки есть
else
     RetArrCells(1,1) = {'! No errors'}; 
     fprintf('! No errors\n');
end
% итоги
RetArrCells(1,8) = {C};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
