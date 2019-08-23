unit uUploadDTO;

interface

uses
  Classes;

type

  TFileUpData = record
  private
    { Private declarations }
  public
    { Public declarations }
    url: string;
    size: longint;
    name: string;
  end;

  TReturnData = record
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TReturnDTO<T> = record
  private
    //procedure FreeD(var Obj);
    { Private declarations }
  public
    { Public declarations }
    data: T;
    msg: string;
    success: boolean;
    total: longint;
    code: integer;
    //constructor create();
    //destructor Destroy(); override;
  end;

  //'{"code":null,"data":"254622411540963328","msg":null,"success":true,"total":null}'

  TReturnDTOUtils = class
  private
    //class function try_success(const S: string): boolean; static;
    class function DeSerializeA<T>(const S: string): TReturnDTO<T>; static;
    class function success(const S: string; var msg: string; var code: integer): boolean; static;
  public
    { Public declarations }
    class function DeSerialize<T>(const S: string): TReturnDTO<T>; static;
    //class function success(const S: string): boolean; static;
    //class function trySuccess(const S: string): boolean; static;
  end;

implementation

uses System.JSON.Serializers, SysUtils, uFileRecUtils, System.json,
  uHttpException, uLog4me;

{ TReturnDTOUtils<T> }

class function TReturnDTOUtils.DeSerializeA<T>(const s: string): TReturnDTO<T>;
var Serializer: TJsonSerializer;
begin
  Serializer := TJsonSerializer.Create;
  try
    Result := Serializer.DeSerialize<TReturnDTO<T>>(S);
  finally
    Serializer.Free;
  end;
end;

class function TReturnDTOUtils.DeSerialize<T>(const s: string): TReturnDTO<T>;
var msg: string;
  code: integer;
begin
  if (not TReturnDTOUtils.success(S, msg, code)) then begin
    Result.msg := msg;
    Result.success := false;
    Result.code := code;
  end else begin
    Result := TReturnDTOUtils.DeSerializeA<T>(S);
  end;
end;

//class function TReturnDTOUtils.trySuccess(const S: string): boolean;
//var
//  u: TReturnDTO<TReturnData>;
//begin
//  try
//    u := TReturnDTOUtils.DeSerialize<TReturnData>(S);
//  except
//    on e: Exception do begin
//    end;
//  end;
//  Result := u.success;
//end;

class function TReturnDTOUtils.success(const S: string; var msg: string; var code: integer): boolean;
var
  jsonObj: TJSONObject;
  jsCode: TJSONValue;
begin
  Result := false;
  jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
  try
    if Assigned(jsonObj) then begin
      Result := (jsonObj.GetValue('success') as TJSONBool).AsBoolean;
      if not Result then begin
        msg := (jsonObj.GetValue('msg') as TJSONString).value;
      end;
      jsCode := jsonObj.GetValue('code');
      if (not jsCode.Null) then begin
        code := (jsCode as TJSONNumber).AsInt;
      end else begin
        code := 0;
      end;
    end;
  finally
    jsonObj.Free;
  end;
end;

//class function TReturnDTOUtils.try_success(const S: string): boolean;
//var
//  jsonObj: TJSONObject;
//begin
//  Result := false;
//  jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
//  try
//    if Assigned(jsonObj) then begin
//      Result := (jsonObj.GetValue('success') as TJSONBool).AsBoolean;
//    end;
//  finally
//    jsonObj.Free;
//  end;
//end;

{ TReturnDTO<T> }

{constructor TReturnDTO<T>.create;
begin
  inherited;
end;

procedure TReturnDTO<T>.FreeD(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  if Assigned(Temp) then begin
    Pointer(Obj) := nil;
    Temp.Free;
  end;
end;

destructor TReturnDTO<T>.Destroy;
begin
  FreeD(data);
  inherited;
end;}

end.

