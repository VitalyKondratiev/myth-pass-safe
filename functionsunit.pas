unit functionsUnit;

{$mode objfpc}{$H+}

interface

uses SysUtils, Classes, FileUtil, Forms, LazUTF8, INIFiles;

  procedure openingFile(foFile: String);
  procedure createUEFiles(fcFolder: String);
  procedure cleaningFile(fcFile: String);
  procedure guiToAppLoadPhase();
  procedure loadAppSettings();
  function CodeDecodeUTF8String(sourceString: String; cdAction: Boolean): String;
  function CodeFileStringLoginIndex(loginStr, fiFile: String): Integer;

implementation

uses
  mainUnit, appSettingsUnit;

{ Процедура открытия файла}
procedure openingFile(foFile: String);
begin
  guiToAppLoadPhase();
  mainForm.viewFileContentListBox.Items.LoadFromFile(UTF8ToSys(foFile)); // Загружаем строки из файла
  mainForm.selectStringNumberSpinEdit.MaxValue := mainForm.viewFileContentListBox.Items.Count; //  Передаем количество строк компоненту SpinEdit
  if mainForm.viewFileContentListBox.Items.Count = 0 then begin
    mainForm.checkDataButton.Enabled := False; // Отключаем кнопку "Сайт?"
    mainForm.selectStringNumberSpinEdit.Enabled := False; // Отключаем выбор строки
  end else begin
    mainForm.checkDataButton.Enabled := True; // Активируем кнопку "Сайт?"
    mainForm.selectStringNumberSpinEdit.Enabled := True; // Активируем выбор строки
  end;
  with mainForm do begin
   fileMainButton.Enabled := True; // Активируем кнопку "Обновить файл"
   fileCloseButton.Enabled := True; // Активируем кнопку "Закрыть файл (X)"
   managerGroupBox.Enabled := True; // Активируем группу "Менеджер текущей базы"
   viewContentGroupBox.Enabled := True; // Активируем группу "Получение логинов"
   viewFileGroupBox.Enabled := True;; // Активируем панель "Просмотр"
  end;
end;

{ Процедура создания отсутствующих файлов}
procedure createUEFiles(fcFolder: String);
var
  i: Integer;
begin
  for i := 0 to mainForm.viewFileContentListBox.Items.Count -1 do begin
    if not FileExists(UTF8ToSys(fcFolder + mainForm.viewFileContentListBox.Items[i] + '.dmps')) then begin
      with TStringList.Create do
      try
        SaveToFile(UTF8ToSys(fcFolder + mainForm.viewFileContentListBox.Items[i] + '.dmps'));
      finally
        Free;
      end;
    end;
  end;
end;

{ Процедура очистки файла от пустых строк и дубликатов }
procedure cleaningFile(fcFile: String);
var
  i, j: Integer;
begin
  mainForm.tempContentMemo.Lines.LoadFromFile(UTF8ToSys(fcFile)); // Загружаем строки из файла
  i := 0; // Счетчик1 = 0
  while i < mainForm.tempContentMemo.Lines.Count do begin
    if mainForm.tempContentMemo.Lines[i] = '' then begin
      mainForm.tempContentMemo.Lines.Delete(i); // Удаляем пустую строку
      i := i - 1; // Уменьшаем Счетчик1 на 1
    end;
    j := 0; // Счетчик2 = 0
    while j < mainForm.tempContentMemo.Lines.Count do begin
      if (mainForm.tempContentMemo.Lines[j] = mainForm.tempContentMemo.Lines[i]) and (i <> j)
        then begin
          mainForm.tempContentMemo.Lines.Delete(j); // Удаляем повторяющуюся строку
          j := j - 1; // Уменьшаем Счетчик2 на 1
        end;
      j := j + 1; // Увеличиваем Счетчик2 на 1
    end;
    i := i + 1; // Увеличиваем Счетчик1 на 1
  end;
  mainForm.tempContentMemo.Lines.SaveToFile(UTF8ToSys(fcFile)); // Сохряняем строки в файл
end;

