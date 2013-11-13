% <Basic audio handling>
% ? ����������� ��������
speech=wavrecord(16000,8000,1,�double�);  % ������ � ��������� 'int16'
%audiorecorder() % for linux 
aro=audiorecorder(16000,16,1);
record(aro);

%To convert the stored recording into the more usual vector of audio, it is necessary to
%use the getaudiodata() command:
speech=getaudiodata(aro, �double�);

% 16-bit format is between ?32 768 and +32 767

%Replaying a vector of sound stored in ?oating point format is also easy:
sound(speech, 8000);
soundsc(speech, 8000);  % ���������

%%% plottint 
%although sometimes it is preferred for the x -axis to display time in seconds:
plot( [ 1: size(speech) ] / 8000, speech);

% </Basic...>

%<Audio processing>
y=filter(b, 1, x);
%An IIR or pole-zero filter is achieved with:
y=filter(b, a, x);
a_spec=fft(a_vector, 256);  % ��������� ����� ��� ��������
plot(abs(fftshift(a_spec)));
plot( [1 : 2*Fs/Ns : Fs], abs(a_spec(1:Ns/2)), �r�);
h=[1, -0.9375];
y=filter(h, 1, s);
soundsc(y);

%
w=240;
n=floor(length(s)/w);
for k=1:n
seg=s(1+(k-1)*w:k*w);
segf=filter(h, 1, seg);  % ��������� ����� ����������
outsp(1+(k-1)*w:k*w)=segf;
end
soundsc(outsp);

% ��������� ���������
w=240;
hst=[];
n=floor(length(s)/w);
for k=1:n
seg=s(1+(k-1)*w:k*w);
[segf, hst]=filter(h, 1, seg, hst);
outsp2(1+(k-1)*w:k*w)=segf;
end
soundsc(outsp2);

% ��
res=pi/size(spectrum);
semilogy(res:res:pi, spectrum);
% .6.2 Other visualisation methods
[c,lags]=xcorr(x,y);

% 2.7 Sound generation


%</Audio processing>
