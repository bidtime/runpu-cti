unit uCmdCookie;

interface

uses
  Classes, uCmdBoolean;

type
  TAddCookie = class(TCmdStringData)
  private
  public
    class function process(const Text: String): string; static;
  end;

implementation

uses uCmdResponse, uCmdComm, uJsonSUtils, SysUtils, uHttpUtils, uFileDataPost;

{ TAddCookie }

class function TAddCookie.process(const Text: String): string;
var u: TCmdRequest<TCmdStringData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdStringData>>(Text);
  try
    try
      THttpUtils.addCookie(u.request.param.value);
      g_FileDirProcess.starttimer();
      Result := TCmdResponse.successJson(u.cmd);
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson(u.cmd, u.request, e.Message);
      end;
    end;
  finally
    if Assigned(u) then begin
      u.Free;
    end;
  end;
end;

{
class function TAddCookie.processA(Sender: TObject): string;
var u: TCmdRequest<TCmdStringData>;
begin
  u:= TCmdRequest<TCmdStringData>(Sender);
  THttpUtils.addCookie(u.request.param.value);
  Result := TCmdResponse.successJson<TCmdStringData>(u);
end;}

end.

