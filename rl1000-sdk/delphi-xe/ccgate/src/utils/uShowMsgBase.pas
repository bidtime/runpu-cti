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
    procedure ShowMsg(const S: String; const logD: boolean=false); overload;
    procedure ShowMsg(const S: String; const addQueue: boolean; const logD: boolean); overload;
    procedure ShowMsgQ(const S: String);
    procedure ShowMsg(const uChnId: BRIINT32; const S: String; const logD: boolean=false); overload;
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

procedure TShowMsgBase.ShowMsg(const S: String; const addQueue: boolean; const logD: boolean);
begin
  if Assigned(FOnShowLogs) then begin
    FOnShowLogs(S, addQueue, logD);
  end;
end;

procedure TShowMsgBase.ShowMsg(const S: String; const logD: boolean);
begin
  self.ShowMsg(S, false, logD);
end;

procedure TShowMsgBase.ShowMsgQ(const S: String);
begin
  self.ShowMsg(S, true, false);
end;

function TShowMsgBase.fmtMsg(const uChnId: BRIINT32; const S: String): string;
begin
  Result := 'ͨ��' + IntToStr(uChnId) + ', ' + S;
end;

procedure TShowMsgBase.ShowMsg(const uChnId: BRIINT32; const S: String; const logD: boolean);
begin
  self.ShowMsg(fmtMsg(uChnId, S), logD);
end;

initialization
  g_ShowMsgBase := TShowMsgBase.Create();

finalization
  g_ShowMsgBase.Free;

end.


