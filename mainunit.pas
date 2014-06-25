unit mainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Dialogs, StdCtrls, ExtCtrls,
  Spin, Buttons, LazUTF8, ClipBrd, Menus, UniqueInstance;

type

  { TmainForm }

  TmainForm = class(TForm)
    appCloseButton: TButton;
    appSettingsButton: TButton;
    checkDataButton: TButton;
    eyeSecondEditSpeedButton: TSpeedButton;
    firstDataEdit: TEdit;
    fileSaveDialog: TSaveDialog;
    appTrayIcon: TTrayIcon;
    exitPMenuItem: TMenuItem;
    splitterPMenuItem: TMenuItem;
    showMainPMenuItem: TMenuItem;
    cleanClipBoardTimer: TTimer;
    trayPopupMenu: TPopupMenu;
    AppUniqueInstance: TUniqueInstance;
    vsecondDataEdit: TEdit;
    viewPassTimer: TTimer;
    windowManageButtonsBackgroundImage: TImage;
    viewFileContentListBox: TListBox;
    secondDataEdit: TEdit;
    getDataButton: TButton;
    fileOpenDialog: TOpenDialog;
    firstLabel: TLabel;
    secondLabel: TLabel;
    selectStringNumberSpinEdit: TSpinEdit;
    copySecondEditSpeedButton: TSpeedButton;
    copyFirstEditSpeedButton: TSpeedButton;
    startAppTimer: TTimer;
    tempContentMemo: TMemo;
    windowBackgroundImage: TImage;
    windowCloseImage: TImage;
    windowMinimizeImage: TImage;
    windowIconImage: TImage;
    windowCloseTrueImage: TImage;
    windowCloseFalseImage: TImage;
    windowHeaderLabel: TLabel;
    managerAddButton: TButton;
    managerChangeButton: TButton;
    Button3: TButton;
    fileOpenButton: TButton;
    fileMainButton: TButton;
    fileNewButton: TButton;
    fileCloseButton: TButton;
    fileGroupBox: TGroupBox;
    appGroupBox: TGroupBox;
    managerDeleteButton: TButton;
    windowBorderBottomShape: TShape;
    windowBorderRightShape: TShape;
    windowBorderLeftShape: TShape;
    windowHeaderImage: TImage;
    viewContentGroupBox: TGroupBox;
    viewFileGroupBox: TGroupBox;
    managerGroupBox: TGroupBox;
    windowMinimizeTrueImage: TImage;
    windowMinimizeFalseImage: TImage;
    procedure appCloseButtonClick(Sender: TObject);
    procedure appSettingsButtonClick(Sender: TObject);
    procedure appTrayIconClick(Sender: TObject);
    procedure AppUniqueInstanceOtherInstance(Sender: TObject;
      ParamCount: Integer; Parameters: array of String);
    procedure checkDataButtonClick(Sender: TObject);
    procedure cleanClipBoardTimerTimer(Sender: TObject);
    procedure copyFirstEditSpeedButtonClick(Sender: TObject);
    procedure copySecondEditSpeedButtonClick(Sender: TObject);
    procedure eyeSecondEditSpeedButtonClick(Sender: TObject);
    procedure fileCloseButtonClick(Sender: TObject);
    procedure fileMainButtonClick(Sender: TObject);
    procedure fileNewButtonClick(Sender: TObject);
    procedure fileOpenButtonClick(Sender: TObject);
    procedure firstDataEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure getDataButtonClick(Sender: TObject);
    procedure managerAddButtonClick(Sender: TObject);
    procedure managerChangeButtonClick(Sender: TObject);
    procedure managerDeleteButtonClick(Sender: TObject);
    procedure secondDataEditChange(Sender: TObject);
    procedure selectStringNumberSpinEditChange(Sender: TObject);
    procedure showMainPMenuItemClick(Sender: TObject);
    procedure startAppTimerTimer(Sender: TObject);
    procedure viewFileContentListBoxClick(Sender: TObject);
    procedure viewPassTimerTimer(Sender: TObject);
    procedure windowCloseImageMouseEnter(Sender: TObject);
    procedure windowCloseImageMouseLeave(Sender: TObject);
    procedure windowHeaderImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure windowHeaderImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure windowHeaderImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure windowMinimizeImageClick(Sender: TObject);
    procedure windowMinimizeImageMouseEnter(Sender: TObject);
    procedure windowMinimizeImageMouseLeave(Sender: TObject);
  private
    mouseIsDown : Boolean; // Состояние удержания ЛКМ
    mPosX, mPosY : Integer; // Позиция курсора
  public
    { public declarations }
  end;

