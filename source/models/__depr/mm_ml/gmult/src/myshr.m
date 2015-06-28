% << myshl
function iquit = myshr(iQ, iLen)
% свой реализайия xor 
for i = 1:iLen % просто дробим число на биты
	h = mod(iQ,2);
	iQ = (iQ-h)/2; 
	q(i) = h;
end
% сдвигаем
q(:,1) = [];
q = [q 0];


% первый байт младший(обратный порядок следования байт)
tmp = 0;
for j = 1:iLen
	tmp = tmp+q(j)*2^(j-1); 
end
iquit = tmp;

% переводим в целое и шестнадцатиричное

% not ML
% endfunction
