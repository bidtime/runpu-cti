unit uCmdComm;

interface

uses
  Classes, System.Json;

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
    //class function Deserialize(const Text: string): TCmdReqParam<T>;
    procedure init(const v: T);
  end;

  TCmdRequest<T> = class
  private
  protected
  public
    cmd: string;
    request: TCmdReqParam<T>;
    constructor Create();
    destructor Destroy; override;
    procedure init(const v: T);
    class function Deserialize(const Text: string): TCmdRequest<T>;
    function Serialize(): String;
  end;

implementation

uses System.JSON.Serializers, Generics.Collections, SysUtils;

{ TCmdComm }

class function TCmdComm.getCmd(const Text: string): string;
var Serializer: TJsonSerializer;
  u: TCmdComm;
begin
  Serializer := TJsonSerializer.Create;
  try
    u := Serializer.Deserialize<TCmdComm>(Text);
    try
      Result := u.cmd;
    finally
      u.Free;
    end;
  finally
    Serializer.Free;
  end;
end;

{ TCmdRequest<T> }

constructor TCmdRequest<T>.create;
begin
  inherited;
end;

class function TCmdRequest<T>.Deserialize(const Text: string): TCmdRequest<T>;
var Serializer: TJsonSerializer;
  u: TCmdRequest<T>;
begin
  Serializer := TJsonSerializer.Create;
  try
    u := Serializer.Deserialize<TCmdRequest<T>>(Text);
    try
      Result := u;
    finally
      //u.Free;
    end;
  finally
    Serializer.Free;
  end;
end;

destructor TCmdRequest<T>.destroy;
begin
  if Assigned(request) then begin
    request.Free;
  end;
  inherited;
end;

procedure TCmdRequest<T>.init(const v: T);
begin
  self.cmd := 'cmd-test';
  self.request := TCmdReqParam<T>.create();
  self.request.init(v);
end;

function TCmdRequest<T>.Serialize: String;
var Serializer: TJsonSerializer;
begin
  Serializer := TJsonSerializer.Create;
  try
    Result := Serializer.Serialize<TCmdRequest<T>>(self);
  finally
    Serializer.Free;
  end;
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
  //FreeD(param);
  //FreeAndNil(param);
  inherited;
end;

procedure TCmdReqParam<T>.init(const v: T);
begin
  self.uri := 'a=b&b=看恋';
  self.keepResponse := false;
  self.param := v;
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

{class function TCmdReqParam<T>.Deserialize(const Text: string): TCmdReqParam<T>;
end; }

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

