unit uFrameMemo;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Controls, Vcl.Forms, uQueueManager;

type
  TframeMemo = class(TFrame)
    memoMsg: TMemo;
  private
    { Private declarations }
    FQueueMsg: TQueueManager;
    FLogd: boolean;
    FLog: boolean;
    FLogMemo: boolean;
    FTimer1: TTimer;
    FLogMaxLines: integer;
    FSleep: boolean;
    FOnGetQueue: TGetStrProc;
    FAtOnce: boolean;
    procedure MyTimer(Sender: TObject);
    procedure showlog(const rec: TJRec);
    procedure logMemo(const S: string);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure add(const json: string; const bMemo: boolean=true);
    procedure addNums(const t: string; const n: integer); overload;
    procedure stop();
    procedure start();
    procedure clear;
    procedure setInterval(const n: Cardinal);
  public
    property LogM: boolean read FLogMemo write FLogMemo;
    property Logd: boolean read FLogd write FLogd;
    property Log: boolean read FLog write FLog;
    property LogMaxLines: integer read FLogMaxLines write FLogMaxLines;
    property OnGetQueue: TGetStrProc read FOnGetQueue write FOnGetQueue;
    property AtOnce: boolean read FAtOnce write FAtOnce;
  end;

implementation

uses uLog4me, uLogFileU, System.Threading;

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
  FAtOnce := false;
  FLogMaxLines := 200;
  memoMsg.Clear;
  FQueueMsg := TQueueManager.create;
  FTimer1 := TTimer.Create(nil);
  FTimer1.Interval := 250;
  FTimer1.OnTimer := MyTimer;
  FTimer1.Enabled := true;
  FLogMemo := true;
  FLogd := false;
  FLog := true;
end;

destructor TframeMemo.Destroy;
begin
  FTimer1.Free;
  FQueueMsg.Free;
  inherited;
end;

procedure TframeMemo.setInterval(const n: Cardinal);
begin
  self.FTimer1.Interval := n;
end;

procedure TframeMemo.showlog(const rec: TJRec);
var json: string;
begin
  Sleep(0);
  Application.ProcessMessages;
  json := rec.json;
  if (FLogMemo) and (rec.logMemo) then begin
    logMemo(json);
  end;
  if not json.IsEmpty then begin
    if (Assigned(self.FOnGetQueue)) then begin
      self.FOnGetQueue(json);
    end;
  end;
  if rec.logD then begin
    TLogFileU.debug(json);
  end;
  if rec.log then begin
    log4debug(json);
  end;
  Sleep(0);
  Application.ProcessMessages;
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
    exit;
  end;
  TTimer(Sender).Enabled := false;
  try
    Sleep(0);
    Application.ProcessMessages;
    //TTask.run(procedure begin
      TThread.Synchronize(nil,
      procedure
      var rec: TJRec;
      begin
        if FAtOnce then begin
          repeat
            Sleep(0);
            Application.ProcessMessages;
            rec := FQueueMsg.get;
            showlog(rec);
          until rec.json.IsEmpty;
        end else begin
          showlog(FQueueMsg.get);
        end;
      end);
    //end);
    Sleep(0);
    Application.ProcessMessages;
  finally
    TTimer(Sender).Enabled := true;
  end;
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
  //memoMsg.Lines.BeginUpdate;
  try
    //self.memoMsg.Lines.Append(TFormatMsg.getMsgSys(S));
    //self.memoMsg.Lines.Exchange();
    if memoMsg.Lines.Count >= FLogMaxLines then begin
      self.memoMsg.Lines.Delete(memoMsg.Lines.Count-1);
    end;
    self.memoMsg.Lines.insert(0, getMsgSys(S));
  finally
    //memoMsg.Lines.EndUpdate;
  end;
end;

end.
