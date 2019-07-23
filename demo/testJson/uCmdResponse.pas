unit uCmdResponse;

interface

uses
  Classes, uCmdComm;

type

  TCmdResponse = class(TCmdComm)
  private
    class function getUUID(const rm: boolean): string; static;
  protected
    class function toJson(const cmd: string;
      const req: TObject; const res: TObject): string; overload;
  public
    request: TObject;
    response: TObject;
    function Serialize(): string;
    class function toJson<T>(const cmdReq: TCmdRequest<T>;
      const res: TObject): string; overload; static;
    class function successValJson<T>(const cmdReq: TCmdRequest<T>;
      const val: string): string; static;
    class function successJson<T>(const cmdReq: TCmdRequest<T>): string; overload; static;
    class function successJson(const cmd, msg: string): string; overload; static;
    class function successJson(const cmd, msg, val: string): string; overload; static;
    class function successUUIDJson<T>(const cmdReq: TCmdRequest<T>): string; static;
    class function successCallInJson(const cmd, msg, val, phone: string):
      string; static;
    //
    class function errorJson<T>(const cmdReq: TCmdRequest<T>;
      const msg: string): string; overload; static;
    class function errorJson(const cmd: string; const req: TObject;
      const msg: string): string; overload; static;
  end;

  TCmdReqResp = class(TCmdComm)
  private
  protected
  public
    request: TObject;
    response: TObject;
    function Serialize(): string;
  end;

implementation

uses System.JSON.Serializers, SysUtils, System.Json,
  uResultDTO, REST.JSON, ComObj;

//, Rest.Json, DBXJSON, DBXJSONReflect, System.ConvUtils, System.JSON.Converters

{ TCmdResponse<T> }

function TCmdResponse.Serialize: string;
var js: TJsonSerializer;
begin
  js := TJsonSerializer.Create;
  try
    result := js.Serialize<TCmdResponse>(self);
  finally
    js.Free;
  end;
end;
{var js: TJsonObject;
begin
  js := TJsonObject.Create;
  try
    js.AddPair('cmd', cmd);
    js.AddPair('request', TJson.ObjectToJsonObject(request));
    js.AddPair('response', TJson.ObjectToJsonObject(response));
    //result := js.Serialize<TCmdResponse>(self);
    Result := js.ToJSON;
  finally
    js.Free;
  end;
end;}

class function TCmdResponse.toJson(const cmd: string; const req,
  res: TObject): string;
var u: TCmdResponse;
begin
  u := TCmdResponse.Create;
  try
    u.cmd := cmd;
    u.request := req;
    u.response := res;
    Result := u.Serialize;
    //Result := TJson.ObjectToJsonString(u);
    //Result := TJsonSUtils.Serialize(u);
  finally
    u.Free;
  end;
end;
{var u: TCmdResponse;
begin
  u := TCmdResponse.Create;
  try
    u.cmd := cmd;
    u.request := req;
    u.response := res;
    //Result := u.Serialize;
    Result := TJsonSUtils.Serialize(u);
  finally
    u.Free;
  end;
end;}

class function TCmdResponse.toJson<T>(const cmdReq: TCmdRequest<T>; const res: TObject): string;
begin
  Result := toJson(cmdReq.cmd, cmdReq.request, res);
end;