const
  stringSplitter = '&&&&';

var
  mainForm: TmainForm;
  fileNameStr, folderNameStr, siteFileNameStr, appPhase: String;
  selectedSt : Integer;

implementation

uses
  questionsUnit, editingUnit, functionsUnit, appSettingsUnit;

{$R *.lfm}

{ TmainForm }

{ Процедура создания формы }
procedure TmainForm.FormCreate(Sender: TObject);
begin
  functionsUnit.loadAppSettings();
  windowCloseImage.Picture := windowCloseFalseImage.Picture; // Кнопке закрытия даем изображение неактивной кнопки закрытия
  windowMinimizeImage.Picture := windowMinimizeFalseImage.Picture; // Кнопке сворачивания даем изображение неактивной кнопки сворачивания
  startAppTimer.Enabled := True; // Активируем таймер старта приложения
end;

{ Процедура таймера старта приложения }
procedure TmainForm.startAppTimerTimer(Sender: TObject);
begin
  startAppTimer.Enabled := False; // Дективируем таймер старта приложения
  appTrayIcon.Visible := True;
  fileGroupBox.Visible := True; // Показываем группу "Файл"
  appGroupBox.Visible := True; // Показываем группу "Приложение"
  managerGroupBox.Visible := True; // Показываем группу "Менеджер текущей базы"
  viewFileGroupBox.Visible := True; // Показываем группу "Просмотр"
  viewContentGroupBox.Visible := True; // Показываем группу "Получение логинов"
  appPhase := 'AppLoaded'; // Стадия приложения - Приложение загружено
end;

procedure TmainForm.viewFileContentListBoxClick(Sender: TObject);
begin
  selectStringNumberSpinEdit.Value := viewFileContentListBox.ItemIndex + 1;
end;

procedure TmainForm.viewPassTimerTimer(Sender: TObject);
begin
  viewPassTimer.Enabled := False;
  vsecondDataEdit.Visible := False;
  eyeSecondEditSpeedButton.Enabled := True;
end;

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TmainForm.windowHeaderImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TmainForm.windowHeaderImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    mainForm.Left := mainForm.Left - mPosX + X; // Сдвиг формы по X
    mainForm.Top := mainForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TmainForm.windowHeaderImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TmainForm.windowMinimizeImageClick(Sender: TObject);
begin
  if not appSettingsUnit.lminimizeToTray then
    Application.Minimize
  else begin
    mainForm.Hide;
    appTrayIcon.Visible := True;
  end;
end;

procedure TmainForm.windowMinimizeImageMouseEnter(Sender: TObject);
begin
  windowMinimizeImage.Picture := windowMinimizeTrueImage.Picture; // Кнопке сворачивания даем изображение активной кнопки сворачивания
end;

procedure TmainForm.windowMinimizeImageMouseLeave(Sender: TObject);
begin
  windowMinimizeImage.Picture := windowMinimizeFalseImage.Picture; // Кнопке сворачивания даем изображение неактивной кнопки сворачивания
end;

{ Процедура наведения курсора на кнопку закрытия формы }
procedure TmainForm.windowCloseImageMouseEnter(Sender: TObject);
begin
  windowCloseImage.Picture := windowCloseTrueImage.Picture; // Кнопке закрытия даем изображение активной кнопки закрытия
end;

{ Процедура отведения курсора с кнопки закрытия формы }
procedure TmainForm.windowCloseImageMouseLeave(Sender: TObject);
begin
  windowCloseImage.Picture := windowCloseFalseImage.Picture; // Кнопке закрытия даем изображение неактивной кнопки закрытия
end;

