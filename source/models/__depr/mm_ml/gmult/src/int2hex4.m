% инт в четырехзнаковое hex
function cRez = int2hex4(iInp)
cRez = [];
tmp = 0;
for i = 1:4
	tmp = mod(iInp, 16);
	iInp = (iInp-tmp)/16;
	% запись результата
	cRez = [dec2hex(tmp) cRez];
end

