unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Strutils;

const
  DISABLED_TRIGGER_TEXT = '<disabled>';

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnTrigger1: TButton;
    BtnTrigger10: TButton;
    BtnTrigger2: TButton;
    BtnTrigger3: TButton;
    BtnTrigger4: TButton;
    BtnTrigger5: TButton;
    BtnTrigger6: TButton;
    BtnTrigger7: TButton;
    BtnTrigger8: TButton;
    BtnTrigger9: TButton;
    GrpTrigger10: TGroupBox;
    GrpTrigger2: TGroupBox;
    GrpTrigger3: TGroupBox;
    GrpTrigger4: TGroupBox;
    GrpTrigger5: TGroupBox;
    GrpTrigger6: TGroupBox;
    GrpTrigger7: TGroupBox;
    GrpTrigger8: TGroupBox;
    GrpTrigger9: TGroupBox;
    TxtTrigger1: TEdit;
    GrpTrigger1: TGroupBox;
    GrpTriggers: TGroupBox;
    Label1: TLabel;
    TxtTrigger10: TEdit;
    TxtTrigger2: TEdit;
    TxtTrigger3: TEdit;
    TxtTrigger4: TEdit;
    TxtTrigger5: TEdit;
    TxtTrigger6: TEdit;
    TxtTrigger7: TEdit;
    TxtTrigger8: TEdit;
    TxtTrigger9: TEdit;
    procedure TxtTrigger1Change(Sender: TObject);
    procedure TxtTrigger2Change(Sender: TObject);
    procedure TxtTrigger3Change(Sender: TObject);
    procedure TxtTrigger4Change(Sender: TObject);
    procedure TxtTrigger5Change(Sender: TObject);
    procedure TxtTrigger6Change(Sender: TObject);
    procedure TxtTrigger7Change(Sender: TObject);
    procedure TxtTrigger8Change(Sender: TObject);
    procedure TxtTrigger9Change(Sender: TObject);
    procedure TxtTrigger10Change(Sender: TObject);
  private

  public

  end;


procedure CheckDisablement(Button: TButton);

var
  Form1: TForm1;

implementation

uses FileSaveServiceUnit;

{$R *.lfm}

{ TForm1 }

procedure CheckDisablement(Button: TButton);
begin
  Button.Enabled := Button.Caption <> DISABLED_TRIGGER_TEXT;
end;

{$INCLUDE 'src/edit_button_trigger_bindings.pp'}


end.

