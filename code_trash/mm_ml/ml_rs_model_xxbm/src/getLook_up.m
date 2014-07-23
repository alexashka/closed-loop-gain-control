% ���������� look-up �������
function [index_of alpha_to] = getLook_up(p_sourse)


% �������������
p = bitroute(p_sourse, length(p_sourse));	% ��� ��������� ������ ����������� ���� � �������
ip = arbit2dec(p); 	% ��������� � uint
m = length(p)-1;	% ������������ ������� ������������� ���������� 
GF = 2^m;		% ����� ��������� � ���� 2^(������� �������� ����������)
overflow = arbit2dec([zeros(1,m) 1]); 	% ��� �������� ������������

%%% ���������� %%%

% ������ look-up ������� ��� ���������-�������
% ����� �� alpha^i
tmp = 1; %
for i=1:GF-1		% ���������� ���������
	% 1. ��������
	% 2. ���� ������������ ��������� �� ������
	% 3. ���� ��� �� ������� �������� 
	% 4. �����������

	% ��������� ������� � ���������������
	if(tmp >= overflow)
		tmp = myxor(tmp, ip, m);
		alpha_to(i) = tmp;
		index_of(alpha_to(i)) = i;
		tmp =  myshl(tmp,m+1); 	% �������� ���������� (����� ����������� ���������, ����� �����. �����.)
	else
		alpha_to(i) = tmp;
		index_of(alpha_to(i)) = i;
		tmp =  myshl(tmp,m+1); 	% �������� ���������� (����� ����������� ���������, ����� �����. �����.)
	end
end


% ����� ���� �������
tmp = [];
for i=1:GF-1
	tmp = cat(1, tmp, [ i index_of(i)-1 alpha_to(i) bitroute(dec2arbit(alpha_to(i),m), m) ]);
end
look_up = tmp; 	% [������  ��������� �������(����)  ����_����������_������ �����_������� ]


% endfunction
