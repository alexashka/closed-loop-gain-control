% ��������� ����� ����������� ������������ ��������� � � b - uint_iLen
function iMult = gmult(a, b, unicalc)
	% �����������
	%index_of = unicalc{1,1};
	%alpha_to = unicalc{1,2};
	%GF =unicalc{1,3}

	if (a == 0) | (b == 0) 
		iMult = 0; % ��������� �� ����
		return
	end

	% ����� �� ����
    asdf = unicalc{1,1}(a)+unicalc{1,1}(b)-2;
	iPow = mod(unicalc{1,1}(a)+unicalc{1,1}(b)-2,unicalc{1,3}-1);
    % �� ������� ����
    iMult = unicalc{1,2}(iPow+1);	% ������� �����, �.�. ��������� �������� � 1 � ������������ ����� �� ������

% not ML	
% endfunction

