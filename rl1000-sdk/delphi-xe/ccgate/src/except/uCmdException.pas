unit uCmdException;

interface

uses
  Classes, SysUtils;

type

  TCmdException = class(Exception)
  private
    //cmd: string;
    //ex: string;
  protected
  public
    { Public declarations }
    //constructor Create(const cmd: string; const e: Exception); overload;
    constructor Create(const S: string); overload;
    destructor Destroy; override;
  end;

implementation

uses uResultDTO, uCmdType;

{ TCmdException }

//constructor TCmdParser.Create();
//begin
//  inherited create;
//end;

constructor TCmdException.Create(const S: string);
begin
  inherited create(s);
  message := S;
end;

{constructor TCmdException.Create(const cmd: string; const e: Exception);
  function error(const e: Exception): string;
  begin
    //Result := TResultDTO<TResultData>.errorJson(cmd, e.Message);
    Result := TResponseDTO.errorJson<TResultDTO<TResultData>>(cmd, e.Message);
  end;
begin
  inherited create(e.message);
  message := error(e);
end;}

destructor TCmdException.Destroy;
begin
  inherited;
end;

end.

