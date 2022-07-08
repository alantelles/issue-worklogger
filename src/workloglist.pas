unit workloglist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ComCtrls;

type

  { TFrmLogList }

  TFrmLogList = class(TForm)
    BtnSendWorklogs: TButton;
    BtnReloadWorklogs: TButton;
    SgrWorklogList: TStringGrid;
    StatusBar1: TStatusBar;
    procedure BtnSendWorklogsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FrmLogList: TFrmLogList;

procedure SendWorklogs(SGrid: TStringGrid);
function SendWorklog(issue: string; startedAt: string; TimeSpent: string): boolean;

implementation

uses
  WorkloggerService;

{$R *.lfm}

{ TFrmLogList }

procedure TFrmLogList.FormShow(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Ready';
  if FileExists(TWorkloggerService.GetTodayWorklogPath) then
    SgrWorklogList.LoadFromCSVFile(TWorkloggerService.GetTodayWorklogPath, CSV_SEPARATOR, false, 0, true)
  else
  begin
    ShowMessage('No worklogs registered today');
    FrmLogList.Hide;
  end;
end;

procedure TFrmLogList.BtnSendWorklogsClick(Sender: TObject);
begin
  BtnSendWorklogs.Enabled := False;
  BtnSendWorklogs.Caption := 'Sending...';
  SendWorklogs(SgrWorklogList);
  BtnSendWorklogs.Enabled := True;
  BtnSendWorklogs.Caption := 'Send worklogs';
end;

procedure SendWorklogs(Sgrid: TStringGrid);
var
  i, logs, sent, readytoSend, errorsOnSend: integer;
  WorklogSaveResult: boolean;
begin
  logs := Sgrid.RowCount - 1;
  if logs > 1 then
  begin
    sent := 0;
    ReadyToSend := 0;
    errorsOnSend := 0;
    for i:= 1 to logs - 1 do
    begin
      if (SGrid.Cells[0, i] <> WORK_PAUSE) and
         ((SGrid.Cells[2, i] = FINISHED) or (SGrid.Cells[2, i] = ERROR_ON_SENDING)) then
      begin
        readytoSend := readyToSend + 1;
        WorklogSaveResult := SendWorklog(
          SGrid.Cells[0, i], // issue
          SGrid.Cells[1, i], // startedAt
          SGrid.Cells[3, i] // timespent
        );
        if WorklogSaveResult then
        begin
          SGrid.Cells[2, i] := SENT_TO_HUB;
          sent := sent + 1;
        end
        else
        begin
          SGrid.Cells[2, i] := ERROR_ON_SENDING;
          errorsOnSend := errorsOnsend + 1;
        end;
        Sgrid.SaveToCSVFile(TWorkloggerService.GetTodayWorklogPath, CSV_SEPARATOR, False, True);
        Sleep(10);
      end;

    end;
    FrmLogList.StatusBar1.SimpleText := 'Finished! Ready: ' + IntToStr(readyToSend) + '; Sent: ' + IntToStr(Sent) + '; Errors: ' + IntToStr(ErrorsOnSend);
    ShowMessage('Finished!' + sLinebreak + sLineBreak +
        'Ready: ' + IntToStr(readyToSend) + sLineBreak +
        'Sent: ' + IntToStr(Sent) + sLineBreak +
        'Errors: ' + IntToStr(ErrorsOnSend)
    );
  end
  else
    ShowMessage('No worklogs ready to be sent');
end;

function SendWorklog(issue: string; startedAt: string; TimeSpent: string): boolean;
begin
  Application.ProcessMessages;
  FrmLogList.StatusBar1.SimpleText := 'Sending: ' + issue + '/' + startedAt + '/' + TimeSpent;
  Result := TWorkloggerService.SendWorklogToManager(issue, startedAt, timespent);
end;

end.

