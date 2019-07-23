unit uUpgradeTimer;

interface

uses
  classes, ExtCtrls;

type
  TCommonTimer = class
  protected
    FTimerDir: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure processDir(); virtual; abstract;
  public
    constructor Create(const interv: Cardinal);
    destructor Destroy; override;
    procedure start();
    procedure stop();
  end;

  TUpgradeTimer = class(TCommonTimer)
  protected
    procedure processDir(); override;
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses uVerInfo, windows, SysUtils, uFrmMain, uPhoneConfig;

var g_UpgradeTimer: TUpgradeTimer;

{ TCommonTimer }

constructor TCommonTimer.Create(const interv: Cardinal);
begin
  inherited create;
  FTimerDir := TTimer.Create(nil);
  FTimerDir.Enabled := false;
  FTimerDir.Interval := interv;
  FTimerDir.OnTimer := Timer1Timer;
end;

destructor TCommonTimer.Destroy;
begin
  FTimerDir.enabled := false;
  FTimerDir.free;
  inherited;
end;

procedure TCommonTimer.start;
begin
  self.FTimerDir.enabled := true;
end;

procedure TCommonTimer.stop;
begin
  self.FTimerDir.enabled := false;
end;

procedure TCommonTimer.Timer1Timer(Sender: TObject);
begin
  Sleep(0);
  TTimer(Sender).enabled := false;
  try
    processDir();
  finally
    TTimer(Sender).enabled := true;
  end;
  Sleep(0);
end;

{ TUpgradeTimer }

constructor TUpgradeTimer.Create();
begin
  inherited create(g_PhoneConfig.upgradeInterv * TTimeCfg.minute);
  //inherited create(20 * TTimeCfg.second);
  start;
end;

destructor TUpgradeTimer.Destroy;
begin
  inherited;
end;

procedure TUpgradeTimer.processDir;
var S: string;
begin
  S := getUpgradeInfo();
  if not S.isEmpty then begin
    frmMain.infoHintM(S);
  end;
end;

initialization
  g_UpgradeTimer := TUpgradeTimer.Create();

finalization
  g_UpgradeTimer.Free;

end.
