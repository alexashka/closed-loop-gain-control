
function main_goper(a, b)
addpath(cat(2,pwd,'\src'));

%
a = 1;
b = 2;
p_sourse = [1 0 0 0 1 1 1 0 1];		% x8+x+1'
p = bitroute(p_sourse, length(p_sourse));	% ��� ��������� ������ ����������� ���� � �������
ip = arbit2dec(p); 	% ��������� � uint
m = length(p)-1;	% ������� ������������� ����������
GF = 2^m;			% ����� ��������� � ���� 2^(������� �������� ����������)
% ��������� �������
[index_of alpha_to] = getLook_up(p_sourse);
% ����������� ���������
% � �������� �� ����� ���� ����������, ������� �� ��������� ����������� ��� ��������
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
% ��������
out = [];
for i = 0:10
  q = gpow(b, i, unicalc);
  out = [out q];
end
out
%gmult(a,b, unicalc)
%dec2bin(gmult(a,b, unicalc))