{ Процедура нажатия на кнопку "Открыть файл..." }
procedure TmainForm.fileOpenButtonClick(Sender: TObject);
var
  tempFileNameStr, tempFolderNameStr: String;
  dialogResult: TModalResult;
begin
  fileOpenDialog.Title := 'Открыть существующий файл'; // Заголовок диалога открытия файла
  if fileOpenDialog.Execute then begin
    tempFileNameStr := fileOpenDialog.FileName; // Путь к открытому файлу
    tempFolderNameStr := StringReplace(tempFileNameStr,ExtractFileExt(tempFileNameStr),'',[]) + '_ps\';  // Путь к папке базы
    if not DirectoryExists(UTF8ToSys(tempFolderNameStr)) then begin
      questionsForm.windowHeaderLabel.Caption := 'Папка не найдена. Создать?'; // Заголовок окна предупреждений
      with questionsForm.descriptionMemo.Lines do begin
        Add('Для работы с файлом ' + ExtractFileName(tempFileNameStr) + ' .');
        Add('Приложению необходима папка ' + StringReplace(ExtractFileName(tempFileNameStr),ExtractFileExt(tempFileNameStr),'',[]) + '_ps .');
        Add('Данная папка не обнаружена приложением.'#13'Создать папку ' + StringReplace(ExtractFileName(tempFileNameStr),ExtractFileExt(tempFileNameStr),'',[]) + '_ps ?');
      end;
      with questionsForm.firstBitBtn do begin
        Visible := True;
        Kind := bkYes;
        Caption := 'Да';
      end;
      with questionsForm.secondBitBtn do begin
        Visible := True;
        Kind := bkNo;
        Caption := 'Нет';
      end;
      with questionsForm.thirdBitBtn do begin
        Visible := True;
        Kind := bkCancel;
        Caption := 'Отмена';
      end;
      dialogResult := questionsForm.ShowModal;
      case dialogResult of
           mrYes: begin
             fileCloseButton.Click; // Закрываем старый файл
             fileNameStr := tempFileNameStr;
             folderNameStr := tempFolderNameStr;
             ForceDirectories(UTF8ToSys(folderNameStr));
             functionsUnit.cleaningFile(fileNameStr); // Очищаем файл
             functionsUnit.openingFile(fileNameStr); // Открываем файл
             functionsUnit.createUEFiles(folderNameStr); //Создание отсутствующих файлов
             appPhase := 'FileLoaded'; // Стадия приложения - Файл загружен
           end;
           mrNo: begin
             fileCloseButton.Click; // Закрываем старый файл
             fileNameStr := tempFileNameStr;
             folderNameStr := tempFolderNameStr;
             questionsForm.windowHeaderLabel.Caption := 'Ограниченный режим'; // Заголовок окна предупреждений
             questionsForm.descriptionMemo.Lines.Add('Папка для данного файла не была создана.'); // Текст предупреждения
             questionsForm.descriptionMemo.Lines.Add('Файл будет открыт, но с некоторыми ограничениями.'); // Текст предупреждения
             with questionsForm.firstBitBtn do begin
               Visible := False;
             end;
             with questionsForm.secondBitBtn do begin
               Visible := False;
             end;
             with questionsForm.thirdBitBtn do begin
               Visible := True;
               Kind := bkOK;
             end;
             questionsForm.ShowModal;  // Показываем окно предупреждения
             functionsUnit.cleaningFile(fileNameStr); // Очищаем файл
             viewFileContentListBox.Items.LoadFromFile(UTF8ToSys(fileNameStr)); // Загружаем строки из файла
           end;
      end;
    end else begin
      fileCloseButton.Click; // Закрываем старый файл
      fileNameStr := tempFileNameStr;
      folderNameStr := tempFolderNameStr;
      functionsUnit.cleaningFile(fileNameStr); // Очищаем файл
      functionsUnit.openingFile(fileNameStr); // Открываем файл
      functionsUnit.createUEFiles(folderNameStr); //Создание отсутствующих файлов
      appPhase := 'FileLoaded'; // Стадия приложения - Файл загружен
    end;
  end;
end;

{ Процедура нажатия на кнопку "Выход из приложения" }
procedure TmainForm.appCloseButtonClick(Sender: TObject);
var
  dialogResult: TModalResult;
begin
  questionsForm.descriptionMemo.Clear; // Очищаем описание предупреждения
  questionsForm.windowHeaderLabel.Caption := 'Выйти?'; // Заголовок окна предупреждений
  questionsForm.descriptionMemo.Lines.Add('Вы действительно хотите выйти из приложения'); // Текст предупреждения
  with questionsForm.firstBitBtn do begin
    Visible := False;
  end;
  with questionsForm.secondBitBtn do begin
    Visible := True;
    Kind := bkYes;
    Caption := 'Да';
  end;
  with questionsForm.thirdBitBtn do begin
    Visible := True;
    Kind := bkNo;
    Caption := 'Нет';
  end;
  dialogResult := questionsForm.ShowModal; // Показываем окно предупреждения
  if dialogResult = mrYes then mainForm.Close; // Закрываем приложение
end;

procedure TmainForm.appSettingsButtonClick(Sender: TObject);
begin
  appSettingsForm.ShowModal;
end;

procedure TmainForm.appTrayIconClick(Sender: TObject);
begin
  mainForm.WindowState := wsNormal;
  mainForm.Show;
end;

procedure TmainForm.AppUniqueInstanceOtherInstance(Sender: TObject;
  ParamCount: Integer; Parameters: array of String);
begin
  mainForm.Show;
end;

procedure TmainForm.checkDataButtonClick(Sender: TObject);
begin
  case appPhase of
    'LoginLoaded' : begin
      firstDataEdit.Text := viewFileContentListBox.Items[selectStringNumberSpinEdit.Value - 1]; // В поле "Сайт" находится название сайта
      getDataButton.Enabled := True; // Активируем кнопку "Получить"
      checkDataButton.Enabled := False;
      selectStringNumberSpinEdit.Enabled := False;
      copySecondEditSpeedButton.Enabled := False;
      eyeSecondEditSpeedButton.Enabled := False;
      secondDataEdit.Clear;
    end;
    'FileLoaded' : begin
      firstDataEdit.Text := viewFileContentListBox.Items[selectStringNumberSpinEdit.Value - 1]; // В поле "Сайт" находится название сайта
      getDataButton.Enabled := True; // Активируем кнопку "Получить"
    end;
  end;
  if viewPassTimer.Enabled then begin
    viewPassTimer.Enabled := False;
    vsecondDataEdit.Visible := False;
  end;
  copyFirstEditSpeedButton.Enabled := True;
end;

procedure TmainForm.cleanClipBoardTimerTimer(Sender: TObject);
begin
  cleanClipBoardTimer.Enabled := False;
  Clipboard.AsText := '';
  Clipboard.Clear;
end;

procedure TmainForm.copyFirstEditSpeedButtonClick(Sender: TObject);
begin
  Clipboard.AsText := firstDataEdit.Text;
end;

procedure TmainForm.copySecondEditSpeedButtonClick(Sender: TObject);
begin
  Clipboard.AsText := secondDataEdit.Text;
  cleanClipBoardTimer.Enabled := True;
end;

procedure TmainForm.eyeSecondEditSpeedButtonClick(Sender: TObject);
begin
  vsecondDataEdit.Text := secondDataEdit.Text;
  viewPassTimer.Enabled := False;
  vsecondDataEdit.Visible := True;
  viewPassTimer.Enabled := True;
  eyeSecondEditSpeedButton.Enabled := False;
end;

procedure TmainForm.fileCloseButtonClick(Sender: TObject);
begin
  functionsUnit.guiToAppLoadPhase();
  viewFileContentListBox.Clear; // Очищаем главное Memo
  fileNameStr := ''; // Стираем путь к файлу базы
  folderNameStr := ''; // Стираем путь к папке базы
  fileMainButton.Enabled := False; // Отключаем кнопку "На главную"
  fileCloseButton.Enabled := False; // Отключаем кнопку "X"
  managerGroupBox.Enabled := False; // Отключаем панель "Менеджер текущей базы"
  viewFileGroupBox.Enabled := False; // Отключаем панель "Просмотр"
  viewContentGroupBox.Enabled := False; // Отключаем панель "Выбор сайта"
  appPhase := 'AppLoaded'; // Стадия приложения - Приложение загружено
end;

procedure TmainForm.fileMainButtonClick(Sender: TObject);
begin
  functionsUnit.guiToAppLoadPhase();
  functionsUnit.cleaningFile(fileNameStr); // Очищаем файл
  functionsUnit.openingFile(fileNameStr); // Открываем файл
  functionsUnit.createUEFiles(folderNameStr); //Создание отсутствующих файлов
  appPhase := 'FileLoaded'; // Стадия приложения - Файл загружен
end;

procedure TmainForm.fileNewButtonClick(Sender: TObject);
var
  dialogResult: TModalResult;
begin
  fileSaveDialog.Title := 'Создать новый файл'; // Заголовок диалога открытия файла
  if fileSaveDialog.Execute then begin
    if not FileExists(UTF8ToSys(fileSaveDialog.FileName)) then begin
      fileCloseButton.Click; // Закрываем старый файл
      fileNameStr := fileSaveDialog.FileName; // Путь к открытому файлу
      folderNameStr := StringReplace(fileNameStr,ExtractFileExt(fileNameStr),'',[]) + '_ps\';  // Путь к папке базы
      with TStringList.Create do
      try
        SaveToFile(UTF8ToSys(fileNameStr));
      finally
        Free;
      end;
      ForceDirectories(UTF8ToSys(folderNameStr));
      functionsUnit.openingFile(fileNameStr);
      appPhase := 'FileLoaded'; // Стадия приложения - Файл загружен
    end else begin
      questionsForm.windowHeaderLabel.Caption := 'Файл существует. Перезаписать?'; // Заголовок окна предупреждений
      with questionsForm.descriptionMemo.Lines do begin
        Add('Файл ' + ExtractFileName(fileSaveDialog.FileName) + ' существует в данном расположении');
        Add('Перезаписать?');
        with questionsForm.firstBitBtn do begin
          Visible := False;
        end;
        with questionsForm.secondBitBtn do begin
          Visible := True;
          Kind := bkYes;
          Caption := 'Да';
        end;
        with questionsForm.thirdBitBtn do begin
          Visible := True;
          Kind := bkCancel;
          Caption := 'Отмена';
        end;
        dialogResult := questionsForm.ShowModal; // Показываем окно предупреждения
        if dialogResult = mrYes then begin
          fileCloseButton.Click; // Закрываем старый файл
          fileNameStr := fileSaveDialog.FileName; // Путь к открытому файлу
          with TStringList.Create do
          try
            SaveToFile(UTF8ToSys(fileSaveDialog.FileName));
          finally
            Free;
          end;
          functionsUnit.openingFile(fileNameStr);
          appPhase := 'FileLoaded'; // Стадия приложения - Файл загружен
        end;
      end;
    end;
  end;
end;

procedure TmainForm.getDataButtonClick(Sender: TObject);
var
  i, StringIndex: Integer;
  cSite: String;
begin
  case appPhase of
    'LoginLoaded' : begin
      selectedSt := selectStringNumberSpinEdit.Value;
      with TStringList.Create do begin
        LoadFromFile(UTF8ToSys(siteFileNameStr)); // Загружаем строки из файла
        StringIndex := CodeFileStringLoginIndex(firstDataEdit.Text, siteFileNameStr);
        secondDataEdit.Text := UTF8Copy(CodeDecodeUTF8String(Strings[StringIndex], False), UTF8Pos(stringSplitter, CodeDecodeUTF8String(Strings[StringIndex], False)) + 4, UTF8Length(CodeDecodeUTF8String(Strings[StringIndex], False)));
      end;
      copySecondEditSpeedButton.Enabled := True;
      getDataButton.Enabled := False;
      selectStringNumberSpinEdit.Enabled := True;
    end;
    'FileLoaded' : begin
      functionsUnit.cleaningFile(folderNameStr + firstDataEdit.Text + '.dmps');
      cSite := firstDataEdit.Text;
      // Открываем файл с данными сайта
      with TStringList.Create do begin
        siteFileNameStr := folderNameStr + firstDataEdit.Text + '.dmps';
        LoadFromFile(UTF8ToSys(siteFileNameStr)); // Загружаем строки из файла
        selectStringNumberSpinEdit.MaxValue := Count; //  Передаем количество строк компоненту SpinEdit
        if Count = 0 then begin
          checkDataButton.Enabled := False; // Отключаем кнопку "Логин?"
          selectStringNumberSpinEdit.Enabled := False; // Отключаем выбор строки
        end else begin
          checkDataButton.Enabled := True; // Активируем кнопку "Логин?"
          mainForm.selectStringNumberSpinEdit.Enabled := True; // Активируем выбор строки
        end;
        viewFileContentListBox.Clear;
        for i := 0 to Count - 1 do begin
          viewFileContentListBox.Items.Add(UTF8Copy(CodeDecodeUTF8String(Strings[i], False), 1, UTF8Pos(stringSplitter, CodeDecodeUTF8String(Strings[i], False)) - 1));
        end;
      end;
      guiToAppLoadPhase();
      appPhase := 'LoginLoaded'; // Стадия приложения - Логины загружены
      checkDataButton.Caption := 'Логин?'; // Меняем текст кнопки "Логин?"
      getDataButton.Caption := 'Получить пароль'; // Меняем текст кнопки "Получить логины"
      viewContentGroupBox.Caption := 'Выбор логина'; // Меняем текст панели "Выбор сайта"
      firstLabel.Caption := 'Логин'; // Меняем текст надписи "Сайт"
      secondLabel.Visible := True; // Показываем надпись "Пароль"
      secondDataEdit.Visible := True; // Показываем поле "Пароль"
      eyeSecondEditSpeedButton.Visible := True; // Показываем кнопку просмотра пароля
      copySecondEditSpeedButton.Visible := True; // Показываем кнопку копирования пароля
      windowHeaderLabel.Caption := 'MythPassSafe 0.9 - [' + cSite + ']';
    end;
  end;
end;

procedure TmainForm.managerAddButtonClick(Sender: TObject);
begin
  editingForm.windowHeaderLabel.Caption := 'Добавление данных';
  editingForm.loginBitBtn.Caption := 'Добавить логин';
  editingForm.siteBitBtn.Caption := 'Добавить сайт';
  editingForm.ShowModal;
end;

procedure TmainForm.managerChangeButtonClick(Sender: TObject);
begin
  editingForm.windowHeaderLabel.Caption := 'Изменение данных';
  editingForm.loginBitBtn.Caption := 'Изменить логин';
  editingForm.siteBitBtn.Caption := 'Изменить сайт';
  editingForm.ShowModal;
end;

procedure TmainForm.managerDeleteButtonClick(Sender: TObject);
begin
  editingForm.windowHeaderLabel.Caption := 'Удаление данных';
  editingForm.loginBitBtn.Caption := 'Удалить логин';
  editingForm.siteBitBtn.Caption := 'Удалить сайт';
  editingForm.ShowModal;
end;

procedure TmainForm.firstDataEditChange(Sender: TObject);
begin
  if not (firstDataEdit.Text = '') then
    copyFirstEditSpeedButton.Enabled:= True
  else
    copyFirstEditSpeedButton.Enabled:= False;
end;

procedure TmainForm.secondDataEditChange(Sender: TObject);
begin
  if not (secondDataEdit.Text = '') then begin
    copySecondEditSpeedButton.Enabled:= True;
    eyeSecondEditSpeedButton.Enabled:= True;
  end else begin
    copySecondEditSpeedButton.Enabled:= False;
    eyeSecondEditSpeedButton.Enabled:= False;
  end;
end;

procedure TmainForm.selectStringNumberSpinEditChange(Sender: TObject);
begin
  if selectStringNumberSpinEdit.Value <> selectedSt then
     checkDataButton.Enabled := True;
end;

procedure TmainForm.showMainPMenuItemClick(Sender: TObject);
begin
  if not appSettingsUnit.lminimizeToTray then
    mainForm.WindowState := wsNormal
  else
    mainForm.Show;
end;

end.


