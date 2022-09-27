unit WorkloggerService;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

const
  WORKLOGS_FOLDER = 'worklogs';
  CSV_SEPARATOR = ';';
  DATE_FORMAT = 'yyyy-mm-dd"T"hh:nn:ss.zzz';
  WORKLOG_DATE_FORMAT = 'yyyy-mm-dd';
  WORK_PAUSE = 'Work pause';
  SEND_WORKLOG_SCRIPT_NAME = 'send_worklog.sh';

  // Statuses
  NOW_WORKING = 'Now working';
  FINISHED = 'Finished';
  SENT_TO_HUB = 'Sent';
  SENDING = 'Sending';
  ERROR_ON_SENDING = 'Error on sending';

type
  TWorkloggerService = class
    public
      class function GetTodayWorklogPath: string;
      class function GetWorklogPath(DateStr: string): string;
      class procedure LoadDailyWorklog(Table: TStringGrid; Path: string);
      class procedure SaveWorklog(issue: string);
      class function GetDateStartedFromLine(Line: string): TDateTime;
      class function GetFinishedLastIssue(Line: string): string;
      class function SendWorklogToManager(Issue: string; startedAt: string; timeSpent: string): boolean;
  end;

implementation
uses
  DateUtils, StrUtils, Process;

class function TWorkloggerService.GetFinishedLastIssue(Line: string): string;
var
  TimeSpentSeconds: integer;
  LinePart: string;
begin
  // IssueKey;yyyy-mm-ddThh:nn:ss.zzz+0300;STATUS;
  TimeSpentSeconds := Trunc(SecondSpan(
                     Now,
                     TWorkloggerService.GetDateStartedFromLine(Line)
                     ));
  LinePart := Copy(Line, 1, NPos(CSV_SEPARATOR, Line, 2));
  Result := LinePart + FINISHED + CSV_SEPARATOR + IntToStr(TimeSpentSeconds);
end;

class procedure TWorkloggerService.LoadDailyWorklog(Table: TStringGrid; Path: string);
begin
  Table.LoadFromCSVFile(Path, CSV_SEPARATOR, false, 0);
  if Table.ColCount > 3 then
    Table.Columns.Items[3].Title.Caption := 'Time spent (seconds)';
end;

class function TWorkloggerService.GetTodayWorklogPath: string;
const
  FORMAT = WORKLOG_DATE_FORMAT;
begin
  Result := TWorkloggerService.GetWorklogPath(FormatDateTime(FORMAT, Date));
end;
class function TWorkloggerService.GetWorklogPath(DateStr: string): string;
begin
  Result := WORKLOGS_FOLDER + DirectorySeparator + DateStr + '.csv';
end;

class function TWorkloggerService.GetDateStartedFromLine(Line: string): TDateTime;
var
  Strdate: string;
begin
  Strdate := Copy(Line, Pos(CSV_SEPARATOR, Line) + 1, Length(Line));
  StrDate := Copy(StrDate, 1, Pos('+', Strdate) - 1);
  Result := ScanDateTime(DATE_FORMAT, StrDate);
end;

class procedure TWorkloggerService.SaveWorklog(issue: string);
const
  // TODO: allow other timezones
  DATE_FILLER = '+0300';
var
  worklogPath: string;
  WorklogCsv: TStringList;
  StrDate: string;
  SameIssueLast: boolean = false;
begin
  // IssueKey;yyyy-mm-ddThh:nn:ss.zzz+0300;STATUS;
  WorklogPath := TWorkLoggerService.GetTodayWorklogPath;
  WorklogCsv := TStringList.Create;
  WorklogCsv.SkipLastLineBreak := True;
  if FileExists(WorklogPath) then
    WorklogCsv.LoadFromFile(WorklogPath);
  if WorklogCsv.Count > 0 then
  begin
    SameIssueLast := Copy(WorklogCsv[WorklogCsv.Count - 1], 1, Pos(CSV_SEPARATOR, WorklogCsv[WorklogCsv.Count - 1]) - 1) = issue;
    if not SameIssueLast then
    begin
      WorklogCsv[WorklogCsv.Count - 1] := TWorkloggerService.GetFinishedLastIssue(WorklogCsv[WorklogCsv.Count - 1]);
    end;
  end;
  if not SameIssueLast then
  begin
    StrDate := FormatDateTime(DATE_FORMAT, Now);
    // IssueKey;yyyy-mm-ddThh:nn:ss.zzz+0300;STATUS;
    WorklogCsv.Add(issue + CSV_SEPARATOR +
                         StrDate + DATE_FILLER + CSV_SEPARATOR +
                         NOW_WORKING + CSV_SEPARATOR);
    WorklogCsv.SaveToFile(worklogPath);
  end;
  WorklogCsv.Free;
end;

class function TWorkLoggerService.SendWorklogToManager(Issue: string; startedAt: string; timeSpent: string): boolean;
var
  AProcess: TProcess;
  AOutput: TStringList;
  Successfully: boolean = False;
  Response: string;
begin
  AProcess := TProcess.Create(nil);
  AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
  AProcess.Executable := SEND_WORKLOG_SCRIPT_NAME;
  Aprocess.Parameters.Add(Issue);
  Aprocess.Parameters.Add(startedAt);
  Aprocess.Parameters.Add(timeSpent);
  Aprocess.Execute;
  AOutput := TStringList.Create;
  AOutput.SkipLastLineBreak := True;
  AOutput.LoadFromStream(AProcess.Output);
  Response := Trim(AOutput.Text);
  AOutput.Free;
  if (Response[1] = '2') and (Length(Response) = 3) then
  begin
    successfully := true;
  end;
  AProcess.Free;
  Result := Successfully;
end;

end.

