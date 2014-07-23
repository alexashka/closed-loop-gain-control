% �� ����� �������� ����� � ������� ��� ��������� look-up �������; ���
% ���. ����, ����� ���� ������
% ���������� ������ ����� ��� ����������
function RetArrCells = rs_decoder(C, p_sourse, K, t)
% �������������
p = bitroute(p_sourse, length(p_sourse));    % ��� ��������� ������ ����������� ���� � �������
ip = arbit2dec(p);     % ��������� � uint
m = length(p)-1;    % ������� ������������� ����������
GF = 2^m;            % ����� ��������� � ���� 2^(������� �������� ����������)
% �������� 
% 1. ������ ���� � ����� � ������� ����� ���������� ������
% 2. ��� ��� ��
% 2*t;         % ����� ����������� ��������
N = 2*t+K;        % ����� �������� � ������� �����
j0 = 1;            % ��������� �������
% ��������� �������
[index_of alpha_to] = getLook_up(p_sourse);
% ����������� ���������
% � �������� �� ����� ���� ����������, ������� �� ��������� ����������� ��� ��������
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 

% ���������� �������
tmp = [];
for i = 1:length(C)
    tmp = [tmp i-1];
end
RetArrCells(1,1) = {tmp};   
RetArrCells(1,2) = {C};  %! �_n-1 +...+C_0

fid_tb = fopen('rs_255_full8_roots.vec', 'wt');  % ������ �������� �����
for i = 1:length(C)
  fwrite(fid_tb, [num2str(dec2bin(C(i))) char(10)]);  
end
fclose(fid_tb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Decoder %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% C������� �� 2t %%%%%%%%%%%%%%%%%%%
fprintf('���������� ���������...')

fid_tb = fopen('rs_drm_roots.vec', 'wt');
fid_tb_sin = fopen('rs_drm_s_serial.vec', 'wt');
tmp = [];
for j = 1:2*t
  s(j) = 0;
  % !point ������ �����
  alpha_to(1+j0+j-1);
  fwrite(fid_tb, ['assign ' num2str(dec2bin(alpha_to(1+j0+j-1))) char(10)]);  
  for i = 1:length(C)
    if j == 1  % !point ���� ����� ���������
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
% ��������
%asfsdf
RetArrCells(1,3) = {s} ;
bitroute(s, length(s))
save sindroms s;
fprintf('��\n')

if sum(s) ~= 0  % ���� ��� ����������

%%%%%%%%%%%%%%%%%%%%%%%%%% RiBM %%%%%%%%%%%%%%%%%%%%%%%%%

  fprintf('������ �������� ���������...')
  [lambda, omega] = gribm(t, s, unicalc)  % ����������� �����  
  % ������� �������  

  lambda_deg = -1; 
  for j = 0:t
    if lambda(j+1) ~= 0
      lambda_deg = j;   
    end
  end

 RetArrCells(1,4) = {lambda};
 fprintf('��\n')
 save lambdas lambda;
   
%%%%%%%%%%%%%%%%%%%%%%%%% ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf('���������� ������ �������� ���������...')
  
  omega_deg = lambda_deg-1;
  fid_pow = fopen('rs_drm_pow0.vec', 'wt');
  num_roots = 0;
  for k = 0:GF-2  % �� �������� �����
      % �������� Lambda(Alpha^i) ���������� ��������� ��������
      alpha_k = gpow(alpha_to(2), k, unicalc);
      fwrite(fid_pow, [num2str(dec2bin(alpha_k)) char(10)]);  
      result = 0;
      for j = 1:lambda_deg+1 % �� ����� ������������� � �����
          % ����������� (alpha^i)^k
          result = gmult(alpha_k, result, unicalc);
          result = myxor(lambda(j), result, 8);
	  end
      if result == 0  % ������ ������
        root_inv(num_roots+1) = alpha_k;  % x_i^(-1) ! ���! ��� ���������� �����
        root_pow(num_roots+1) = k;  % ��������� ������
        num_roots = num_roots+1;  % ����� ������
      end
  end

  fclose(fid_pow);
  %%%%%%%% �������� ������� � ������������� %%%%%%%%%

  if num_roots == lambda_deg   % ������������ ����� 
      RetArrCells(1,1) = {num2str(num_roots)}; % ����� ������
      fprintf('��\n')
  
  %%%%%%%%%%%%%%%%%%%%%%% ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % x*der(x)
    for i = 1:lambda_deg
        if bitand(i,1) ~= 0  % �������� �� �������� 
          lambda_der(i)=lambda(i+1);
        else
          lambda_der(i)=0;  
        end
    end
	lambda
	omega'
	lambda_der = [0 lambda_der]; % ���������
    % �����������
    RetArrCells(1,6) = {lambda_der};
    
    fprintf('�������� �����...');  
    % ����������� � Omega
	omega = bitroute(omega, length(omega)); % �������� ������
      for j = 1:num_roots
       numerator(j) = 0;
       for k = 1:8%lambda_deg  % ��� ������ ������� ��������� 
         numerator(j) = gmult(ginv(root_inv(j), unicalc),numerator(j), unicalc);
         numerator(j) = myxor(omega(k), numerator(j), 8);
       end
      end
	  numerator
    % ���������� � ����������� ����� ����� �� ��� � ����
	lambda_der = bitroute(lambda_der, length(lambda_der))  % ����������� ���� �� ����������� ��������
    for j = 1:num_roots
      denominator(j) = 0;
      for k = 1:lambda_deg+1
        denominator(j) = gmult(ginv(root_inv(j), unicalc),denominator(j) , unicalc);
        denominator(j) = myxor(lambda_der(k), denominator(j) , 8);
      end
	  denominator(j) = ginv(denominator(j), unicalc);
    end
	denominator %= bitroute(denominator, length(denominator));


% ������� � �������������� ������
% ����� �� ����� � ��� �������
tt = gpow(alpha_to(2), 2*t+1 , unicalc)  % "+1" ����� ������� ����� �� ����� � ������
for j = 1:num_roots
    gpow(ginv(root_inv(j), unicalc), 2*t+1 , unicalc)
    numerator(j) = gmult(numerator(j), gpow(ginv(root_inv(j), unicalc), 2*t+1 , unicalc), unicalc);
    correct_poly(j) = gmult(numerator(j), denominator(j), unicalc); % ��������
end

corpp = zeros(1,N);
fprintf('��\n')

%%%%%%%%%%%%%%%%%%%%% ����������� ������ %%%%%%%%%%%%%%%%%%%
fprintf('����������� ������...');
%%%% !!!! ��������
C = bitroute(C, length(C));
for k = 1:num_roots
      C(root_pow(k)+1) = myxor(correct_poly(k), C(root_pow(k)+1), 8);
      corpp(root_pow(k)+1) = correct_poly(k); 
end
C = bitroute(C, length(C));
fprintf('��\n');


%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%

%%%%% ��� ���������� �� ����� %%%%%
% ��� �������� ������ �� �������
RetArrCells(1,5) = {root_inv};
% ��������������
RetArrCells(1,7) = {bitroute(corpp, length(corpp))};
% 
else    % ������������ ������
  RetArrCells(1,1) = {'! Not decoding'};
  fprintf('! Not decoding\n');
end
%%%% If ������� ����
else
     RetArrCells(1,1) = {'! No errors'}; 
     fprintf('! No errors\n');
end
% �����
RetArrCells(1,8) = {C};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
