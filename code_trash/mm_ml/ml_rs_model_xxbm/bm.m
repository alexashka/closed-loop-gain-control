  % ���������������� ������� ��������� �.-�����
 % "High-Speed Low-Complexity Reed-Solomon Decoder
 % using Pipelined Berlekamp-Massey Algorithm and Its 
 % Folded Architecture"
 clear;  clc;
%  K = 9;  t = 3;  % �������������� ��������, ������� ������ ����� ���������
%  p_sourse = [1 0 0 1 1];  % x4+x+1 gf(16)
 K = 207;  t = 24;				
  p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
 p = bitroute(p_sourse, length(p_sourse));	% ��� ��������� ������ ����������� ���� � �������
 ip = arbit2dec(p); 	% ��������� � uint
 m = length(p)-1;	% ������� ������������� ����������
 GF = 2^m;			% ����� ��������� � ���� 2^(������� �������� ����������)
 % �������� 
 % 1. ������ ���� � ����� � ������� ����� ���������� ������
 % 2. ��� ��� ��
 T = 2*t; 		% ����� ����������� ��������
 N = T+K;		% ����� �������� � ������� �����
 j0 = 1;			% ��������� �������
 % ��������� �������
 [index_of alpha_to] = getLook_up(p_sourse);
 % ����������� ���������
 % � �������� �� ����� ���� ����������, ������� �� ��������� ����������� ��� ��������
 unicalc{1,1} = index_of; 
 unicalc{1,2} = alpha_to; 
 unicalc{1,3} = GF; 
 unicalc{1,4} = m; 
 %%% �������� ��������� %%%%%%%%
 load sindroms;
 load lambdas;
 load omegas; 

% ������ ����������
  lambda_deg = 0;  l_er = 0; 
  discrep = 0;  % �������
  % ��������� ���������
  lambda = [1 zeros(1, T/2)];
  prev_lambda = [0 1 zeros(1, T/2-1)]; % B(x) ����� ��������
  tau = zeros(1, T); 
  % �������� ���������� (����)
  for i_round = 1:T  % ���� �� ����������� ��������
    discrep = 0;  % ������� ��������
    for i = 1:l_er+1
      mpp = gmult(s(i_round-i+1),lambda(i), unicalc);
      discrep = myxor(discrep, mpp,8);  % ������� �������
    end
    % ��������� �������. ������������ ����
    if discrep ~= 0
      for k = 1:T/2+1 % ����� �� ����� ������ 
        mpp = gmult(discrep, prev_lambda(k), unicalc);
        tau(k) = myxor(lambda(k), mpp, 8);
        if tau(k) ~= 0  % ������ �������
          lambda_deg = k-1; % ����� ������� ������� ������
        end
      end
      % ����� ���������
      if 2*l_er < i_round 
        l_er = i_round-l_er;
        for k = 1:T/2+1
          prev_lambda(k) = gdiv(lambda(k), discrep, unicalc);
        end
      end 
      % ��������� ���� ������
      lambda = tau;
      tau = zeros(1, length(tau));    % ��������
    end
    % �������� ������ �������
    prev_lambda = [0 prev_lambda];
    prev_lambda(:,end) = []; % �������� ��������� ��������
    % prev_lambda_deg = prev_lambda_deg+1; 
  end
  % ������ �������� ��������
  % ����� �� ��������� ����������� ����������� ������ � ��������
  % ��������
lambda_deg