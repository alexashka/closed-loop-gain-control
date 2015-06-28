% принимает два uint числа 
% представляет их iLen-разрядами
% выполняет XOR
% возвращет uint_iLen результат


function q = myxor(iQ, iT, iLen)
% свой реализайия xor 
for i = 1:iLen
	h = mod(iQ,2);
	iQ = (iQ-h)/2; 
	j = mod(iT,2);
	iT = (iT-j)/2;
	q(i) = xor(h, j);
end

% первый байт младший(обратный порядок следования байт)
tmp = 0;
for j = 1:iLen
	tmp = tmp+q(j)*2^(j-1); 
end
q = tmp;

% переводим в целое и шестнадцатиричное

% not ML
% endfunction
