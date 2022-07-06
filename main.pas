unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFrmMain }

  TFrmMain = class(TForm)
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
    BtnSetPause: TButton;
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
    procedure OnTriggerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

var
  FrmMain: TFrmMain;

implementation

uses
  TriggerHandlerService, WorkloggerService;
{$R *.lfm}

{ TFrmMain }

procedure TFrmMain.FormShow(Sender: TObject);
var
  Triggers: TIssueTriggers;
begin
  CreateDir(WORKLOGS_FOLDER);
  Triggers[1] := TIssueTrigger.Create(TxtTrigger1, BtnTrigger1, GrpTrigger1);
  Triggers[2] := TIssueTrigger.Create(TxtTrigger2, BtnTrigger2, GrpTrigger2);
  Triggers[3] := TIssueTrigger.Create(TxtTrigger3, BtnTrigger3, GrpTrigger3);
  Triggers[4] := TIssueTrigger.Create(TxtTrigger4, BtnTrigger4, GrpTrigger4);
  Triggers[5] := TIssueTrigger.Create(TxtTrigger5, BtnTrigger5, GrpTrigger5);
  Triggers[6] := TIssueTrigger.Create(TxtTrigger6, BtnTrigger6, GrpTrigger6);
  Triggers[7] := TIssueTrigger.Create(TxtTrigger7, BtnTrigger7, GrpTrigger7);
  Triggers[8] := TIssueTrigger.Create(TxtTrigger8, BtnTrigger8, GrpTrigger8);
  Triggers[9] := TIssueTrigger.Create(TxtTrigger9, BtnTrigger9, GrpTrigger9);
  Triggers[10] := TIssueTrigger.Create(TxtTrigger10, BtnTrigger10, GrpTrigger10);
  TTriggerHandlerService.LoadTriggers(Triggers);
end;

procedure TFrmMain.OnTriggerClick(Sender: TObject);
var
  Button: TButton;
begin
  Button := Sender as TButton;
  TWorkloggerService.SaveWorklog(Button.Caption);
end;

{$INCLUDE 'src/edit_button_trigger_bindings.pp'}


end.

