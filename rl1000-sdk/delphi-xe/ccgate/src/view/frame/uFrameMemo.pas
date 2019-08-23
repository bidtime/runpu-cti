unit uFrameMemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ExtCtrls,
  uQueueManager;

type
  TframeMemo = class(TFrame)
    memoMsg: TMemo;
  private
    { Private declarations }
    FQueueMsg: TQueueManager;
    FLogd: boolean;
    FLog: boolean;
    FTimer1: TTimer;
    FLogMaxLines: integer;
    FSleep: boolean;
    procedure MyTimer(Sender: TObject);
    procedure showlog(const rec: TJRec);
    procedure logMemo(const S: string);
    procedure logF(const S: string);
    procedure logF_D(const S: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure add(const json: string; const bMemo: boolean=true);
    procedure addNums(const t: string; const n: integer); overload;
    procedure stop();
    procedure start();
    procedure clear;
  public
    property Logd: boolean read FLogd write FLogd;
    property Log: boolean read FLog write FLog;
    property LogMaxLines: integer read FLogMaxLines write FLogMaxLines;
    property QueueMsg: TQueueManager read FQueueMsg;
  end;

implementation

uses System.Threading, uLog4me, uLogFileU;

{$R *.dfm}

{ TFrame2 }

procedure TframeMemo.add(const json: string; const bMemo: boolean);
begin
  FQueueMsg.add(json, flog, flogd, bmemo);
end;

procedure TframeMemo.addNums(const t: string; const n: integer);
begin
  FQueueMsg.addNums(t, n, flog, flogd, true);
end;

procedure TframeMemo.clear;
begin
  self.memoMsg.Clear;
end;

constructor TframeMemo.Create(AOwner: TComponent);
begin
  inherited;
  FLogMaxLines := 200;
  memoMsg.Clear;
  FQueueMsg := TQueueManager.create;
  FTimer1 := TTimer.Create(nil);
  FTimer1.Interval := 500;
  FTimer1.OnTimer := MyTimer;
  FTimer1.Enabled := true;
  FLogd := false;
  FLog := true;
end;

destructor TframeMemo.Destroy;
begin
  FTimer1.Free;
  FQueueMsg.Free;
  inherited;
end;

procedure TframeMemo.showlog(const rec: TJRec);
begin
  if rec.json.IsEmpty then begin
    exit;
  end;
  if rec.logMemo then begin
    logMemo(rec.json);
//  end else if rec.logD then begin
//    logF_D(rec.json);
//  end else if rec.log then begin
//    logF(rec.json);
  end;
end;

procedure TframeMemo.start;
begin
  FSleep := false;
end;

procedure TframeMemo.stop;
begin
  FSleep := true;
end;

procedure TframeMemo.MyTimer(Sender: TObject);
begin
  if FSleep then begin
    //TTimer(Sender).Enabled := false;
    exit;
  end;
  TTimer(Sender).Enabled := false;
  try
      Application.ProcessMessages;
//    TTask.run(
//     procedure
//     begin
//      TThread.Synchronize(nil,
//        procedure
//        begin
//          showlog(FQueueMsg.get);
//          Application.ProcessMessages;
//        end);
//     end);
      showlog(FQueueMsg.get);
      Application.ProcessMessages;
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TframeMemo.logF(const S: string);
begin
  //log4debug(S);
end;

procedure TframeMemo.logF_D(const S: string);
begin
  //TLogFileU.debug(S);
end;

procedure TframeMemo.logMemo(const S: string);

  function getMsgTime(const msg : String): string;
  var strTime: string;
  begin
    strTime := formatdatetime('hh:nn:ss zzz ', Now());
    Result := strTime + msg;
  end;

  function getMsgSys(const msg : String): string;
  begin
    Result := getMsgTime('ÏûÏ¢: ' + msg);
  end;

begin
  memoMsg.Lines.BeginUpdate;
  try
    //self.memoMsg.Lines.Append(TFormatMsg.getMsgSys(S));
    //self.memoMsg.Lines.Exchange();
    if memoMsg.Lines.Count >= FLogMaxLines then begin
      self.memoMsg.Lines.Delete(memoMsg.Lines.Count-1);
    end;
    self.memoMsg.Lines.insert(0, getMsgSys(S));
  finally
    memoMsg.Lines.EndUpdate;
  end;
end;

end.
