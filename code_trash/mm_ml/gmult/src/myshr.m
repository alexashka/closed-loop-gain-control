% << myshl
function iquit = myshr(iQ, iLen)
% ���� ���������� xor 
for i = 1:iLen % ������ ������ ����� �� ����
	h = mod(iQ,2);
	iQ = (iQ-h)/2; 
	q(i) = h;
end
% ��������
q(:,1) = [];
q = [q 0];


% ������ ���� �������(�������� ������� ���������� ����)
tmp = 0;
for j = 1:iLen
	tmp = tmp+q(j)*2^(j-1); 
end
iquit = tmp;

% ��������� � ����� � �����������������

% not ML
% endfunction
