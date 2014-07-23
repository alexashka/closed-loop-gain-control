function [cTmp, j] = int2hexchar(A, smesh) 
cTmp = [];
cTmp = [cTmp int2hex4(smesh) ' : '];
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
		if mod(j, 32) == 0
            cTmp = [cTmp  ';'];
			cTmp = [cTmp  char(10)];
            cTmp = [cTmp int2hex4(smesh+j) ' : '];
    	end
    end
    cTmp = [cTmp  ';'];
