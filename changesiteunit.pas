unit changeSiteUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, LazUtf8;

type

  { TchangeSiteForm }

  TchangeSiteForm = class(TForm)
    cancelBitBtn: TBitBtn;
    OKBitBtn: TBitBtn;
    siteNameComboBox: TComboBox;
    siteNameLabel: TLabel;
    newSiteNameLabeledEdit: TLabeledEdit;
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
  changeSiteForm: TchangeSiteForm;

implementation

uses
  mainUnit, questionsUnit;

{$R *.lfm}

{ TchangeSiteForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TchangeSiteForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TchangeSiteForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    changeSiteForm.Left := changeSiteForm.Left - mPosX + X; // Сдвиг формы по X
    changeSiteForm.Top := changeSiteForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TchangeSiteForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TchangeSiteForm.siteNameComboBoxChange(Sender: TObject);
begin
  if  (siteNameComboBox.Text > '') and (newSiteNameLabeledEdit.Text > '') then
    OKBitBtn.Enabled := True
  else
    OKBitBtn.Enabled := False;
end;

procedure TchangeSiteForm.OKBitBtnClick(Sender: TObject);
var
  dialogResult: TModalResult;
begin
  questionsForm.windowHeaderLabel.Caption := 'Изменить?'; // Заголовок окна предупреждений
  questionsForm.descriptionMemo.Lines.Add('Изменить сайт из базы: ' + siteNameComboBox.Items[siteNameComboBox.ItemIndex] + '?'); // Текст предупреждения
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
      Strings[IndexOf(siteNameComboBox.Text)] := newSiteNameLabeledEdit.Text;
      SaveToFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
    finally
      Free;
    end;
    RenameFile(LazUtf8.UTF8ToSys(mainUnit.folderNameStr + siteNameComboBox.Text + '.dmps'),UTF8ToSys(mainUnit.folderNameStr + newSiteNameLabeledEdit.Text + '.dmps'));
  end;
  mainForm.fileMainButton.Click;
end;

procedure TchangeSiteForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  newSiteNameLabeledEdit.Clear;
  siteNameComboBox.ItemIndex := - 1;
  siteNameComboBox.Text := 'Выберите сайт...';
end;

procedure TchangeSiteForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

end.

