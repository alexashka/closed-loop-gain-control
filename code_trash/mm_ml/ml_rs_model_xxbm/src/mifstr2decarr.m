% ��������� ������ ���� � int
function iArray = mifstr2decarr(A)
% �������� ��������
		iDynLen = length(A);
		t = 1;
		while t ~= iDynLen
			if A(t) == ' '
				A(:,t) = [];
				t = t-1;
				iDynLen = iDynLen-1;
			end 
			t = t+1;
		end
		while A(1) ~= ':'
			A(:,1) = [];
		end
		A(:,1) = []; % � ��������� ���� �������
		% ������� ���������� � ������ ������
		% ���� ������-��-����
		t = 1;
		while A(t) ~= ';'
			t = t+1;
		end
		for j = 1:t-1
			AA(j) = A(j);
		end
		% ������� � ���
		k = 1;
		for j = 1:length(AA)/2
			iArray(j) = hex2dec([AA(k) AA(k+1)]);
			k = k+2;
		end
