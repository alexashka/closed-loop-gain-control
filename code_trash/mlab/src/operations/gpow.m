 
function iPow = gpow(a, ipow, unicalc)
	% расприновка	
	%index_of = unicalc{1,1};
	%alpha_to = unicalc{1,2};
	%GF = unicalc{1,3};
	iTmp = mod((unicalc{1,1}(a)-1)*ipow,unicalc{1,3}-1);
	iPow = unicalc{1,2}(iTmp+1);
% endfunction

