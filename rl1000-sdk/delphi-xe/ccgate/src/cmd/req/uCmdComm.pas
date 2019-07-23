unit uCmdComm;

interface

uses
  Classes;

type
  TCmdComm = class
  private
  protected
  public
    cmd: string;
    class function getCmd(const Text: string): string; static;
  end;

  TCmdReqParamData = class
  private
  protected
  public
  end;

  TCmdReqParam<T> = class
  private
    procedure FreeD(var Obj);
  protected
  public
    uri: string;
    param: T;
    keepResponse: boolean;
    constructor Create();
    destructor Destroy; override;
  end;

  TCmdRequest<T> = class
  private
  protected
  public
    cmd: string;
    request: TCmdReqParam<T>;
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses uJsonSUtils, SysUtils;

{ TCmdComm }

class function TCmdComm.getCmd(const Text: string): string;
var u: TCmdComm;
begin
  u := TJsonSUtils.Deserialize<TCmdComm>(Text);
  try
    Result := u.cmd;
  finally
    u.Free;
  end;
end;

{ TCmdRequest<T> }

constructor TCmdRequest<T>.create;
begin
  inherited;
end;

destructor TCmdRequest<T>.destroy;
begin
  if Assigned(request) then begin
    request.Free;
  end;
  inherited;
end;

{ TCmdReqParam<T> }

constructor TCmdReqParam<T>.Create;
begin
  inherited;
end;

procedure TCmdReqParam<T>.FreeD(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  if Assigned(Temp) then begin
    Pointer(Obj) := nil;
    Temp.Free;
  end;
end;

destructor TCmdReqParam<T>.Destroy;
begin
  FreeD(param);
  inherited;
end;

//  var jsonObj: TJsonObject;
//  begin
//    jsonObj := TJsonObject.Create;
//    try
//      jsonObj.AddPair(TJSONPair.Create('cmd', cmd));
//      jsonObj.AddPair(TJSONPair.Create('request', jsonReq));
//      jsonObj.AddPair(TJSONPair.Create('response', TJson.ObjectToJsonObject(dto)));
//      Result := jsonObj.ToJSON;
//    finally
//      jsonObj.RemovePair('request');
//      jsonObj.Free;
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

