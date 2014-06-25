unit deleteSiteUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, LazUtf8;

type

  { TdeleteSiteForm }

  TdeleteSiteForm = class(TForm)
    cancelBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    siteNameLabel: TLabel;
    siteNameComboBox: TComboBox;
    windowBackgroundImage: TImage;
    windowBorderBottomShape: TShape;
    windowBorderLeftShape: TShape;
    windowBorderRightShape: TShape;
    windowHeaderImage: TImage;
    windowHeaderLabel: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
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
  deleteSiteForm: TdeleteSiteForm;

implementation

uses
  mainUnit, questionsUnit;

{$R *.lfm}

{ TdeleteSiteForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TdeleteSiteForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TdeleteSiteForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    deleteSiteForm.Left := deleteSiteForm.Left - mPosX + X; // Сдвиг формы по X
    deleteSiteForm.Top := deleteSiteForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TdeleteSiteForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TdeleteSiteForm.OKBitBtnClick(Sender: TObject);
var
  dialogResult: TModalResult;
begin
  questionsForm.windowHeaderLabel.Caption := 'Удалить?'; // Заголовок окна предупреждений
  questionsForm.descriptionMemo.Lines.Add('Удалить сайт ' + siteNameComboBox.Items[siteNameComboBox.ItemIndex] + ' из базы?'); // Текст предупреждения
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
  if dialogResult = mrYes then begin
    with TStringList.Create do
    try
      LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
      Delete(IndexOf(siteNameComboBox.Text));
      SaveToFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
    finally
      Free;
    end;
    DeleteFile(LazUtf8.UTF8ToSys(mainUnit.folderNameStr + siteNameComboBox.Text + '.dmps'));
  end;
  mainForm.fileMainButton.Click;
end;

procedure TdeleteSiteForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  siteNameComboBox.ItemIndex := - 1;
end;

procedure TdeleteSiteForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

procedure TdeleteSiteForm.siteNameComboBoxChange(Sender: TObject);
begin
  if  siteNameComboBox.Text > '' then
    OKBitBtn.Enabled := True
  else
    OKBitBtn.Enabled := False;
end;

end.

