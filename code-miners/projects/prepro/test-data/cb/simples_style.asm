����� ��������� ��� �����-������ �������� ���������
1. �������� ��������� � �������� � ����������� ��������
  ��� ���������

 Object	code
; ���� ���� �����
_ILabel;(?/?)
	movlw

;;
	cpfseq xxx
	return
	movff
	bc	_localLabelCarry
	bnc	_localLabelCarry2
	mSlideTo	_IOther;(?/?)

;;
	cpfseq xxx
	return
	movf

;;
	cpfseq xxx
	return	;sgfagf
	bz 	_privateOutLabel
	cpfseq xxx
	return	;sgfagf
	bz 	_privateOutLabel
	movf
	cpfseq xxx
	movlw
	;r etlw
	bz 	_privateOutLabel
_localLabelCarry
	movlw
	bz	_XXX
	;r eturn
	
_localLabelCarry2:
	movlw
	return
	
 end