{ Процедура возвращения графического интерфейса к изначальному виду}
procedure guiToAppLoadPhase();
begin
  with mainForm do begin
    viewContentGroupBox.Caption := 'Выбор сайта'; // Сбрасываем текст панели "Выбор сайта"
    selectStringNumberSpinEdit.Value := 1;
    windowHeaderLabel.Caption := 'MythPassSafe 0.9'; //Стандартный заголовок окна
    checkDataButton.Caption := 'Сайт?'; // Сбрасываем текст кнопки "Сайт?"
    getDataButton.Caption := 'Получить логины';  // Сбрасываем текст кнопки "Получить логины"
    getDataButton.Enabled := False; // Отключаем кнопку "Получить логины"
    firstLabel.Caption := 'Сайт:'; // Сбрасываем текст надписи "Сайт"
    firstDataEdit.Clear; // Очищаем поле "Сайт"
    secondDataEdit.Clear; // Очищаем поле "Пароль"
    secondLabel.Visible := False; // Скрываем надпись "Пароль"
    secondDataEdit.Visible := False; // Скрываем поле "Пароль"
    vsecondDataEdit.Visible := False; // Скрываем поле "Пароль"
    copyFirstEditSpeedButton.Enabled := False; // Отключаем кнопку копирования логина
    copySecondEditSpeedButton.Enabled := False;
    eyeSecondEditSpeedButton.Enabled:= False;
    copySecondEditSpeedButton.Visible := False; // Скрываем кнопку копирования пароля
    eyeSecondEditSpeedButton.Visible := False; // Скрываем кнопку просмотра пароля
  end;
end;

{ Функция вычисления номера UTF8 символа }
function UTF8ToUnicode(sourceString: String): Integer;
var
  nChar: PChar;
  unicodeNumber: Cardinal;
  CharLen: integer;
begin
  nChar := PChar(sourceString);
  CharLen := UTF8CharacterLength(nChar);
  unicodeNumber:=UTF8CharacterToUnicode(nChar, CharLen);
  UTF8ToUnicode := unicodeNumber;
end;

{ Функция кодирования/декодирования строки }
function CodeDecodeUTF8String(sourceString: String; cdAction: Boolean): String;
var
  i, encodeKey: Integer;
  resultString: String;
begin
  encodeKey := 0;
  resultString := '';
  if cdAction then begin
    Randomize;
    encodeKey := random(99) + 100;
  end else begin
    encodeKey := -abs(strToInt(UTF8Copy(sourceString, UTF8Length(sourceString) - 2, UTF8Length(sourceString))));
    UTF8Delete(sourceString, UTF8Length(sourceString) - 2, UTF8Length(sourceString));
  end;
  for i := 1 to UTF8Length(sourceString) do begin
    resultString := resultString + UnicodeToUTF8(UTF8ToUnicode(UTF8Copy(sourceString, i, i + 1)) + encodeKey);
  end;
  if cdAction then
    CodeDecodeUTF8String := resultString + intToStr(encodeKey)
  else
    CodeDecodeUTF8String := resultString;
end;

function CodeFileStringLoginIndex(loginStr, fiFile: String): Integer;
var
  unCodeString: String;
  index, i: Integer;
begin
  with TStringList.Create do
    try
      LoadFromFile(UTF8ToSys(fiFile));
      for i := 0 to Count - 1 do begin
        unCodeString := UTF8Copy(CodeDecodeUTF8String(Strings[i], False), 1, UTF8Pos(mainUnit.stringSplitter, CodeDecodeUTF8String(Strings[i], False)) - 1);
        if (loginStr = unCodeString) then
          index := i;
      end;
    finally
      Free;
    end;
  CodeFileStringLoginIndex := index;
end;

{ Загрузка настроек из файла }
procedure loadAppSettings();
var
  IniFile: TIniFile;
begin
  if not FileExists(UTF8ToSys('mythpass.ini')) then begin
    with TStringList.Create do
      try
        SaveToFile(UTF8ToSys('mythpass.ini'));
      finally
        Free;
      end;
    IniFile:=TIniFile.Create(UTF8ToSys('mythpass.ini'));
    IniFile.WriteBool('App','MinimalizeToTray', False);
    IniFile.WriteBool('App','OpenLastFile', False);
    IniFile.Destroy;
  end;
  IniFile:=TIniFile.Create(UTF8ToSys('mythpass.ini'));
  appSettingsUnit.lminimizeToTray := IniFile.ReadBool('App','MinimalizeToTray', False);
  appSettingsUnit.lfileLastOpen := IniFile.ReadBool('App','OpenLastFile', False);
  IniFile.Destroy;
  appSettingsUnit.cminimizeToTray := appSettingsUnit.lminimizeToTray;
  appSettingsUnit.cfileLastOpen := appSettingsUnit.lfileLastOpen;
end;

end.

