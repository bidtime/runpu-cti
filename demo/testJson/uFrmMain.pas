unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Forms,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Controls, Vcl.ToolWin, Vcl.ExtCtrls;

type
  TClassA = class
  private
    { Private declarations }
  public
    { Public declarations }
    id: integer;
    name: string;
    class function getDemo(): TClassA;
    class function parseJson(const S: string): TClassA; static;
    function toJson: string;
    class function getDemoJson: string;
  end;

  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    ToolButton1: TToolButton;
    memoCtx: TMemo;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Button3: TButton;
    Button4: TButton;
    MemoLog: TMemo;
    Splitter1: TSplitter;
    Button5: TButton;
    ToolButton4: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddLog(const S: string; const ext: boolean=true);
  public
    { Public declarations }
    procedure Initialize(const FromService: Boolean);
  end;

var
  Form1: TForm1;

implementation

uses System.JSON.Serializers, System.Json, REST.JSON, uCmdBoolean, uCmdComm,
  StrUtils;

{$R *.dfm}

procedure TForm1.AddLog(const S: string; const ext: boolean);
begin
  if ext then begin
    self.MemoLog.Lines.Add('--begin...---------');
    self.MemoLog.Lines.Add(S);
    self.MemoLog.Lines.Add('--end.-------------');
  end else begin
    self.MemoLog.Lines.Add(S);
  end;
end;
  {function toJson(): string;
  var jsobject: TJsonObject;
   a: TClassA;
  begin
    jsobject := TJsonObject.Create;
    try
      jsobject.AddPair('cmd', 'cmd');
      jsobject.AddPair('uri', '快玩完了');
      a := TClassA.getDemo();
      try
        jsobject.AddPair('data', TJson.ObjectToJsonObject(a));
      finally
        a.Free;
      end;
      Result := jsobject.ToJSON;
    finally
      jsobject.Free;
    end;
  end;}

procedure TForm1.Button1Click(Sender: TObject);
  function toJson(): string;
  var jsobject: TJsonObject;
  begin
    jsobject := TJsonObject.Create;
    try
      jsobject.AddPair('cmd', 'cmd');
      jsobject.AddPair('uri', '快玩完了');
      Result := jsobject.ToString;//jsobject.ToJSON;
    finally
      jsobject.Free;
    end;
  end;

  {function UnicodeToChinese(inputstr: string): string;
  var
    index: Integer;
    temp, top, last: string;
  begin
    index := 1;
    while index >= 0 do begin
      index := Pos('\u', inputstr) - 1;
      if index < 0 then begin
        last := inputstr;
        Result := Result + last;
        Exit;
      end;
      top := Copy(inputstr, 1, index); // 取出 编码字符前的 非 unic 编码的字符，如数字
      temp := Copy(inputstr, index + 1, 6); // 取出编码，包括 \u,如\u4e3f
      Delete(temp, 1, 2);
      Delete(inputstr, 1, index + 6);
      Result := Result + top + WideChar(StrToInt('$' + temp));
    end;
  end;}

var S: string;
begin
  S := toJson();
  // {"cmd":"cmd","uri":"\u5FEB\u73A9\u5B8C\u4E86"}， 中文乱码 unicode
  // 如何正确显示中文?
  AddLog(S);
  //
  //AddLog(UnicodeToChinese(S));
end;

procedure TForm1.Button2Click(Sender: TObject);
  function toJson(): string;
  var jsobject: TJsonObject;
   S: string;
   a: TClassA;
  begin
    jsobject := TJsonObject.Create;
    try
      jsobject.AddPair('cmd', 'cmd');
      a := TClassA.getDemo;
      try
        jsobject.AddPair('data', TJson.ObjectToJsonObject(a));
      finally
        a.Free;
      end;
      S := jsobject.ToJSON;
      Result := S;
    finally
      jsobject.Free;
    end;
  end;
begin
  self.AddLog(toJson());
end;

procedure TForm1.Button3Click(Sender: TObject);
  function toJson(): string;
  var js: TJsonSerializer;
    a: TClassA;
  begin
    js := TJsonSerializer.Create;
    try
      a := TClassA.getDemo;
      try
        Result := js.Serialize<TClassA>(a);
      finally
        a.Free;
      end;
    finally
      js.Free;
    end;
  end;
begin
  AddLog(toJson());
end;

procedure TForm1.Button4Click(Sender: TObject);
  function toJson(): string;
  var a: TClassA;
  begin
    a := TClassA.parseJson(TClassA.getDemoJson());
    try
      Result := a.toJson;
    finally
      a.Free;
    end;
  end;
  procedure parseJson(const S: String);
  var Root:TJSONObject;
  begin
    Root:= TJSONObject.ParseJSONValue(S) as TJSONObject;
    try
      //
    finally
      Root.Free;
    end;
  end;
var S: string;
begin
  S := toJson();
  parseJson(S);
end;

procedure TForm1.Button5Click(Sender: TObject);
  function toDemoJson(): string;
  var r: TCmdRequest<TCmdStringData>;
   dd: TCmdStringData;
  begin
    r := TCmdRequest<TCmdStringData>.create();
    dd := TCmdStringData.Create;
    try
      dd.value := 'i am test';
      r.init(dd);
      Result := r.Serialize;
    finally
      dd.Free;
      r.Free;
    end;
  end;

  function fromJson(const S: string): string;
  begin
    Result := TCmdStringData.process(S);
  end;

  procedure testIt();
  var S: string;
  begin
    S := toDemoJson();
    addLog(S);
    //
    addLog(fromJson(S));
  end;
var i: integer;
begin
  for I := 0 to 1 do begin
    addLog(IntToStr(i), false);
    testIt();
    Application.ProcessMessages;
  end;
end;

procedure TForm1.Initialize(const FromService: Boolean);
begin
  //FreeAndNil(self);
end;

{ TClassA }

class function TClassA.getDemo: TClassA;
var a: TClassA;
begin
  a := TClassA.Create();
  a.id := 1;
  a.name := 'name_' + IntToStr(a.id);
  //
  Result := a;
end;

function TClassA.toJson(): string;
var js: TJsonSerializer;
begin
  js := TJsonSerializer.Create;
  try
    Result := js.Serialize<TClassA>(self);
  finally
    js.Free;
  end;
end;

class function TClassA.getDemoJson(): string;
var
  a: TClassA;
begin
  a := TClassA.getDemo;
  try
    Result := a.toJson;
  finally
    a.Free;
  end;
end;

class function TClassA.parseJson(const S: string): TClassA;
var js: TJsonSerializer;
begin
  js := TJsonSerializer.Create;
  try
      Result := js.DeSerialize<TClassA>(S);
  finally
    js.Free;
  end;
end;

end.
