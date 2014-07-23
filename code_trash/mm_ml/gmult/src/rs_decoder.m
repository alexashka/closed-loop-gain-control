% �� ����� �������� ����� � ������� ��� ��������� look-up �������; ���
% ���. ����, ����� ���� ������
% ���������� ������ ����� ��� ����������
function RetArrCells = rs_decoder(C, p_sourse, K, t)
% �������������
p = bitroute(p_sourse, length(p_sourse));	% ��� ��������� ������ ����������� ���� � �������
ip = arbit2dec(p); 	% ��������� � uint
m = length(p)-1;	% ������� ������������� ����������
GF = 2^m;			% ����� ��������� � ���� 2^(������� �������� ����������)
% �������� 
% 1. ������ ���� � ����� � ������� ����� ���������� ������
% 2. ��� ��� ��
T = 2*t; 		% ����� ����������� ��������
N = T+K;		% ����� �������� � ������� �����
j0 = 0;			% ��������� �������
% ��������� �������
[index_of alpha_to] = getLook_up(p_sourse);
% ����������� ���������
% � �������� �� ����� ���� ����������, ������� �� ��������� ����������� ��� ��������
unicalc{1,1} = index_of; 
unicalc{1,2} = alpha_to; 
unicalc{1,3} = GF; 
unicalc{1,4} = m; 
%%% ������������� %%%
tmp = [];
for i = 1:length(C)
	tmp = [tmp i-1];
end
RetArrCells(1,1) = {tmp};
RetArrCells(1,2) = {C};

%%% decoder %%%
% �������� �� 2t
for j = 1:T;
	s(j) = 0;
	for i = 1:length(C)
		s(j) = gmult(alpha_to(1+j0+j-1), s(j), unicalc);
		s(j) = gsum(C(i), s(j), unicalc);
	end
end
% ��������
RetArrCells(1,3) = {s} ;

%%% ����� %%%
if sum(s) ~= 0  % ���� ��� ����������
	% ��������� ���������
	lambda(1) = 1;
	for j = 2:T
		lambda(j) = 0;   
	end
	for j = 1:T
		tau(j) = 0; 
	end
	lambda_deg = 0; 
	idx_i = -1;     % ??
	l_er = 0; 
	discrep = 0; 		% �������
	for j = 3:T
		prev_lambda(j) = 0; 
	end
	prev_lambda(1) = 0;
	prev_lambda(2) = 1;
	% �������� ����� ����������� �������� lambda �� 1, ����
	prev_lambda_deg = lambda_deg+1; 
	% ������� lambda ����� ������ =+1
% �������� ���������� (����)
for i_round = 1:T       % ���� �� ����������� ��������
	if lambda_deg < l_er
		upper_bound = lambda_deg;
	else
		upper_bound = l_er;
	end
	discrep = 0; 		% ������� ��������
	for i = 1:upper_bound+1
		mpp = gmult(s(i_round-i+1),lambda(i), unicalc);
		discrep = gsum(discrep, mpp, unicalc); 		% ������� �������
    end
    % ��������� �������
	if discrep ~= 0		
		for k = 1:T
			mpp = gmult(discrep, prev_lambda(k), unicalc);
			tau(k) = gsum(lambda(k), mpp, unicalc);
			if tau(k) ~= 0  % ������ �������
				tau_deg = k-1;
			end
		end
		% �����..
		if l_er < (i_round-idx_i-1)
			mpp = i_round-idx_i-1; 
			idx_i = i_round-l_er-1; 
			l_er = mpp;

         	% previous_lambda = lambda / discrepancy;
         	for k = 1:T
              	prev_lambda(k) = gdiv(lambda(k), discrep, unicalc);
            end
         	prev_lambda_deg = lambda_deg; 
        end 
        % ��������� ���� ������
		lambda = tau;
		tau = zeros(1, length(tau));    % ��������
     	lambda_deg = tau_deg;
    end
    % �������� ������ �������
    prev_lambda = [0 prev_lambda];
    prev_lambda(:,T+1) = []; % �������� ��������� ��������
	prev_lambda_deg=prev_lambda_deg+1; 
