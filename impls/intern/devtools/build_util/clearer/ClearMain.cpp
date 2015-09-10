/*
   ������� �����.
   ��������� ������� ��������, ��������� � �������� ����������
   �������� C++Builder, ����� (obj, tds) � ���������
   ����� (~bpr, ~dfm, ~h, ~cpp) �� ���������� �������������
   �������� � ��� ������������.
   ��� ������ �������� ������������ �����������
   ���� ����� �����.

*/

#include <vcl.h>
#pragma hdrstop

#include "ClearMain.h"



#pragma package(smart_init)
#pragma resource "*.dfm"

TMainForm *MainForm;

__fastcall TMainForm::TMainForm(TComponent* Owner)
    : TForm(Owner)
{
}

#include <FileCtrl.hpp> // ��� ������� � SelectDirectory

AnsiString aDirectory; // �������, ������� ������ ������������
                      //  (� ������� ��������� ������� C++Builder)

AnsiString cDir;      // ������� �������
AnsiString FileExt;   // ���������� �����

int n = 0;            // ���������� ��������� ������

// ������ �� ������ ����� (����� ��������)
void __fastcall TMainForm::Button1Click(TObject *Sender)
{
  HANDLE Handl;
  
  ////////////
  //if ( SelectDirectory("�������� �������","", aDirectory)){
  aDirectory = GetCurrentDir();
  // ������ ����� ����� �������� ������� �� OK
  Label3->Caption = aDirectory;
  // Button2->Enabled = true; // ������ ������ ��������� ��������
  // }
  Memo1->Clear();       // �������� ���� Memo1
  ChDir(aDirectory);    // ����� � �������, ������� ������ ������������

  Clear();              // �������� ������� ������� � ��� �����������
  //

  ShellExecute(Handl, "open", "rmqd.bat", NULL, NULL, SW_SHOW);
    //  //////////
  Memo1->Lines->Add("");
  if (n)
    Memo1->Lines->Add("������� ������: " + IntToStr(n));
  else
  Memo1->Lines->Add("� ��������� �������� ��� ������, ������� ���� �������.");
}

// ������� �������� ����� �� �������� �������� � ��� ������������
void __fastcall TMainForm::Clear(void){
  TSearchRec SearchRec; // ���������� � ����� ��� ��������

  ///////
  cDir = GetCurrentDir()+"\\";
  //
  if(FindFirst("*.*", faArchive, SearchRec) == 0)
    do{  // �������� ���������� �����
      int p = SearchRec.Name.Pos(".");  // ������� ������ �����
      // ������ �� ������� ����� ���������
      FileExt = SearchRec.Name.SubString(p+1,MAX_PATH);
      MainForm->Memo1->Lines->Add(FileExt);
      // ����������� ����� � ���� ����� ��������
      if(((FileExt == "pin") || ( FileExt == "done")||
         (FileExt == "qdf") || ( FileExt == "qdf")||
         (FileExt[1] == 'a') || ( FileExt[1] == 'e')||
         (FileExt[1] == 'f') || ( FileExt[1] == 'm')||
         (FileExt[1] == 's') || ( FileExt[1] == 'r'))&&
         (FileExt != "mpf") && (FileExt != "sdc")){
           MainForm->Memo1->Lines->Add(cDir+SearchRec.Name);
           DeleteFile(SearchRec.Name);
           n++;
      }
    } while(FindNext(SearchRec) == 0);  // �������� ���������� �����
}





