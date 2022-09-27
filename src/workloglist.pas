unit workloglist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ComCtrls, ExtDlgs;

type

  { TFrmLogList }

  TFrmLogList = class(TForm)
    BtnOpenWorklog: TButton;
    BtnSendWorklogs: TButton;
    BtnReloadWorklogs: TButton;
    CalSelectWorklog: TCalendarDialog;
    Label1: TLabel;
    LblWorkDate: TLabel;
    SgrWorklogList: TStringGrid;
    StatusBar1: TStatusBar;
    procedure BtnOpenWorklogClick(Sender: TObject);
    procedure BtnSendWorklogsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FrmLogList: TFrmLogList;
  SelectedWorklogDate: TDateTime;

procedure SendWorklogs(SGrid: TStringGrid);
procedure SetDateLabel(ALabel: TLabel; DateStr: string);
function SendWorklog(issue: string; startedAt: string; TimeSpent: string): boolean;

implementation

uses
  WorkloggerService;

{$R *.lfm}

{ TFrmLogList }

procedure TFrmLogList.FormShow(Sender: TObject);
begin
  SelectedWorklogDate := Now;
  SetDateLabel(LblWorkDate, FormatDateTime(WORKLOG_DATE_FORMAT, SelectedWorkLogDate));
  StatusBar1.SimpleText := 'Ready';
  if FileExists(TWorkloggerService.GetTodayWorklogPath) then
    SgrWorklogList.LoadFromCSVFile(TWorkloggerService.GetTodayWorklogPath, CSV_SEPARATOR, false, 0, true);
end;

procedure TFrmLogList.BtnSendWorklogsClick(Sender: TObject);
begin
  BtnSendWorklogs.Enabled := False;
  BtnSendWorklogs.Caption := 'Sending...';
  SendWorklogs(SgrWorklogList);
  BtnSendWorklogs.Enabled := True;
  BtnSendWorklogs.Caption := 'Send worklogs';
end;

procedure TFrmLogList.BtnOpenWorklogClick(Sender: TObject);
var
  WorklogFile, SelectedDate: string;
begin
  if CalSelectWorklog.Execute then
  begin
    SelectedWorkLogDate := CalSelectWorklog.Date;
    SelectedDate := FormatDateTime(WORKLOG_DATE_FORMAT, SelectedWorklogDate);
    WorklogFile := TWorkloggerService.GetWorklogPath(SelectedDate);
    if not FileExists(WorklogFile) then
    begin
      ShowMessage('No worklog registered for this date');
      Exit;
    end;
    TWorkloggerService.LoadDailyWorklog(SgrWorklogList, WorklogFile);
    SetDateLabel(LblWorkDate, SelectedDate);
  end;
end;

procedure SetDateLabel(ALabel: TLabel; DateStr: string);
begin
  if (FormatDateTime(WORKLOG_DATE_FORMAT, Date) = DateStr) then
    ALabel.Caption := 'Today'
  else
    ALabel.Caption := DateStr;
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
        Sgrid.SaveToCSVFile(TWorkloggerService.GetWorklogPath(
            FormatDateTime(WORKLOG_DATE_FORMAT, SelectedWorklogDate)),
          CSV_SEPARATOR, False, True);
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

