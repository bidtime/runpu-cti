unit uCmdResponse;

interface

uses
  Classes, uCmdComm;

type

  TCmdResponse = class(TCmdComm)
  private
    class function toJson(const cmd: string; const req, res: TObject): string; overload; static;
  protected
  public
    request: TObject;
    response: TObject;
    class constructor create();
    class destructor Destroy();
    class function successJson(const cmd: string): string; overload; static;
    class function successJson(const cmd, msg: string): string; overload; static;
    class function successJson(const cmd, msg, val: string): string; overload; static;
    class function successCallInJson(const cmd, msg, val, phone: string):
      string; static;
    //
    class function errorJson(const cmd: string; const req: TObject;
      const msg: string): string; overload; static;
    class function successJson(const cmd: string; const req: TObject;
      const msg: string): string; overload;
    class function successJson(const cmd: string; const req: TObject): string; overload;
    //class function successUUIDJson(const cmd: string;
    //  const req: TObject): string; static;
    class function dataToJson<T>(const cmd: string; const req: TObject;
      const data: T): string; overload;
    class function dataToJson<T>(const cmd, msg: string; const req: TObject;
      const data: T): string; overload;
    class function toCmdReqJson(const cmd: string; const req: TObject;
      const msg: string; const state: integer): string; overload;
  end;

implementation

uses SysUtils, uResultDTO, uJsonSUtils, uComObj;

{ TCmdResponse<T> }

class constructor TCmdResponse.create;
begin
  inherited;
end;

class destructor TCmdResponse.Destroy;
begin
  inherited;
end;

class function TCmdResponse.toJson(const cmd: string; const req, res: TObject): string;
var u: TCmdResponse;
begin
  u := TCmdResponse.Create;
  try
    u.cmd := cmd;
    u.request := req;
    u.response := res;
    Result := TJsonSUtils.Serialize(u);
  finally
    u.Free;
  end;
end;

class function TCmdResponse.successJson(const cmd, msg, val: string): string;
var data: TResultString;
begin
  data := TResultString.Create(val);
  try
    Result := dataToJson(cmd, msg, nil, data);
  finally
//    if FFreeData then begin
//     data.Free;
//   end;
  end;
end;

class function TCmdResponse.successCallInJson(const cmd, msg, val, phone: string): string;
var data: TResultHangCallIn;
begin
  data := TResultHangCallIn.Create(val, phone);
  try
    Result := dataToJson(cmd, msg, nil, data);
  finally
//    if FFreeData then begin
//      data.Free;
//    end;
  end;
end;

class function TCmdResponse.successJson(const cmd: string): string;
begin
  Result := successJson(cmd, '');
end;

class function TCmdResponse.successJson(const cmd, msg: string): string;
var data: TResultData;
begin
  data := TResultData.Create();
  try
    Result := dataToJson(cmd, msg, nil, data);
  finally
//    if FFreeData then begin
//      data.Free;
//    end;
  end;
end;

class function TCmdResponse.dataToJson<T>(const cmd: string; const req: TObject;
  const data: T): string;
begin
  Result := dataToJson<T>(cmd, '', req, data);
end;

class function TCmdResponse.dataToJson<T>(const cmd, msg: string; const req: TObject;
  const data: T): string;
var
  dto: TResultDTO<T>;
begin
  dto := TResultDTO<T>.create(data);
  try
    dto.msg := msg;
    Result := toJson(cmd, req, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.successJson(const cmd: string; const req: TObject;
  const msg: string): string;
begin
  Result := toCmdReqJson(cmd, req, msg, 0);
end;

class function TCmdResponse.successJson(const cmd: string; const req: TObject): string;
begin
  Result := toCmdReqJson(cmd, req, '', 0);
end;

class function TCmdResponse.errorJson(const cmd: string; const req: TObject;
  const msg: string): string;
begin
  Result := toCmdReqJson(cmd, req, msg, 1);
end;

class function TCmdResponse.toCmdReqJson(const cmd: string; const req: TObject;
  const msg: string; const state: integer): string;
var data: TResultData;
  dto: TResultDTO<TResultData>;
begin
  data := TResultData.Create();
  try
    dto := TResultDTO<TResultData>.create();
    try
      dto.data := data;
      dto.state := state;
      dto.msg := msg;
      Result := toJson(cmd, req, dto);
    finally
      dto.Free;
    end;
  finally
//    if FFreeData then begin
//      data.Free;
//    end;
  end;
end;

{function TCmdResponse.Serialize: string;
{var js: TJsonObject;
begin
  js := TJsonObject.Create;
  try
    js.AddPair('cmd', cmd);
    js.AddPair('request', TJson.ObjectToJsonObject(request));
    js.AddPair('response', TJson.ObjectToJsonObject(response));
    //result := js.Serialize<TCmdResponse>(self);
    Result := js.ToString;
  finally
    js.Free;
  end;
end;}

{
<Object>JsonString 类对象序列化为json字符串。

TPerson=class()....

string astr:= TJson.ObjectToJsonString(person);

JsonString反序列化 实例化为类对象

person := TJson.JsonToObject<TPerson>(astr);

Tokyo 10.2新增类，效率更高更快。

TJsonSerializer

Serializer:=TJsonSerializer.Create

String astr=Serializer.Serialize<TPerson>(aperson);

person= nSeriallizer.Deserialize<T>(astring);
}

end.

