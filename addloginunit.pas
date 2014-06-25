unit addLoginUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, LazUTF8;

type

  { TaddLoginForm }

  TaddLoginForm = class(TForm)
    cancelBitBtn: TBitBtn;
    dataGroupBox: TGroupBox;
    newLoginLabeledEdit: TLabeledEdit;
    newPasswordLabeledEdit: TLabeledEdit;
    newRePasswordLabeledEdit: TLabeledEdit;
    OKBitBtn: TBitBtn;
    siteNameComboBox: TComboBox;
    siteNameLabel: TLabel;
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
  addLoginForm: TaddLoginForm;

implementation

uses
  mainUnit, questionsUnit, functionsUnit;

{$R *.lfm}

{ TaddLoginForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TaddLoginForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TaddLoginForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    addLoginForm.Left := addLoginForm.Left - mPosX + X; // Сдвиг формы по X
    addLoginForm.Top := addLoginForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TaddLoginForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TaddLoginForm.siteNameComboBoxChange(Sender: TObject);
begin
  if (siteNameComboBox.Text > '') and (newLoginLabeledEdit.Text > '') and (newPasswordLabeledEdit.Text > '') and (newRePasswordLabeledEdit.Text > '') then
    OKBitBtn.Enabled := True
  else
    OKBitBtn.Enabled := False;
  if (siteNameComboBox.Text > '') then
    dataGroupBox.Enabled := True;
end;

procedure TaddLoginForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  siteNameComboBox.ItemIndex := - 1;
  siteNameComboBox.Text := 'Выберите сайт...';
  newLoginLabeledEdit.Clear;
  newPasswordLabeledEdit.Clear;
  newRePasswordLabeledEdit.Clear;
end;

procedure TaddLoginForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

procedure TaddLoginForm.OKBitBtnClick(Sender: TObject);
var
  i: Integer;
  unCodeString: String;
  exist: Boolean;
begin
  if not (newPasswordLabeledEdit.Text = newRePasswordLabeledEdit.Text) then begin
    questionsForm.windowHeaderLabel.Caption := 'Несовпадение паролей'; // Заголовок окна предупреждений
    questionsForm.descriptionMemo.Lines.Add('Неверный повтор пароля.'); // Текст предупреждения
    questionsForm.descriptionMemo.Lines.Add('Повторите попытку ещё раз.'); // Текст предупреждения
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
    questionsForm.ShowModal; // Показываем окно предупреждения
    newPasswordLabeledEdit.Clear;
    newRePasswordLabeledEdit.Clear;
  end else begin
    if length(newPasswordLabeledEdit.Text) < 5 then begin
      questionsForm.windowHeaderLabel.Caption := 'Короткий пароль'; // Заголовок окна предупреждений
      questionsForm.descriptionMemo.Lines.Add('Введенный пароль слишком короток.'); // Текст предупреждения
      questionsForm.descriptionMemo.Lines.Add('Повторите попытку ещё раз.'); // Текст предупреждения
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
      questionsForm.ShowModal; // Показываем окно предупреждения
      newPasswordLabeledEdit.Clear;
      newRePasswordLabeledEdit.Clear;
    end else begin
      exist := false;
      with TStringList.Create do
      try
        LoadFromFile(UTF8ToSys(mainUnit.folderNameStr +  siteNameComboBox.Text + '.dmps'));
        for i := 0 to Count - 1 do begin
          unCodeString := CodeDecodeUTF8String(Strings[i], False);
          if UTF8Pos(newLoginLabeledEdit.Text + mainUnit.stringSplitter, unCodeString) = 1 then exist := true;
        end;
        if not exist then begin
          Add(CodeDecodeUTF8String(newLoginLabeledEdit.Text + mainUnit.stringSplitter + newPasswordLabeledEdit.Text, True));
          SaveToFile(UTF8ToSys(mainUnit.folderNameStr +  siteNameComboBox.Text + '.dmps'));
          addLoginForm.Close;
        end else begin
          questionsForm.windowHeaderLabel.Caption := 'Логин существует'; // Заголовок окна предупреждений
          questionsForm.descriptionMemo.Lines.Add('Данный логин уже существует.'); // Текст предупреждения
          questionsForm.descriptionMemo.Lines.Add('Если вы хотите изменить логин, заменив пароль, то выберите в главном окне Изменить... > Изменить логин'); // Текст предупреждения
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
  end;
end;

end.

