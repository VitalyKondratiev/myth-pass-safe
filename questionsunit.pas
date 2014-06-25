unit questionsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, mainUnit;

type

  { TquestionsForm }

  TquestionsForm = class(TForm)
    Shape1: TShape;
    thirdBitBtn: TBitBtn;
    secondBitBtn: TBitBtn;
    firstBitBtn: TBitBtn;
    descriptionMemo: TMemo;
    windowBackgroundImage: TImage;
    windowBorderBottomShape: TShape;
    windowBorderLeftShape: TShape;
    windowBorderRightShape: TShape;
    windowHeaderImage: TImage;
    windowHeaderLabel: TLabel;
    windowManageButtonsBackgroundImage: TImage;
    procedure firstBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure secondBitBtnClick(Sender: TObject);
    procedure thirdBitBtnClick(Sender: TObject);
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
  questionsForm: TquestionsForm;

implementation

{$R *.lfm}

{ TquestionsForm }

{ Процедура нажатия кнопки мыши на заголовок формы }
procedure TquestionsForm.windowHeaderImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
     mouseIsDown := True; // Левая кнопка мыши удерживается
  mPosX := X; // Запоминаем позицию курсора по X
  mPosY := Y; // Запоминаем позицию курсора по Y
end;

{ Процедура передвижения курсора на заголовке формы }
procedure TquestionsForm.windowHeaderImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if mouseIsDown then begin
    questionsForm.Left := questionsForm.Left - mPosX + X; // Сдвиг формы по X
    questionsForm.Top := questionsForm.Top - mPosY + Y; // Сдвиг формы по Y
  end;
end;

{ Процедура отпускания кнопки мыши на заголовке формы }
procedure TquestionsForm.windowHeaderImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseIsDown := False; // Левая кнопка мыши не удерживается
end;


procedure TquestionsForm.firstBitBtnClick(Sender: TObject);
begin
  descriptionMemo.Clear; // Очищаем описание предупреждения
end;

procedure TquestionsForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  mainForm.exitPMenuItem.Enabled := True;
end;

procedure TquestionsForm.FormShow(Sender: TObject);
begin
  mainForm.exitPMenuItem.Enabled := False;
end;

procedure TquestionsForm.secondBitBtnClick(Sender: TObject);
begin
  descriptionMemo.Clear; // Очищаем описание предупреждения
end;

procedure TquestionsForm.thirdBitBtnClick(Sender: TObject);
begin
  descriptionMemo.Clear; // Очищаем описание предупреждения
end;

end.

