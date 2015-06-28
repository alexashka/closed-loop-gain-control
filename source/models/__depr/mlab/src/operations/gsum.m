% вычисляет сумму многочленов передаваемые параметры а и b - uint_iLen
function iSum = gsum(a, b, unicalc)
	% расприновка	
	%iLen = unicalc{1,4}(1);	 разрадность даннх
	iSum = myxor(a, b, unicalc{1,4}(1));	% размерность нужна для хоr
% endfunction

