unit uShowMsgBase;

interface

uses
  Classes, brisdklib;

type
  TShowLogQueue = procedure(const S: String; const addQueue: boolean;
    const attachLog: boolean) of object;
  TShowMsgBase = class(TObject)
  private
  protected
    FOnShowLogs: TShowLogQueue;
    //
    procedure setOnShowLogs(const evShowLogs: TShowLogQueue); virtual;
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
    //
    //procedure ShowMsgQ(const uChnId: BRIINT32; const S: String); overload;
    procedure ShowMsg(const S: String; const attachLog: boolean=false); overload;
    procedure ShowMsg(const S: String; const addQueue: boolean; const attachLog: boolean); overload;
    procedure ShowMsgQ(const S: String; const attachLog: boolean=false); overload;
    procedure ShowMsg(const uChnId: BRIINT32; const S: String; const attachLog: boolean=false); overload;
    function fmtMsg(const uChnId: BRIINT32; const S: String): string;
    //
    property OnShowLogs: TShowLogQueue read FOnShowLogs write setOnShowLogs;
  end;

var g_ShowMsgBase: TShowMsgBase;

implementation

uses SysUtils, uFormatMsg, uLogFile;

{ TShowMsgBase }

constructor TShowMsgBase.Create();
begin
  inherited create;
end;

destructor TShowMsgBase.Destroy;
begin
  inherited;
end;

procedure TShowMsgBase.setOnShowLogs(const evShowLogs: TShowLogQueue);
begin
  self.FOnShowLogs := evShowLogs;
end;

procedure TShowMsgBase.ShowMsg(const S: String; const addQueue: boolean; const attachLog: boolean);
begin
  if Assigned(FOnShowLogs) then begin
    FOnShowLogs(S, addQueue, attachLog);
  end;
end;

procedure TShowMsgBase.ShowMsg(const S: String; const attachLog: boolean);
begin
  self.ShowMsg(S, false, attachLog);
end;

procedure TShowMsgBase.ShowMsgQ(const S: String; const attachLog: boolean);
begin
  self.ShowMsg(S, true, false);
end;

function TShowMsgBase.fmtMsg(const uChnId: BRIINT32; const S: String): string;
begin
  Result := 'Í¨µÀ' + IntToStr(uChnId) + ', ' + S;
end;

procedure TShowMsgBase.ShowMsg(const uChnId: BRIINT32; const S: String; const attachLog: boolean);
begin
  self.ShowMsg(fmtMsg(uChnId, S), attachLog);
end;

initialization
  g_ShowMsgBase := TShowMsgBase.Create();

finalization
  g_ShowMsgBase.Free;

end.


