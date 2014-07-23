% �� ����� �������� ����� � ������� ��� ��������� look-up �������; ���
% ���. ����, ����� ���� ������
% ���������� ������ ����� ��� ����������
function outWord = rs_coder(A, p_sourse, K, t)
% �������������
p = bitroute(p_sourse, length(p_sourse));	% ��� ��������� ������ ����������� ���� � �������
ip = arbit2dec(p); 	% ��������� � uint
m = length(p)-1;	% ������� ������������� ����������
GF = 2^m;			% ����� ��������� � ���� 2^(������� �������� ����������)
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
% ��������� ��� ������� ���������
itmpR = [zeros(1, T-2) 1 alpha_to(1+j0)];
% ��������� ��� ������� ���������, �� �� ����� �������� ���������
itmpM = [zeros(1, T-2) 1 alpha_to(1+j0)];

% ������ �����
for i=1:T-1	% (����� ������ - 1)
	% 1. ��������� �������� �� ���������
	% 2. �������� ����. ��� ��..
	% 3. �������� � ���������� ������� ����������
	% ��� �������� (��������� ������)
	itmp2 = [1 alpha_to(1+j0+i)]; % �������� � (1, alpha^2)(0,0,1,alpha^1)
	% ������ ��� ������
	iRout = itmpM;
	iRout(:,1) =[]; % �������� ������ ��������
	iRout = [iRout 0]; 
	% ��������� � �����������
	for i=1:T
		itmpR(i) = gmult(itmpM(i), itmp2(2), unicalc);
		itmpM(i) = gsum(iRout(i), itmpR(i), unicalc);
	end
end
itmpM;	% ��������� [... g1 g0]
%%% �� ����� ��������������� ��������

%%%% ����������� %%%%
g = itmpM;
regLen = length(g);	% ����� ��������
g =  bitroute(g,regLen);

%%% ������� %%%
for i=1:regLen
	Rest(i) = 0; 	% �������� �����
end
% �����
for i=1:K	% ������� ������ ������� ������ �������� �������������� ��������
	ifeedback = gsum(Rest(regLen),A(i),unicalc);
	% ����
	for j=1:regLen-1
		tmp = gmult(ifeedback, g(regLen+1-j), unicalc);	% �� ����� ����������
		tmp = gsum(Rest(regLen-j), tmp, unicalc);
        Rest(regLen+1-j) = tmp; 		% ����������� ����
    end
    tmp = gmult(ifeedback, g(1), unicalc);  % ��������� �������� �����
    Rest(1) = tmp; 		% ����������� ����
end

% ����� ������� �����
outWord = cat(2, A, bitroute(Rest, length(Rest)));