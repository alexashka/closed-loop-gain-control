function Aw = int2hexchar_save(QW, step)
for i = 1:step
cTmp = [];
A = QW{1,i};
k = i;
dflag = length(A)/16;
flag = floor(dflag);
u = 0;
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
		%if (mod(j, 4)) == 0
		%	cTmp = [cTmp ' '];	
		%end
		%
        if (u == flag) && (dflag-flag ~= 0)
           Aw(1,k) = {cTmp}; 
        end
		if mod(j, 16) == 0 
			%cTmp = [cTmp  char(10)];
            Aw(1,k) = {cTmp};
            cTmp = [];
            k = k+step;
            u = u+1;
        end
        
	end
 end