end
% ������ �������� ��������
% ����� �� ��������� ����������� ����������� ������ � ��������
% ��������
RetArrCells(1,4) = {lambda};


%%% ���� %%%
poly_degre = lambda_deg; 
root_list_size = 1; 
bEq = 0;
i = 0;
root = [];
for k = 1:GF-1
    if bEq == 0    % ������������� � ���, ��� ��� ������ �������
        % �������� Lambda(Alpha^i)
        result = 0;
        for k = 1:lambda_deg+1
            alpha_k = gpow(alpha_to(i+1),k-1,unicalc);
            % �����������
            % (alpha^i)^k
            mpp = gmult(lambda(k),alpha_k, unicalc);
            result = gsum(result, mpp, unicalc);
        end
        % ��������� �������
        if  result == 0  
            root(root_list_size) = i+1;
            root_list_size = root_list_size+1;
        end
        if root_list_size == poly_degre+1  
            bEq = 1;
        end
    end
    i = i+1;
end

if length(root) == lambda_deg % ������������ �����
    RetArrCells(1,1) = {num2str(length(root))}; % ����� ������
% �������
    
%%% ����� %%%;
omega = zeros(1, K);
lambda_buf = [lambda zeros(1,K-length(lambda))];
for j = 1:T
	for i = 1:K     % ����� �������������� ��������
    	omega(i) = gsum(omega(i), gmult(s(j), lambda_buf(i), unicalc) ,unicalc);
	end 
	% �������� �������
	lambda_buf = [0 lambda_buf];
	lambda_buf(:,K+1) = [];
end

%% ����� ����� �� ������ x^T = x^6 �.� T ���������
%% ���������� ? ����������� �����������
for i = 1:lambda_deg	
	if mod(i,2) ~= 0 
		lambda_der(i)=lambda(i+1);
	else          
		lambda_der(i)=0;
	end
end
% �����������
RetArrCells(1,6) = {lambda_der};

% ����������� 
for i = 1:root_list_size-1	% �� ����� ������ ?? ������� � -1
	alpha_invert(i)=alpha_to(root(i));%+1);
	numerator = 0;
end

% ����������� � ���������
mpp = 0;
for j = 1:root_list_size-1
	for k = 1:T		% ����� �������  1 1 1 0 0 0
		mpp = gsum(mpp,  gmult(omega(k), gpow(alpha_invert(j), k-1, unicalc), unicalc), unicalc);
	end
	numerator(j) = mpp;
	mpp = 0;
end
% ���������� � �����������
mpp = 0;
for j = 1:root_list_size-1
	for k = 1:length(lambda_der)		% ����� �������  1 1 1 0 0 0
		mpp = gsum(mpp,  gmult(lambda_der(k), gpow(alpha_invert(j), k-1, unicalc), unicalc), unicalc);
	end
	denominator(j) = mpp;
	mpp = 0;
end
% ������� � �������������� ������
for j = 1:root_list_size-1
	correct_poly(j) = gdiv(numerator(j), denominator(j), unicalc); % ��������
end
corpp = zeros(1,N);
% ����������� root
for k = 1:length(root)
    if root(k) == 1
        root_tmp(k) =  K+t*2;  
    else
        root_tmp(k) = mod((root(k)-1),K+t*2);
    end
end
RetArrCells(1,5) = {root_tmp-1};
%%%% ����������� ������ %%%%
for  k = 1:length(root)
	C(root_tmp(k)) = myxor(correct_poly(k), C(root_tmp(k)), 8);
	corpp(root_tmp(k)) = correct_poly(k);
end
% ��������������
RetArrCells(1,7) = {corpp};


%% 
else    % ������������ ������
  RetArrCells(1,1) = {'! Not decoding'}; 
end
%%%% If ������� ����
else
     RetArrCells(1,1) = {'! No errors'}; 
end
% �����
RetArrCells(1,8) = {C};



%%%%%% impl %%%%
% 1. ��� ����� ������� ������� (length....)
% 2. ������ ����������
% 3. ������ ������
