clear; clc
names = {'Ru_f1.wav', 'bluzz.wav'};
pos = 2;
% notes ! важно оценить размер
head = wavread(names{pos}, 'size');
head(1); % samples
head(2); % channals

% reading
[s, Fs, bitPerSample] = wavread(names{pos}, 50000);
  % похоже что double
slice = s(:, 1);
%strips(s(:, 1), 160000) % 
  %grid on
  
% processing 

% song = sound(y, Fs); sondsc(y, Fs), wavplay(y, Fs)
%sound(slice, Fs, bitPerSample) % работает в фоне

% writting
wavwrite(s(:, 1), Fs, bitPerSample, 'out.wav')
save s.mat slice


%%% 



%%%
% r = audiorecorder(22050, 16, 1);
% record(r);     % speak into microphone...
% pause(r);
% p = play(r);   % listen
% resume(r);     % speak again
% stop(r);
% p = play(r);   % listen to complete recording
% mySpeech = getaudiodata(r, 'int16'); % get data as 