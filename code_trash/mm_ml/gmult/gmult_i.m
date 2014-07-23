function y = gmult_i(a, b, index_of, alpha_to)
%#eml

% ���������� ������ �������
 if (a == uint8(0)) || (b == uint8(0)) 
     y = uint8(0); % ��������� �� ����
 	return
 end
tmp_0 = index_of(a)-uint8(1);   % ������ ������� �� ������ 254
tmp_1 = index_of(b)-uint8(1);   % ������ ������� �� ������ 254
tmp_2 = uint8(254)-tmp_0; % -1 �.�. ���������� �������� � 1 � ������� ����� �� 1 ������
%%%
if tmp_2 < tmp_1 % ����� ��������
    compary = tmp_1-tmp_2;
else    % �������� index_of(b)-tmp_1-1 = �� ������� �� ������
    compary = tmp_0+tmp_1+uint8(1); % ������ ���������� ������� ������������ �� �����
end
y = alpha_to(compary); 