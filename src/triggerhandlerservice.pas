unit TriggerHandlerService;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls;

const
  TRIGGERS_FILE = 'triggers.conf';
  MAX_TRIGGERS = 10;
  DISABLED_TRIGGER_TEXT = '<disabled>';

type
  TIssueTrigger = class
    public
      PButton: TButton;
      PGroup: TGroupBox;
      PEdit: TEdit;
      constructor Create(Edit: TEdit; Button: TButton; Group: TGroupBox);
  end;

  TIssueTriggers = array [1..MAX_TRIGGERS] of TIssueTrigger;

  TTriggerHandlerService = class
    public
      class procedure SaveTriggers(position: string; value: string);
      class procedure LoadTriggers(var triggers: TIssueTriggers);
      class procedure BindText(Edit: TEdit; Button: TButton; Group: TGroupBox; SaveAfterBind: boolean = True);
  end;

implementation

constructor TIssueTrigger.Create(Edit: TEdit; Button: TButton; Group: TGroupBox);
begin
  PGroup := Group;
  PButton := Button;
  PEdit := Edit;
end;

class procedure TTriggerHandlerService.BindText(Edit: TEdit; Button: TButton; Group: TGroupBox; SaveAfterBind: boolean = True);
var
  colonPos: integer;
begin
  Button.Enabled := Button.Caption <> DISABLED_TRIGGER_TEXT;
  colonPos := Pos(';', Edit.Text);
  if (colonPos = 1) then
  begin
    Button.Caption := Copy(Edit.Text, 1, 1);
    Group.Caption := Copy(Edit.Text, colonPos + 1, Length(Edit.Text));
  end
  else if Edit.Text = '' then
  begin
    Button.Enabled := True;
    Button.Caption := DISABLED_TRIGGER_TEXT;
    Group.Caption := DISABLED_TRIGGER_TEXT;
  end
  else if (colonPos = Length(Edit.Text)) then
  begin
    Button.Caption := Copy(Edit.Text, 1, colonPos-1);
    Group.Caption := Copy(Edit.Text, 1, colonPos-1);
  end
  else if (colonPos > 0) then
  begin
    Button.Caption := Copy(Edit.Text, 1, colonPos - 1);
    Group.Caption := Copy(Edit.Text, colonPos + 1, Length(Edit.Text));
  end
  else
  begin
    Button.Caption := Edit.Text;
    Group.Caption := Edit.Text;
  end;
  Button.Enabled := Button.Caption <> DISABLED_TRIGGER_TEXT;
  if SaveAfterBind then
    TTriggerHandlerService.SaveTriggers(Edit.Name, Edit.Text);
end;

class procedure TTriggerHandlerService.SaveTriggers(position: string; value: string);
var
  Issues: TStringList;
begin
  Issues := TStringList.Create;
  Issues.Duplicates := dupIgnore;
  if FileExists(TRIGGERS_FILE) then
    Issues.LoadFromFile(TRIGGERS_FILE);
  Issues.Values[position] := value;
  Issues.SaveToFile(TRIGGERS_FILE);
  Issues.Free;
end;

class procedure TTriggerHandlerService.LoadTriggers(var triggers: TIssueTriggers);
var
  trigger: TIssueTrigger;
  Issues: TStringList;
  TriggerValue: string;
begin
  Issues := TStringList.Create;
  if FileExists(TRIGGERS_FILE) then
  begin
    Issues.LoadFromFile(TRIGGERS_FILE);
    for trigger in triggers do
    begin
      TriggerValue := Issues.Values[trigger.PEdit.Name];
      trigger.PEdit.Text := Trim(TriggerValue);
    end;
  end;
end;

end.

