 % ���������������� ������� ��������� �.-�����
 % "High-Speed Low-Complexity Reed-Solomon Decoder
 % using Pipelined Berlekamp-Massey Algorithm and Its 
 % Folded Architecture"
 
 % ������ ������ �������������� ����������, ������� ������ �����
 % � ��� ���� ������
 clear;  clc;
 
  K = 239;  t = 8;				
  p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
 
 p = bitroute(p_sourse, length(p_sourse));  % ��� ��������� ������ ����������� ���� � �������
 ip = arbit2dec(p);   % ��������� � uint
 m = length(p)-1;  % ������� ������������� ����������
 GF = 2^m;      % ����� ��������� � ���� 2^(������� �������� ����������)
 % �������� 
 % 1. ������ ���� � ����� � ������� ����� ���������� ������
 % 2. ��� ��� ��
 T = 2*t;     % ����� ����������� ��������
 N = T+K;    % ����� �������� � ������� �����
 j0 = 1;      % ��������� �������
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
 
 %%%%%%%%%%% ���������� %%%%%%%%%%%%%
 % init
 %%% ��������� �������� %%%
 delta = zeros(3*t+2, 8*t+1);
 ttt = zeros(3*t+2, 8*t+1);
 k = zeros(1, 8*t+1);
 gamma = zeros(1, 8*t+1);
 
 % ����������
 delta(3*t+0+1, 0+1) = 1;
 k(0+1) = 0;
 gamma(0+1) = 1;
 
 for i = 0:2*t-1
     delta(i+1, 0+1) = s(i+0+1);
     ttt(i+1, 0+1) = s(i+0+1);
 end
 % calc
 
 % main cycle
 for r = 0:4*t-1  % ����� ����� ���������
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
 
 