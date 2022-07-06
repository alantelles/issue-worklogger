unit FileSaveServiceUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const TRIGGERS_FILE = 'triggers.conf';

type
  TFileSaveService = class
    public class procedure SaveTriggers(position: string; value: string);
  end;

implementation

class procedure TFileSaveService.SaveTriggers(position: string; value: string);
var
  Issues: TStringList;
  IndexPosition: integer;
begin
  Issues := TStringList.Create;
  if FileExists(TRIGGERS_FILE) then
    Issues.LoadFromFile(TRIGGERS_FILE);
  IndexPosition := Issues.IndexOfName(position);
  if (IndexPosition > -1) then
    Issues.Delete(IndexPosition);
  Issues.AddPair(position, value);
  Issues.SaveToFile(TRIGGERS_FILE);
  Issues.Free;
end;

end.

