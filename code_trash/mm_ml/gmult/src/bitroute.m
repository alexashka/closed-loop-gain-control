function q = bitroute(iQ, iLen)

% ������ ���� �������(�������� ������� ���������� ����)
for i = 1:iLen
	q(i) = iQ(iLen-i+1);
end

% not ML
%endfunction
