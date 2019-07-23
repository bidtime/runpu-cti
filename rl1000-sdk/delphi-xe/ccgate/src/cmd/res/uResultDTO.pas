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

  TResultStringU = class(TResultString)
  private
  protected
  public
    constructor Create();
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
    procedure FreeD(var Obj);
  protected
  public
    state: integer;
    msg: string;
    data: T;
    constructor Create(); overload;
    //constructor Create(const msg: string); overload;
    constructor Create(const d: T); overload;
    destructor Destroy; override;
    class function error(const msg: string): TResultDTO<T>; static;
    class function success(const msg: string): TResultDTO<T>; static;
  end;

implementation

uses uComObj;

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

procedure TResultDTO<T>.FreeD(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  if Assigned(Temp) then begin
    Pointer(Obj) := nil;
    Temp.Free;
  end;
end;

destructor TResultDTO<T>.Destroy;
begin
  FreeD(data);
  inherited;
end;

class function TResultDTO<T>.error(const msg: string): TResultDTO<T>;
var dto: TResultDTO<T>;
begin
  dto := TResultDTO<T>.create;
  dto.msg := msg;
  dto.state := 1;
  Result := dto;
end;

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

{ TResultStringU }

constructor TResultStringU.Create;
begin
  inherited;
  value := newUUID(false);
end;

end.

