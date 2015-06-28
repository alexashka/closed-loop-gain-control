% function main(bType)
% ����������� ����
addpath(cat(2,pwd,'\src'));

% �������� ������
names = {'-- Errors : ' '-- data_in[]  ' '-- sidd_[]    ' '-- lambb_[]   '...
        	'-- root_[]    ' '-- lamdd_[]   ' '-- corpp_[]   ' '-- out_dec[]  '};
%%% ����� �������� ���������� %%%
bType = 2;
% 1 - (15,9); 2 - dvbt; 3 - drm ; 0 - ������� ����� � ������

switch bType
case {0}
edit test_dec_15_8.mif 
edit rs_sym_dvbt_er.mif 
edit rs_sym_drm_er.mif.mif 
%%% (15, 9) %%%
case {1}
	% �������� ������
	p_sourse = [1 0 0 1 1];         % x4+x+1 gf(16)
	fid_r = fopen('test_dec_15_8.mif', 'r');
 	A = fgets(fid_r);   % ������ ���������
 	iData = mifstr2decarr(A);        % ������ �� ����� ������� � �������������
    K = 9; 		% ����� �������������� ��������
    t = 3;			% ������� ������ ����� ���������

 	%%% ������������� %%%
    q = rs_decoder(iData, p_sourse, K, t);
     
    % ��������� ����������
    fid = fopen('Monitor.mif', 'wt');
    smesh = 0;
    r = 0;
    fwrite(fid, names{1,1});
    fwrite(fid, q{1,1});
    fwrite(fid, char([10]));
    fwrite(fid, char([10]));
    for i = 1:7
        fwrite(fid, names{1,i+1});
		fwrite(fid, char([10]));
        [cBuf, r] = int2hexchar(q{1,i+1}, smesh);
        if mod(r, 32) == 0
            smesh = smesh+r+1;
        else
            smesh = smesh+r; 
        end
        
        fwrite(fid, cBuf);
        fwrite(fid, char([10]));
        fwrite(fid, char([10]));
    end
	fclose('all');

%%% DVBT %%%
case {2}
	% ��������� ����
    K = 239; 		% ����� �������������� ��������
    t = 8;			% ������� ������ ����� ���������
    p_sourse = [1 0 0 0 1 1 1 0 1];		% x8+x+1'
        
    fid_r = fopen('rs_sym_dvbt_er.mif', 'r');
    Tmp = [];
        for i = 1:13
            A = fgets(fid_r);
            u = mifstr2decarr(A);
            Tmp = [Tmp u];
        end
   	%%% ����������� %%%
	tmpp = Tmp(1:188);
	% add null
    tmpp(:,end) = [];
 	tmpp = [0 tmpp];
	% add 168
	%tmp_2 = [tmpp(1:168) 168 tmpp(169:187)]
	%bitroute(tmp_2, 188);
	bitroute(tmpp, 188);
	%w = rs_coder([bitroute(tmpp,188)) zeros(1, 51)],p_sourse, K, t );

	w = rs_coder([ans zeros(1, 51)],p_sourse, K, t );
    w(1) = 0;
	%for i = 1:8
       % w(i) = 1;
	%end
	%%% ������������� %%%
	q = rs_decoder(w, p_sourse, K, t);
 
	% ��������� ����������
	% ���������������� ������
    fid = fopen('Monitor.mif', 'wt');
    smesh = 0;
    r = 0;
    fwrite(fid, names{1,1});
    fwrite(fid, q{1,1});
    fwrite(fid, char([10]));
    fwrite(fid, char([10]));
    for i = 1:7
        fwrite(fid, names{1,i+1});
		fwrite(fid, char([10]));
        [cBuf, r] = int2hexchar(q{1,i+1}, smesh);
        if mod(r, 32) == 0
            smesh = smesh+r+1;
        else
            smesh = smesh+r; 
        end
        
        fwrite(fid, cBuf);
        fwrite(fid, char([10]));
        fwrite(fid, char([10]));
    end
	fclose('all');

%%% DRM %%%
case {3}
	fid_r = fopen('rs_sym_drm_er.mif', 'r');
	% � ���� ������
	Tmp = []; 
    for i = 1:16
		A = fgets(fid_r);
        u = mifstr2decarr(A);
        Tmp = [Tmp u];
	end
	for j = 1:16	% �� ��� � dvbt
		
	end
	K = 207; 		% ����� �������������� ��������
	t = 24;			% ������� ������ ����� ���������	
	p_sourse = [1 0 0 0 1 1 1 0 1];		% x8+x+1

	%%% ������������� %%%
   	q = rs_decoder(Tmp, p_sourse, K, t);
 
	% ��������� ����������
	% ���������������� ������
    fid = fopen('Monitor.mif', 'wt');
    smesh = 0;
    r = 0;
    fwrite(fid, names{1,1});
    fwrite(fid, q{1,1});
    fwrite(fid, char([10]));
    fwrite(fid, char([10]));
    for i = 1:7
        fwrite(fid, names{1,i+1});
		fwrite(fid, char([10]));
        [cBuf, r] = int2hexchar(q{1,i+1}, smesh);
        if mod(r, 32) == 0
            smesh = smesh+r+1;
        else
            smesh = smesh+r; 
        end
        fwrite(fid, cBuf);
        fwrite(fid, char([10]));
        fwrite(fid, char([10]));
    end
	fclose('all');
end
% �������� �����
%edit Monitor.mif 
