unit WorkloggerService;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  WORKLOGS_FOLDER = 'worklogs';
  CSV_SEPARATOR = ';';
  DATE_FORMAT = 'yyyy-mm-dd"T"hh:nn:ss.zzz';

type
  TWorkloggerService = class
    public
      class function GetTodayWorklogPath: string;
      class procedure SaveWorklog(issue: string);
      class function GetDateStartedFromLine(Line: string): TDateTime;
  end;

implementation
uses
  DateUtils, StrUtils;

class function TWorkloggerService.GetTodayWorklogPath: string;
const
  FORMAT = 'yyyy-mm-dd';
begin
  Result := WORKLOGS_FOLDER + DirectorySeparator + FormatDateTime(FORMAT, Date) + '.csv';
end;

class function TWorkloggerService.GetDateStartedFromLine(Line: string): TDateTime;
var
  Strdate: string;
begin
  Strdate := Copy(Line, Pos(CSV_SEPARATOR, Line) + 1, RPos(CSV_SEPARATOR, Line) - 1);
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
  TimeSpentSeconds: integer;
begin
  // issueId;started;timeSpentSeconds
  WorklogPath := TWorkLoggerService.GetTodayWorklogPath;
  WorklogCsv := TStringList.Create;
  WorklogCsv.SkipLastLineBreak := True;
  if FileExists(WorklogPath) then
    WorklogCsv.LoadFromFile(WorklogPath);
  if WorklogCsv.Count > 0 then
  begin
    TimeSpentSeconds := Trunc(SecondSpan(
                     Now,
                     TWorkloggerService.GetDateStartedFromLine(WorklogCsv[WorklogCsv.Count - 1])
                     ));
    WorklogCsv[WorklogCsv.Count - 1] := WorklogCsv[WorklogCsv.Count - 1] + IntToStr(TimeSpentSeconds);
  end;
  StrDate := FormatDateTime(DATE_FORMAT, Now);
  WorklogCsv.Add(issue + CSV_SEPARATOR + StrDate + DATE_FILLER + CSV_SEPARATOR);
  WorklogCsv.SaveToFile(worklogPath);
  WorklogCsv.Free;
end;

end.

