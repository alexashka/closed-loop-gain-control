% function [ output_args ] = Untitled1( input_args )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
flag = 0;
jon = wav2ws('src_jon_8_16.wav');
my = wav2ws('src_my_8_16.wav');
if flag == 1
  lsf1to10 = load( 'lsf.mat' )
else
  lsf1to10 = load( 'lsf_Russian_5.mat' )
end
% CB_lsf1to3_bit = lsf1to10.sqfull(2:4, 1:end);
% CB_lsf4to6_bit = lsf1to10.sqfull(5:7, 1:end);
% CB_lsf7to10_bit = lsf1to10.sqfull(8:11, 1:end);
% 
CB_lsf1_bit = lsf1to10.sqfull(2, 1:end);
CB_lsf2_bit = lsf1to10.sqfull(3, 1:end);
CB_lsf3_bit = lsf1to10.sqfull(4, 1:end);
CB_lsf4_bit = lsf1to10.sqfull(5, 1:end);
CB_lsf5_bit = lsf1to10.sqfull(6, 1:end);
CB_lsf6_bit = lsf1to10.sqfull(7, 1:end);
CB_lsf7_bit = lsf1to10.sqfull(8, 1:end);
CB_lsf8_bit = lsf1to10.sqfull(9, 1:end);
CB_lsf9_bit = lsf1to10.sqfull(10, 1:end);
CB_lsf10_bit = lsf1to10.sqfull(11, 1:end);

if flag == 1
  name = 'ws256en.mat'
else
  name = 'ws1024ru.mat'
end

%
save(name, 'finalCB1')
save(name, 'finalBP1', '-append')
save(name, 'finalCB2', '-append')
save(name, 'finalBP2', '-append')
save(name, 'finalCB3', '-append')
save(name, 'finalBP3', '-append')
save(name, 'finalCB4', '-append')
save(name, 'finalBP4', '-append')
%
save(name, 'finalCB6', '-append')
save(name, 'finalBP6', '-append')
save(name, 'finalCB7', '-append')
save(name, 'finalBP7', '-append')
save(name, 'finalCB8', '-append')
save(name, 'finalBP8', '-append')
save(name, 'finalCB9', '-append')
save(name, 'finalBP9', '-append')
save(name, 'finalCB10', '-append')
save(name, 'finalBP10', '-append')

save(name, 'finalCB5', '-append')
save(name, 'finalBP5', '-append')


