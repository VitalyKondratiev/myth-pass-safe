unit deleteLoginUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls,
  ExtCtrls, Buttons, LazUTF8;

type

  { TdeleteLoginForm }

  TdeleteLoginForm = class(TForm)
    cancelBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    siteNameComboBox: TComboBox;
    loginComboBox: TComboBox;
    siteNameLabel: TLabel;
    loginLabel: TLabel;
    windowBackgroundImage: TImage;
    windowBorderBottomShape: TShape;
    windowBorderLeftShape: TShape;
    windowBorderRightShape: TShape;
    windowHeaderImage: TImage;
    windowHeaderLabel: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure loginComboBoxChange(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure siteNameComboBoxChange(Sender: TObject);
    procedure windowHeaderImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure windowHeaderImageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure windowHeaderImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    mouseIsDown : Boolean; // Состояние удержания ЛКМ
    mPosX, mPosY : Integer; // Позиция курсора
  public
    { public declarations }
  end;

var
  deleteLoginForm: TdeleteLoginForm;

implementation

uses
  mainUnit, functionsUnit, questionsUnit;

{$R *.lfm}

{ TdeleteLoginForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TdeleteLoginForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TdeleteLoginForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    deleteLoginForm.Left := deleteLoginForm.Left - mPosX + X; // Сдвиг формы по X
    deleteLoginForm.Top := deleteLoginForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TdeleteLoginForm.windowHeaderImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;


procedure TdeleteLoginForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

procedure TdeleteLoginForm.loginComboBoxChange(Sender: TObject);
begin
  if  (siteNameComboBox.Text > '') and (loginComboBox.Text > '') then
    OKBitBtn.Enabled := True
  else
    OKBitBtn.Enabled := False;
end;

procedure TdeleteLoginForm.OKBitBtnClick(Sender: TObject);
var
  dialogResult: TModalResult;
  DeleteIndex: Integer;
begin
  DeleteIndex := 0;
  with TStringList.Create do
    try
      LoadFromFile(UTF8ToSys(mainUnit.folderNameStr + siteNameComboBox.Text + '.dmps'));
      DeleteIndex := CodeFileStringLoginIndex(loginComboBox.Text, mainUnit.folderNameStr + siteNameComboBox.Text + '.dmps');
      Delete(DeleteIndex);
      questionsForm.windowHeaderLabel.Caption := 'Удалить?'; // Заголовок окна предупреждений
      questionsForm.descriptionMemo.Lines.Add('Удалить логин ' + loginComboBox.Text + ' из базы?'); // Текст предупреждения
      questionsForm.descriptionMemo.Lines.Add('Отмена этого действия невозможна'); // Текст предупреждения
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
      dialogResult := questionsForm.ShowModal;
      if dialogResult = mrYes then
        SaveToFile(UTF8ToSys(mainUnit.folderNameStr + siteNameComboBox.Text +  '.dmps'));
    finally
      Free;
    end;
    mainForm.fileMainButton.Click;
end;

procedure TdeleteLoginForm.siteNameComboBoxChange(Sender: TObject);
var
  i: Integer;
begin
  with TStringList.Create do begin
    LoadFromFile(UTF8ToSys(mainUnit.folderNameStr + siteNameComboBox.Text +  '.dmps'));
    if Count = 0 then begin
      loginComboBox.Enabled := False;
      OKBitBtn.Enabled := False;
    end else begin
      loginComboBox.Enabled := True;
    end;
    loginComboBox.Clear;
    for i := 0 to Count - 1 do begin
      loginComboBox.Items.Add(UTF8Copy(CodeDecodeUTF8String(Strings[i], False), 1, UTF8Pos(stringSplitter, CodeDecodeUTF8String(Strings[i], False)) - 1));
    end;
  end;
end;

procedure TdeleteLoginForm.FormClose(Sender: TObject;var CloseAction: TCloseAction);
begin
  siteNameComboBox.ItemIndex := - 1;
  loginComboBox.ItemIndex := - 1;
  loginComboBox.Enabled := False;
end;

end.

