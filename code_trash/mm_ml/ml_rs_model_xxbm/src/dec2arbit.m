% битовый массив в int
% порядок следования [LSB, MSB]
function q = dec2arbit(iQ, iLen)


% первый байт младший(обратный порядок следования байт)
for i = 1:iLen
	h = mod(iQ,2);
	iQ = (iQ-h)/2; 
	q(i) = h;
end

% not ML
%endfunction
