% битовый массив в int
% порядок следования [LSB, MSB]
function q = arbit2dec(iQ)

% свой реализайия xor 
iLen = length(iQ);

% первый байт младший(обратный порядок следования байт)
tmp = 0;
for j = 1:iLen
	tmp = tmp+iQ(j)*2^(j-1); 
end
q = tmp;

% переводим в целое и шестнадцатиричное

% not ML
%endfunction
