% преобразует массив инт в !строчку мифозного файла
function cTmp = decarr2mif(A)
	cTmp = [];
	for j = 1:length(A)
		if A(j) < hex2dec('10') 
			cTmp = [cTmp '0' dec2hex(A(j))];
		else
			cTmp = [cTmp dec2hex(A(j))];
		end
		% форматирование
		if (mod(j, 1)) == 0
			cTmp = [cTmp ' '];	
		end
		if (mod(j, 4)) == 0
			cTmp = [cTmp ' '];	
		end
		%
		if mod(j, 16) == 0
			cTmp = [cTmp  char(10)];	
		end
    end
