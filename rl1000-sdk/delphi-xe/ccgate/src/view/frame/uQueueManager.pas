unit uQueueManager;

interface

uses
  Generics.Collections;

type
  TJRec = record
    json: string;
    logMemo: boolean;
    log: boolean;
    logD: boolean;
  end;
  TQueueManager = class
  private
    { Private declarations }
    FCO: integer;
    Stack: TQueue<TJRec>;
  public
    { Public declarations }
    constructor create();
    destructor Destroy(); override;
    //
    procedure put(rec: TJRec);
    function get(): TJRec;
    procedure add(const json: string; const blog: boolean; const blogd: boolean; const bmemo: boolean=true);
    procedure addLog(const json: string; const blog: boolean; const bmemo: boolean=true);
    procedure addLogD(const json: string; const blog: boolean; const bmemo: boolean=true);
    //
    procedure addNums(const t: string; const n: integer); overload;
    procedure addNums(const t: string; const n: integer; const blog, blogd,
      bmemo: boolean); overload;
    function getS: string;
  end;

implementation

uses System.SysUtils, Forms;
//uses System.Threading;

constructor TQueueManager.create;
begin
  Stack := TQueue<TJRec>.Create;
  FCO := -1;
end;

destructor TQueueManager.Destroy;
begin
  Stack.Free;
  inherited;
end;

procedure TQueueManager.put(rec: TJRec);
begin
  //TTask.run(
//  TThread.Synchronize(nil,
//  procedure
//  begin
//    Stack.Enqueue(rec);
//  end);
  Stack.Enqueue(rec);
end;

function TQueueManager.get: TJRec;
var
  rec: TJRec;
begin
  //TTask.run(
//  TThread.Synchronize(nil,
//    procedure
//    begin
//      if Stack.Count >0 then begin
//        rec := Stack.Extract;
//      end;
//    end);
  if Stack.Count >0 then begin
    rec := Stack.Extract;
  end;
  Result := rec;
end;

function TQueueManager.getS: string;
var rec: TJRec;
begin
  Application.ProcessMessages;
  rec := get;
  Result := rec.json;
  Application.ProcessMessages;
end;

procedure TQueueManager.add(const json: string; const blog, blogd,
  bmemo: boolean);
var rec: TJRec;
begin
  rec.json := json;
  rec.logMemo := bmemo;
  rec.log := blog;
  rec.logD := blogd;
  self.put(rec);
end;

procedure TQueueManager.addLog(const json: string; const blog, bmemo: boolean);
begin
  add(json, blog, false, bmemo);
end;

procedure TQueueManager.addLogD(const json: string; const blog, bmemo: boolean);
begin
  add(json, blog, true, bmemo);
end;

procedure TQueueManager.addNums(const t: string; const n: integer);
var I: integer;
  rec: TJRec;
begin
  Inc(FCo);
  for I := 0 to n do begin
    rec.json := t + IntToStr(FCO) + '-' + IntToStr(I);
    rec.logMemo := true;
    rec.log := true;
    rec.logD := true;
    put(rec);
  end;
end;

procedure TQueueManager.addNums(const t: string; const n: integer; const blog, blogd,
  bmemo: boolean);
var I: integer;
  rec: TJRec;
begin
  Inc(FCo);
  for I := 0 to n do begin
    rec.json := t + IntToStr(FCO) + '-' + IntToStr(I);
    rec.logMemo := true;
    rec.log := true;
    rec.logD := true;
    put(rec);
  end;
end;

{procedure TQueueManager.addLog(const S: string);
begin
  if not s.IsEmpty then begin
    //self.Memo1.Lines.Add(S);
  end;
end;

procedure TQueueManager.addLogs(const S1, s2: string);
begin
  if not s2.IsEmpty then begin
    //self.Memo1.Lines.Add(S1 + S2);
  end;
end;

function TQueueManager.getS(): string;
var S: string;
  rec: TJRec;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if Stack.Count >0 then begin
        rec := Stack.Extract;
        S := rec.JsonS;
      end else begin
        S := '';
      end;
   end);
  Result := S;
end;}

{function TForm1.getTag(const tag: string): string;
var S: string;
begin
  S := get;
  //self.Memo1.Lines.Add(tag + S);
  Result := tag + S;
end;}

{procedure TQueueManager.Timer1Timer(Sender: TObject);
begin
 TThread.Synchronize(nil,
   procedure
   begin
    addLogs('time1_', get());
   end);
end;

procedure TQueueManager.Timer2Timer(Sender: TObject);
begin
 TThread.Synchronize(nil,
   procedure
   begin
    addLogs('time2_', get());
   end);
end;

procedure TQueueManager.Timer3Timer(Sender: TObject);
begin
 TThread.Synchronize(nil,
   procedure
   begin
     addNums('T3-', 10);
   end);
end;

procedure TQueueManager.Timer4Timer(Sender: TObject);
begin
 TThread.Synchronize(nil,
   procedure
   begin
     addNums('T4-', 10);
   end);
end;}

end.

