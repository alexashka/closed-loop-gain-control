/*
   Очистка диска.
   Программа удаляет ненужные, созданные в процессе компиляции
   проектов C++Builder, файлы (obj, tds) и резервные
   копии (~bpr, ~dfm, ~h, ~cpp) из указанного пользователем
   каталога и его подкаталогов.
   Для выбора каталога используется стандартное
   окно Обзор папок.

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

#include <FileCtrl.hpp> // для доступа к SelectDirectory

AnsiString aDirectory; // каталог, который выбрал пользователь
                      //  (в котором находятся проекты C++Builder)

AnsiString cDir;      // текущий каталог
AnsiString FileExt;   // расширение файла

int n = 0;            // количество удаленных файлов

// Щелчок на кнопке Обзор (выбор каталога)
void __fastcall TMainForm::Button1Click(TObject *Sender)
{
  HANDLE Handl;
  
  ////////////
  //if ( SelectDirectory("Выберите каталог","", aDirectory)){
  aDirectory = GetCurrentDir();
  // диалог Выбор файла завершен щелчком на OK
  Label3->Caption = aDirectory;
  // Button2->Enabled = true; // теперь кнопка Выполнить доступна
  // }
  Memo1->Clear();       // очистить поле Memo1
  ChDir(aDirectory);    // войти в каталог, который выбрал пользователь

  Clear();              // очистить текущий каталог и его подкаталоги
  //

  ShellExecute(Handl, "open", "rmqd.bat", NULL, NULL, SW_SHOW);
    //  //////////
  Memo1->Lines->Add("");
  if (n)
    Memo1->Lines->Add("Удалено файлов: " + IntToStr(n));
  else
  Memo1->Lines->Add("В указанном каталоге нет файлов, которые надо удалить.");
}

// удаляет ненужные файлы из текущего каталога и его подкаталогов
void __fastcall TMainForm::Clear(void){
  TSearchRec SearchRec; // информация о файле или каталоге

  ///////
  cDir = GetCurrentDir()+"\\";
  //
  if(FindFirst("*.*", faArchive, SearchRec) == 0)
    do{  // проверим расширение файла
      int p = SearchRec.Name.Pos(".");  // позиция первой точки
      // хорошо бы сделать чтоби последней
      FileExt = SearchRec.Name.SubString(p+1,MAX_PATH);
      MainForm->Memo1->Lines->Add(FileExt);
      // определение файла и если нужно удаление
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
    } while(FindNext(SearchRec) == 0);  // проверим расширение файла
}





