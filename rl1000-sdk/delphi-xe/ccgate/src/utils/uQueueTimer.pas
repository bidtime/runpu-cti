unit uQueueTimer;

interface

uses
  Generics.Collections, uQueueBase, Vcl.ExtCtrls, Classes;

type
  TQueueStrTimer = class(TQueueBase<String>)
  private
    { Private declarations }
    FTimer1: TTimer;
    FOnGetQueue: TGetStrProc;
    procedure OnMyTimer(Sender: TObject);
  public
    { Public declarations }
    constructor Create; overload;
    destructor Destroy; override;
    procedure setInterv(const n: Cardinal);
    property OnGetQueue: TGetStrProc read FOnGetQueue write FOnGetQueue;
  end;

implementation

uses Forms, SysUtils;

{ TQueueTimer<T> }

constructor TQueueStrTimer.Create;
begin
  inherited;
  FTimer1 := TTimer.Create(nil);
  FTimer1.Interval := 1000;
  FTimer1.OnTimer := OnMyTimer;
  FTimer1.Enabled := true;
end;

destructor TQueueStrTimer.Destroy;
begin
  inherited;
end;

procedure TQueueStrTimer.OnMyTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
    Sleep(0);
    Application.ProcessMessages;
    //TTask.run(procedure begin
      TThread.Synchronize(nil,
      procedure
      var S: string;
      begin
        S := self.get();
        if (not S.isEmpty) and (Assigned(self.FOnGetQueue)) then begin
          self.FOnGetQueue(S);
        end;
      end);
    //end);
    Sleep(0);
    Application.ProcessMessages;
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TQueueStrTimer.setInterv(const n: Cardinal);
begin
  self.FTimer1.Interval := n;
end;

end.

