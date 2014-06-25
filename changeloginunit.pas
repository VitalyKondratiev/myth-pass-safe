unit changeLoginUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls,
  ExtCtrls, Buttons, LazUTF8;

type

  { TchangeLoginForm }

  TchangeLoginForm = class(TForm)
    cancelBitBtn: TBitBtn;
    changeLoginCheckBox: TCheckBox;
    changePassCheckBox: TCheckBox;
    dataGroupBox: TGroupBox;
    loginComboBox: TComboBox;
    loginLabel: TLabel;
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
    procedure changeLoginCheckBoxChange(Sender: TObject);
    procedure changePassCheckBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure loginComboBoxChange(Sender: TObject);
    procedure newLoginLabeledEditChange(Sender: TObject);
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
  changeLoginForm: TchangeLoginForm;

implementation

uses
  mainUnit, questionsUnit, functionsUnit;

{$R *.lfm}

{ TchangeLoginForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TchangeLoginForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TchangeLoginForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    changeLoginForm.Left := changeLoginForm.Left - mPosX + X; // Сдвиг формы по X
    changeLoginForm.Top := changeLoginForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TchangeLoginForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;

procedure TchangeLoginForm.siteNameComboBoxChange(Sender: TObject);
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
    changeLoginCheckBox.State := cbUnchecked;
    changePassCheckBox.State := cbUnchecked;
    dataGroupBox.Enabled := False;
    newLoginLabeledEdit.Clear;
    newPasswordLabeledEdit.Clear;
    newRePasswordLabeledEdit.Clear;
    for i := 0 to Count - 1 do begin
      loginComboBox.Items.Add(UTF8Copy(CodeDecodeUTF8String(Strings[i], False), 1, UTF8Pos(stringSplitter, CodeDecodeUTF8String(Strings[i], False)) - 1));
    end;
  end;
end;

procedure TchangeLoginForm.loginComboBoxChange(Sender: TObject);
begin
  if  (siteNameComboBox.Text > '') and (loginComboBox.Text > '') then
    dataGroupBox.Enabled := True
  else
    dataGroupBox.Enabled := False;
end;

procedure TchangeLoginForm.newLoginLabeledEditChange(Sender: TObject);
begin
  if (changeLoginCheckBox.State = cbChecked) then begin
    if (newLoginLabeledEdit.Text = '') then
      OKBitBtn.Enabled := False
    else
      OKBitBtn.Enabled := True;
  end;
  if (changePassCheckBox.State = cbChecked) then begin
    if (newPasswordLabeledEdit.Text = '') or (newRePasswordLabeledEdit.Text = '') then
      OKBitBtn.Enabled := False
    else
      OKBitBtn.Enabled := True;
  end;
  if (changeLoginCheckBox.State = cbChecked) and (changePassCheckBox.State = cbChecked) then begin
    if (newLoginLabeledEdit.Text = '') or (newPasswordLabeledEdit.Text = '') or (newRePasswordLabeledEdit.Text = '') then
      OKBitBtn.Enabled := False
    else
      OKBitBtn.Enabled := True;
  end;
end;


{ TODO 3 -oMythbuster47 -cИзменение_логина : Сделать смену данных для логина }
procedure TchangeLoginForm.OKBitBtnClick(Sender: TObject);
var
  dialogResult: TModalResult;
  i, DeleteIndex: Integer;
  unCodeString, oldString: String;
  exist, dchanged: Boolean;
begin
  DeleteIndex := 0;
  dchanged := False;
  exist := False;
  with TStringList.Create do
  try
    LoadFromFile(UTF8ToSys(mainUnit.folderNameStr +  siteNameComboBox.Text + '.dmps'));
    DeleteIndex := CodeFileStringLoginIndex(loginComboBox.Text, mainUnit.folderNameStr + siteNameComboBox.Text + '.dmps');
    if (changeLoginCheckBox.State = cbChecked) and not (changePassCheckBox.State = cbChecked) then begin
      oldString := Strings[DeleteIndex];
      exist := false;
      for i := 0 to Count - 1 do begin
        unCodeString := CodeDecodeUTF8String(Strings[i], False);
        if UTF8Pos(newLoginLabeledEdit.Text + mainUnit.stringSplitter, unCodeString) = 1 then exist := true;
      end;
      if not exist then begin
        Delete(DeleteIndex);
        Add(CodeDecodeUTF8String(newLoginLabeledEdit.Text + mainUnit.stringSplitter + UTF8Copy(CodeDecodeUTF8String(oldString, False), UTF8Pos(stringSplitter, CodeDecodeUTF8String(oldString, False)) + 4, UTF8Length(CodeDecodeUTF8String(oldString, False))), True));
        dchanged := True;
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
    end;
    if (changePassCheckBox.State = cbChecked) and not (changeLoginCheckBox.State = cbChecked) then begin
      Delete(DeleteIndex);
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
          Add(CodeDecodeUTF8String(loginComboBox.Text + mainUnit.stringSplitter + newPasswordLabeledEdit.Text, True));
          dchanged := True;
        end;
      end;
    end;
    if (changeLoginCheckBox.State = cbChecked) and (changePassCheckBox.State = cbChecked) then begin
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
          for i := 0 to Count - 1 do begin
            unCodeString := CodeDecodeUTF8String(Strings[i], False);
            if UTF8Pos(newLoginLabeledEdit.Text + mainUnit.stringSplitter, unCodeString) = 1 then exist := true;
          end;
          if not exist then begin
            DeleteIndex := CodeFileStringLoginIndex(loginComboBox.Text, mainUnit.folderNameStr + siteNameComboBox.Text + '.dmps');
            Delete(DeleteIndex);
            Add(CodeDecodeUTF8String(newLoginLabeledEdit.Text + mainUnit.stringSplitter + newPasswordLabeledEdit.Text, True));
            dchanged := True;
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
        end;
      end;
    end;
    if dchanged then begin
      questionsForm.windowHeaderLabel.Caption := 'Изменить?'; // Заголовок окна предупреждений
      questionsForm.descriptionMemo.Lines.Add('Изменить логин из базы: ' + loginComboBox.Items[loginComboBox.ItemIndex] + '?'); // Текст предупреждения
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
        SaveToFile(UTF8ToSys(mainUnit.folderNameStr +  siteNameComboBox.Text + '.dmps'));
        changeLoginForm.Close;
        mainForm.fileMainButton.Click;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TchangeLoginForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  loginComboBox.Clear;
  changeLoginCheckBox.State := cbUnchecked;
  changePassCheckBox.State := cbUnchecked;
  dataGroupBox.Enabled := False;
  newLoginLabeledEdit.Clear;
  newPasswordLabeledEdit.Clear;
  newRePasswordLabeledEdit.Clear;
end;

procedure TchangeLoginForm.changeLoginCheckBoxChange(Sender: TObject);
begin
  if changeLoginCheckBox.State = cbChecked then
    newLoginLabeledEdit.Enabled := True
  else
    newLoginLabeledEdit.Enabled := False;
  newLoginLabeledEdit.Clear;
  newPasswordLabeledEdit.Clear;
  newRePasswordLabeledEdit.Clear;
end;

procedure TchangeLoginForm.changePassCheckBoxChange(Sender: TObject);
begin
  if changePassCheckBox.State = cbChecked then begin
    newPasswordLabeledEdit.Enabled := True;
    newRePasswordLabeledEdit.Enabled := True;
  end else begin
    newPasswordLabeledEdit.Enabled := False;
    newRePasswordLabeledEdit.Enabled := False;
  end;
  newLoginLabeledEdit.Clear;
  newPasswordLabeledEdit.Clear;
  newRePasswordLabeledEdit.Clear;
end;

procedure TchangeLoginForm.FormCreate(Sender: TObject);
begin
  cancelBitBtn.Caption := 'Отмена';
end;

end.

