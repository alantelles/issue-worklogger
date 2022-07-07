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
procedure SendWorklog(issue: string; startedAt: string; TimeSpent: string);

implementation

uses
  WorkloggerService;

{$R *.lfm}

{ TFrmLogList }

procedure TFrmLogList.FormShow(Sender: TObject);
begin
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
  i, logs: integer;
begin
  logs := Sgrid.RowCount - 1;
  if logs > 1 then
  begin
    for i:= 1 to logs - 1 do
    begin
      if (SGrid.Cells[2, i] = FINISHED) or (SGrid.Cells[2, i] = ERROR_ON_SENDING) then
      begin
        SendWorklog(
          SGrid.Cells[0, i], // issue
          SGrid.Cells[1, i], // startedAt
          SGrid.Cells[3, i] // timespent
        );
      end;
    end;
    FrmLogList.StatusBar1.SimpleText := 'Finished!';
    ShowMessage('Finished');
  end
  else
    ShowMessage('No worklogs ready to be sent');
end;

procedure SendWorklog(issue: string; startedAt: string; TimeSpent: string);
begin
  FrmLogList.StatusBar1.SimpleText := 'Sending: ' + issue + '/' + startedAt + '/' + TimeSpent;
  Application.ProcessMessages;
  sleep(2000);
end;

end.

