unit uResultDTO;

interface

uses
  Classes;

type
  TResultData = class
  private
  protected
  public
  end;

  TResultString = class
  private
  protected
  public
    value: string;
    constructor Create(const val: string); overload;
  end;

  TResultHangCallIn = class(TResultString)
  private
  protected
  public
    phone: string;
    constructor Create(const val: string; const phone: string); overload;
  end;

  TResultDTO<T> = class
  private
  protected
  public
    state: integer;
    msg: string;
    data: T;
    constructor Create(); overload;
    //constructor Create(const msg: string); overload;
    constructor Create(const d: T); overload;
    destructor Destroy; override;
    //class function Deserialize(const Text: string): string; static;
    class function error(const msg: string): TResultDTO<T>; static;
    class function success(const msg: string): TResultDTO<T>; static;
    function Serialize(): string;
  end;

implementation

uses System.JSON.Serializers;

{ TResultDTO }

constructor TResultDTO<T>.Create();
begin
  inherited create;
  self.state := 0;
  self.msg := '';
end;

constructor TResultDTO<T>.Create(const d: T);
begin
  self.create;
  data := d;
end;

{constructor TResultDTO<T>.Create(const msg: string);
begin
  inherited create;
  state := 0;
  self.msg := msg;
end;}

destructor TResultDTO<T>.Destroy;
begin
  inherited;
end;

{class function TResultDTO<T>.Deserialize(const Text: string): string;
var Serializer: TJsonSerializer;
  u: TResultDTO<T>;
begin
  Serializer := TJsonSerializer.Create;
  try
    u := Serializer.Deserialize<TResultDTO<T>>(Text);
    try
      Result := u.cmd;
    finally
      u.Free;
    end;
  finally
    Serializer.Free;
  end;
end;}

function TResultDTO<T>.Serialize(): string;
var js: TJsonSerializer;
begin
  js := TJsonSerializer.Create;
  try
    result := js.Serialize<TResultDTO<T>>(self);
  finally
    js.Free;
  end;
end;

class function TResultDTO<T>.error(const msg: string): TResultDTO<T>;
var dto: TResultDTO<T>;
begin
  dto := TResultDTO<T>.create;
  dto.msg := msg;
  dto.state := 1;
  Result := dto;
end;

{class function TResultDTO<T>.errorJson(const msg: String): string;
var dto: TResultDTO<TResultData>;
begin
  dto := TResultDTO<TResultData>.error(msg);
  try
    Result := dto.Serialize;
  finally
    dto.Free;
  end;
end;

class function TResultDTO<T>.successJson(const msg: String): string;
var dto: TResultDTO<TResultData>;
begin
  dto := TResultDTO<TResultData>.success(msg);
  try
    Result := dto.Serialize;
  finally
    dto.Free;
  end;
end;}

class function TResultDTO<T>.success(const msg: string): TResultDTO<T>;
var dto: TResultDTO<T>;
begin
  dto := TResultDTO<T>.create;
  dto.msg := msg;
  Result := dto;
end;

{ TResultString }

constructor TResultString.Create(const val: string);
begin
  inherited create;
  self.value := val;
end;

{ TResultHangCallIn }

constructor TResultHangCallIn.Create(const val, phone: string);
begin
  inherited create;
  self.value := val;
  self.phone := phone;
end;

end.

