unit uCmdBoolean;

interface

uses
  Classes;

type
//  {
//    cmd: "dialup",
//    data:{
//      value: true
//    }
//  }
  TCmdBooleanData = class
  private
  protected
  public
    value: boolean;
    class function process(const Text: String): string; static;
  end;

  TCmdStringData = class
  private
  protected
  public
    value: string;
    procedure init();
    class function process(const Text: String): string; overload; static;
  end;

implementation

uses System.JSON.Serializers, uCmdComm, uResultDTO, uCmdResponse, SysUtils,
  //uJsonSUtils,
  System.JSON;

{ TCmdBooleanData }

class function TCmdBooleanData.process(const Text: String): string;
var Serializer: TJsonSerializer;
  u: TCmdRequest<TCmdBooleanData>;
begin
  Serializer := TJsonSerializer.Create;
  try
    u := Serializer.Deserialize<TCmdRequest<TCmdBooleanData>>(Text);
    try
      try
        Result := TCmdResponse.successJson<TCmdBooleanData>(u);
      except
        on e: Exception do begin
          Result := TCmdResponse.errorJson<TCmdBooleanData>(u, e.Message);
        end;
      end;
    finally
      u.request.param.free;
      u.request.Free;
      u.Free;
    end;
  finally
    Serializer.Free;
  end;
end;

{ TCmdStringData }

class function TCmdStringData.process(const Text: String): string;
var Serializer: TJsonSerializer;
  u: TCmdRequest<TCmdStringData>;
begin
  Serializer := TJsonSerializer.Create;
  try
    u := Serializer.Deserialize<TCmdRequest<TCmdStringData>>(Text);
    try
      try
        Result := TCmdResponse.successJson<TCmdStringData>(u);
      except
        on e: Exception do begin
          Result := TCmdResponse.errorJson<TCmdStringData>(u, e.Message);
        end;
      end;
    finally
      u.request.param.free;
      u.Free;
    end;
  finally
    Serializer.Free;
  end;
end;

{var u: TCmdRequest<TCmdStringData>;
begin
  u := TCmdRequest<TCmdStringData>.create;
  try
    Result := TCmdResponse.successJson<TCmdStringData>(u);
  finally
    u.Free;
  end;
end;}

procedure TCmdStringData.init;
begin
  value := 'abcdefg';
end;

{class function TCmdStringData.process(const Text: String; const ev: TGetStrObject): string;
var u: TCmdRequest<TCmdStringData>;
begin
  u := TJsonSUtils.Deserialize<TCmdRequest<TCmdStringData>>(Text);
  try
    try
      if Assigned(ev) then begin
        Result := ev(u);
      end else begin
        Result := TCmdResponse.successJson<TCmdStringData>(u);
        Result := 'aaaa';
      end;
    except
      on e: Exception do begin
        Result := TCmdResponse.errorJson<TCmdStringData>(u, e.Message);
      end;
    end;
  finally
    u.Free;
  end;
end;}

{class function TCmdBoolean.Deserialize(const Text: string;
  const ev: TGetObjectFuncEvent): TObject;
var Serializer: TJsonSerializer;
  u: TCmdBoolean;
begin
  Serializer := TJsonSerializer.Create;
  try
    u := Serializer.Deserialize<TCmdBoolean>(Text);
    try
      Result := ev(u);
    finally
      u.Free;
    end;
  finally
    Serializer.Free;
  end;
end;}

end.

