; #include <headers/protocol_exchange.ink>
#define LEN_INFO_MSG 13
;pg_summaryDataArray	res	1	; pXXX ���������? �� ���? �����? � ��� ��� �� �����������!
 ; ������ ��� ��� � ���. ���������?
;g_summaryDataArray	res LEN_INFO_MSG	; ����� ����� ��������� ����� ������ ��� ��������
; +11 - ������
;	0 - I1
#define bI1Alrm g_summaryDataArray+11, 0
;		1 - I2
;			2 - Iextra
;				3 - U
#define bUalrm g_summaryDataArray+11, 3
;					4 - T
#define bTermAlrmInfo g_summaryDataArray+11, 4
;						5 - Umax
; +12 - �����������