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

%%%%% testing
mul = gpow(gpow(alpha_to(2), 1, unicalc), GF-1-2*t, unicalc)
shhow(1) = gpow(gpow(alpha_to(2), 0, unicalc), GF-1-2*t, unicalc);
shhow(2) = gmult(shhow(1), mul ,unicalc);
shhow(3) = gmult(mul , shhow(2),unicalc);
shhow(4) = gmult(mul , shhow(3),unicalc);
shhow(5) = gmult(mul , shhow(4),unicalc);
shhow;
ginv(172, unicalc)
%asdfas
%ginv(gpow(alpha_to(2), 1, unicalc), unicalc)
%gpow(alpha_to(2), 255-1, unicalc)
%adg
%%%%
  ommm = [1 2 3 4 5 6 7 8];
  ommm = [2 1 1 1 1 1 1 1];
  ommm = [54     7   250    17   133   202   150    21    22];%[38    60   228   122    50    22   204     3    64];
  ommm = [91    85   135    56    57    56   157    66];%[0     7   0    17   0   202   0    21    0];
  ommm = bitroute(ommm, length(ommm));
  ommm2 = ommm;%[78    67   253    97   235   157    23   208];
  %ommm = [8 7 6 4 4 3 2 1];

  omr_tmp = [];
  for j = 0:7
    alpha_k(j+1) = gpow(alpha_to(2), j, unicalc);
  end
  for k = 0:10 %GF-2  % �����
      % �������� Lambda(Alpha^i) ���������� ��������� ��������
      if k == 0
        for i = 0:7
          omr(i+1) = ommm(i+1);  % ����������� (�����. �� ���. ����.)
        end
		tt = [omr(1); omr(2);omr(3);omr(4);omr(5);omr(6);omr(7);omr(8)]';
      end
	  
      % ������������
      omr_sum = omr(1);
      for i = 1:7
          omr_sum = gsum(omr_sum, omr(i+1), unicalc);  
          % ����������� (�����. �� 
      end
      % ���������
      for i = 0:7
          omr(i+1) = gmult(alpha_k(i+1), omr(i+1), unicalc);  
          % ����������� (�����. �� ���. ����.)
      end
	  tt = [omr(1); omr(2);omr(3);omr(4);omr(5);omr(6);omr(7);omr(8)]';
	  omr_tmp = [omr_tmp omr_sum];
  end
  omr_tmp
  omr_tmp = [];
  for k = 0:10
    result = 0;
	alpha_k = gpow(alpha_to(2), k, unicalc);
	alpha_k;
    for j = 1:8  % �� ����������� �����
	  result = gmult(alpha_k, result, unicalc);
      result = gsum(ommm2(j), result, unicalc);
	end
	result;
	omr_tmp = [omr_tmp result];
  end
  omr_tmp
%dsfg

% ���������� �������
tmp = [];
for i = 1:length(C)
    tmp = [tmp i-1];
end
RetArrCells(1,1) = {tmp};   
RetArrCells(1,2) = {C};  %! �_n-1 +...+C_0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Decoder %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% C������� �� 2t %%%%%%%%%%%%%%%%%%%
fprintf('���������� ���������...')

fid_tb = fopen('rs_drm_roots.vec', 'wt');
fid_tb_sin = fopen('rs_drm_s_serial.vec', 'wt');
for j = 1:2*t
  s(j) = 0;
  % !point ������ �����
  fwrite(fid_tb, ['assign ' num2str(dec2bin(alpha_to(1+j0+j-1))) char(10)]);  
  for i = 1:length(C)
    if j == 1  % !point ���� ����� ���������
      fwrite(fid_tb_sin, [num2str(dec2bin(s(j))) char(10)]);   
    end
    s(j) = gmult(alpha_to(1+j0+j-1), s(j), unicalc);
    s(j) = gsum(C(i), s(j), unicalc);
  end
end
fclose(fid_tb);
fclose(fid_tb_sin);
% ��������
asfsdf
RetArrCells(1,3) = {s} ;
bitroute(s, length(s))
save sindroms s;
fprintf('��\n')

if sum(s) ~= 0  % ���� ��� ����������

%%%%%%%%%%%%%%%%%%%%%%%%%% RiBM %%%%%%%%%%%%%%%%%%%%%%%%%

  fprintf('������ �������� ���������...')
  [lambda, omega] = gribm(t, s, unicalc);  % ����������� �����  
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
	omega = ommm2; %bitroute(omega, length(omega)); % �������� ������
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


