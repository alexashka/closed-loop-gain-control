% �������� ������� 
function iInv = ginv(b, unicalc)
	% ����������
	%index_of = unicalc{1,1};
	%alpha_to = unicalc{1,2};
	%GF = unicalc{1,3};]

	if(b == 0) 
		iInv = '! ������� �� ����"; % !! ������� �� ����'
		return;
	end
	% �������� ������
	idiff = unicalc{1,1}(1)-unicalc{1,1}(b);
	if idiff < 0	% ������������� ���������
		idiff = idiff+unicalc{1,3}-1;
	end
	iInv = unicalc{1,2}(idiff+1);
end
% endfunction
