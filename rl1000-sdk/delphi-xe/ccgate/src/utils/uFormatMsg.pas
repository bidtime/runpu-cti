unit uFormatMsg;

interface

uses
  Classes;

type
  TFormatMsg = class
  private
  public
    { Public declarations }
    class function getMsgSys(const msg : String): string; overload;
    class function getMsgTime(const msg : String): string; overload;
  end;

implementation

uses Windows, SysUtils;

{ TFormatMsg }

class function TFormatMsg.getMsgTime(const msg : String): string;
var strTime: string;
begin
  strTime := formatdatetime('hh:nn:ss zzz ', Now());
  Result := strTime + msg;
end;

class function TFormatMsg.getMsgSys(const msg : String): string;
begin
  Result := getMsgTime('ÏûÏ¢: ' + msg);
end;

end.

