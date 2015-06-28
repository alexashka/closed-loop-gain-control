addpath(cat(2,pwd,'\src'));
clear;  clc;
%%%
p_sourse = [1 0 0 0 1 1 1 0 1];  % x8+x+1
p_sourse = [1 0 0 1 1];  % x4+x+1 gf(16)

[index_of alpha_to] = getLook_up(p_sourse)