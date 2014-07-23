% ��������� ��� uint ����� 
% ������������ �� iLen-���������
% ��������� XOR
% ��������� uint_iLen ���������


function q = myxor(iQ, iT, iLen)
% ���� ���������� xor 
for i = 1:iLen
	h = mod(iQ,2);
	iQ = (iQ-h)/2; 
	j = mod(iT,2);
	iT = (iT-j)/2;
	q(i) = xor(h, j);
end

% ������ ���� �������(�������� ������� ���������� ����)
tmp = 0;
for j = 1:iLen
	tmp = tmp+q(j)*2^(j-1); 
end
q = tmp;

% ��������� � ����� � �����������������

% not ML
% endfunction
