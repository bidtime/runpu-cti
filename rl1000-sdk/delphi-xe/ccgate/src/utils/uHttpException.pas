unit uHttpException;

interface

uses
  Classes, SysUtils;

type
  THttpBreakException = class(Exception)
  private
  public
    constructor Create(const   Msg:   string );
  end;

  THttpNoLoginException = class(Exception)
  private
  public
    constructor Create(const   Msg:   string );
  end;

var
  g_closed: boolean = false;
  p_closed: ^boolean = @g_closed;

implementation

{ THttpBreakException }

constructor THttpBreakException.Create(const Msg: string);
begin
  inherited Create(msg);
end;

constructor THttpNoLoginException.Create(const Msg: string);
begin
  inherited Create(msg);
end;

initialization

finalization

end.