class function TCmdResponse.successValJson<T>(const cmdReq: TCmdRequest<T>; const val: string): string;
var dto: TResultDTO<TResultString>;
begin
  dto := TResultDTO<TResultString>.create(TResultString.Create(val));
  try
    Result := toJson(cmdReq.cmd, cmdReq.request, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.successJson(const cmd, msg, val: string): string;
var dto: TResultDTO<TResultString>;
begin
  dto := TResultDTO<TResultString>.create(TResultString.Create(val));
  try
    Result := toJson(cmd, nil, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.successCallInJson(const cmd, msg, val, phone: string): string;
var dto: TResultDTO<TResultHangCallIn>;
begin
  dto := TResultDTO<TResultHangCallIn>.create(TResultHangCallIn.Create(val, phone));
  try
    Result := toJson(cmd, nil, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.successJson<T>(const cmdReq: TCmdRequest<T>): string;
{begin
  Result := '';
end;}
{var js: TJsonObject;
  dto: TResultDTO<TResultData>;
begin
  js := TJsonObject.Create;
  try
    //js.AddPair('cmd', cmdReq.cmd);
    js.AddPair('cmd', 'cmd');
    //js.AddPair('request', TJson.ObjectToJsonObject(cmdReq.request));
    //result := js.Serialize<TCmdResponse>(self);
    dto := TResultDTO<TResultData>.create();
    try
      js.AddPair('response', TJson.ObjectToJsonObject(TJson.ObjectToJsonObject(dto)));
    finally
      dto.Free;
    end;
    Result := js.ToJSON;
  finally
    FreeAndNil(js);
  end;
end;}
var dto: TResultDTO<TResultData>;
begin
  dto := TResultDTO<TResultData>.create();
  try
    Result := toJson(cmdReq.cmd, cmdReq.request, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.successJson(const cmd, msg: string): string;
var dto: TResultDTO<TResultData>;
begin
  dto := TResultDTO<TResultData>.error(msg);
  try
    Result := toJson(cmd, nil, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.getUUID(const rm: boolean): string;
var
  //AGuid: TGUID;
  sGUID: string;
begin
  sGUID := CreateClassID;
  //ShowMessage(sGUID); // 两边带大括号的Guid
  Delete(sGUID, 1, 1);
  Delete(sGUID, Length(sGUID), 1);
  //ShowMessage(sGUID); // 去掉大括号的Guid，占36位中间有减号
  //sGUID:= StringReplace(sGUID, '-', '', [rfReplaceAll]);
  //ShowMessage(sGUID); // 去掉减号的Guid，占32位
  Result := sGUID;
end;


class function TCmdResponse.successUUIDJson<T>(const cmdReq: TCmdRequest<T>): string;
var dto: TResultDTO<TResultString>;
begin
  dto := TResultDTO<TResultString>.create(TResultString.Create(getUUID(false)));
  try
    Result := toJson(cmdReq.cmd, cmdReq.request, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.errorJson(const cmd: string; const req: TObject;
  const msg: string): string;
var dto: TResultDTO<TResultData>;
begin
  dto := TResultDTO<TResultData>.error(msg);
  try
    Result := toJson(cmd, req, dto);
  finally
    dto.Free;
  end;
end;

class function TCmdResponse.errorJson<T>(const cmdReq: TCmdRequest<T>;
  const msg: string): string;
var dto: TResultDTO<TResultData>;
begin
  dto := TResultDTO<TResultData>.error(msg);
  try
    Result := toJson(cmdReq.cmd, cmdReq.request, dto);
  finally
    dto.Free;
  end;
end;

{ TCmdReqResp }

function TCmdReqResp.Serialize: string;
  function o_j3(): string;
  var js: TJsonSerializer;
  begin
    js := TJsonSerializer.Create;
    try
      result := js.Serialize(self);
    finally
      js.Free;
    end;
  end;
begin
  Result := o_j3();
end;

//  function resposeDTO(const cmd: string; const jsonReq: TJsonValue; const jsonRes: TJsonObject): string;
//  var jsonCmd: TJSONObject;
//  begin
//    jsonCmd := TJSONObject.Create;
//    try
//      jsonCmd.AddPair(TJSONPair.Create('cmd', cmd));
//      jsonCmd.AddPair(TJSONPair.Create('request', jsonReq));
//      jsonCmd.AddPair(TJSONPair.Create('response', jsonRes));
//      //jsonRequest.AddPair(TJSONPair.Create('response', jsonResponse));
//      //Result := jsonRequest.ToJSON;
//      Result := jsonCmd.ToJSON;
//    finally
//      jsonCmd.RemovePair('request');
//      jsonCmd.RemovePair('response');
//      jsonCmd.Free;
//    end;
//  end;

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

