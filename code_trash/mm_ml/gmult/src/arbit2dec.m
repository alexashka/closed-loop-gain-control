% ������� ������ � int
% ������� ���������� [LSB, MSB]
function q = arbit2dec(iQ)

% ���� ���������� xor 
iLen = length(iQ);

% ������ ���� �������(�������� ������� ���������� ����)
tmp = 0;
for j = 1:iLen
	tmp = tmp+iQ(j)*2^(j-1); 
end
q = tmp;

% ��������� � ����� � �����������������

% not ML
%endfunction
