unit uUploadDTO;

interface

uses
  Classes;

type

  TFileUpData = class
  private
    { Private declarations }
  public
    { Public declarations }
    url: string;
    size: longint;
    name: string;
  end;

  TReturnData = class
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TReturnDTO<T> = class
  private
    procedure FreeD(var Obj);
    { Private declarations }
  public
    { Public declarations }
    data: T;
    msg: string;
    success: boolean;
    total: longint;
    constructor create();
    destructor Destroy(); override;
  end;

  //'{"code":null,"data":"254622411540963328","msg":null,"success":true,"total":null}'

  TReturnDTOUtils = class
  public
    { Public declarations }
    class function DeSerialize<T>(const S: string): TReturnDTO<T>; static;
    class function tryDeSerialize<T>(const S: string): TReturnDTO<T>; static;
    //class function success(const S: string): boolean; static;
    class function success(const S: string; var msg: string): boolean; static;
    class function trySuccess(const S: string): boolean; static;
  end;

implementation

uses System.JSON.Serializers, SysUtils, uFileRecUtils, System.json;

{ TReturnDTOUtils<T> }

class function TReturnDTOUtils.DeSerialize<T>(const s: string): TReturnDTO<T>;
var Serializer: TJsonSerializer;
begin
  Result := nil;
  Serializer := TJsonSerializer.Create;
  try
    Result := Serializer.DeSerialize<TReturnDTO<T>>(S);
  finally
    Serializer.Free;
  end;
end;

class function TReturnDTOUtils.tryDeSerialize<T>(const s: string): TReturnDTO<T>;
var Serializer: TJsonSerializer;
begin
  Result := nil;
  Serializer := TJsonSerializer.Create;
  try
    try
      Result := Serializer.DeSerialize<TReturnDTO<T>>(S);
    except
      on e: Exception do begin
      end;
    end;
  finally
    Serializer.Free;
  end;
end;

class function TReturnDTOUtils.trySuccess(const S: string): boolean;
var
  u: TReturnDTO<TReturnData>;
begin
  Result := false;
  u := nil;
  try
    try
      u := TReturnDTOUtils.DeSerialize<TReturnData>(S);
    except
      on e: Exception do begin
      end;
    end;
    if Assigned(u) then begin
      Result := u.success;
    end;
  finally
    if Assigned(u) then begin
      u.free;
    end;
  end;
end;

{class function TReturnDTOUtils.success(const S: string): boolean;
var
  jsonObj: TJSONObject;
begin
  Result := false;
  jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
  try
    if Assigned(jsonObj) then begin
      Result := (jsonObj.GetValue('success') as TJSONBool).AsBoolean;
    end;
  finally
    jsonObj.Free;
  end;
end;}

class function TReturnDTOUtils.success(const S: string; var msg: string): boolean;
var
  jsonObj: TJSONObject;
begin
  Result := false;
  jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
  try
    if Assigned(jsonObj) then begin
      Result := (jsonObj.GetValue('success') as TJSONBool).AsBoolean;
      if not Result then begin
        msg := (jsonObj.GetValue('msg') as TJSONString).value;
      end;
    end;
  finally
    jsonObj.Free;
  end;
end;

{ TReturnDTO<T> }

constructor TReturnDTO<T>.create;
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
end;

end.

