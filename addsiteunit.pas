unit addSiteUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, LazUtf8;

type

  { TaddSiteForm }

  TaddSiteForm = class(TForm)
    OKBitBtn: TBitBtn;
    cancelBitBtn: TBitBtn;
    siteNameLabeledEdit: TLabeledEdit;
    windowBackgroundImage: TImage;
    windowBorderBottomShape: TShape;
    windowBorderLeftShape: TShape;
    windowBorderRightShape: TShape;
    windowHeaderImage: TImage;
    windowHeaderLabel: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure OKBitBtnClick(Sender: TObject);
    procedure siteNameLabeledEditChange(Sender: TObject);
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
  addSiteForm: TaddSiteForm;

implementation

uses
  mainUnit, questionsUnit;

{$R *.lfm}

{ TaddSiteForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TaddSiteForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TaddSiteForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    addSiteForm.Left := addSiteForm.Left - mPosX + X; // Сдвиг формы по X
    addSiteForm.Top := addSiteForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TaddSiteForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TaddSiteForm.OKBitBtnClick(Sender: TObject);
begin
  with TStringList.Create do
  try
    LoadFromFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
    if IndexOf(siteNameLabeledEdit.Text) = -1 then begin
      Add(siteNameLabeledEdit.Text);
      SaveToFile(LazUtf8.UTF8ToSys(mainUnit.fileNameStr));
    end else begin
      questionsForm.windowHeaderLabel.Caption := 'Сайт существует'; // Заголовок окна предупреждений
      questionsForm.descriptionMemo.Lines.Add('Данный сайт уже существует.'); // Текст предупреждения
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
    end;
  finally
    Free;
  end;
  mainForm.fileMainButton.Click;
end;

procedure TaddSiteForm.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  siteNameLabeledEdit.Clear;
end;

procedure TaddSiteForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

procedure TaddSiteForm.siteNameLabeledEditChange(Sender: TObject);
begin
  if siteNameLabeledEdit.Text > '' then
    OKBitBtn.Enabled := True
  else
    OKBitBtn.Enabled := False;
end;

end.

