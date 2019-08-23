unit uMyThread;

interface

uses
  System.Classes, Winapi.Windows;

type
  //PBoolean         = ^Boolean;        {$NODEFINE PBoolean}       { defined in sysmac.h }

  TFuncSendEvent = function(const t: Boolean): boolean of object;

  TMyThread = class(TThread)
  protected
    FFirstTm, FBreakTm: DWORD;
    FFuncSendEvent: TFuncSendEvent;
    procedure Execute; override;
  public
    constructor Create(const bkTm: DWORD=0); overload;
    constructor Create(const fstTm: DWORD; const bkTm: DWORD); overload;
    property FuncSendEvent: TFuncSendEvent read FFuncSendEvent write FFuncSendEvent;
    property FirstTm: DWORD read FFirstTm write FFirstTm;
    property BreakTm: DWORD read FBreakTm write FBreakTm;
  end;

implementation

uses uLog4me, Winapi.Messages, System.SysUtils, System.Variants, Forms;

{ TMyThread }

constructor TMyThread.Create(const bkTm: DWORD);
begin
  self.create(0, bkTm);
end;

constructor TMyThread.Create(const fstTm: DWORD; const bkTm: DWORD);
begin
  inherited Create(True);
  FreeOnTerminate := false;
  FFirstTm := fstTm;
  FBreakTm := bkTm;
end;

//constructor TMyThread.Create;
//begin
//  inherited Create(True);
//  FreeOnTerminate := True;
//  FFirstTm := 0;
//  FBreakTm := 0;
//end;

procedure TMyThread.Execute;
  {procedure delay(dwMilliseconds: DWORD);//Longint
  var
    Tick: DWord;
    Event: THandle;
  begin
    Event := CreateEvent(nil, False, False, nil);
    try
      Tick := GetTickCount + dwMilliseconds;
      while (dwMilliseconds > 0) and
        (MsgWaitForMultipleObjects(1, Event, False, dwMilliseconds, QS_ALLINPUT) <> WAIT_TIMEOUT) do
      begin
        if (Terminated) then begin
          break;
        end;
        Application.ProcessMessages;
        dwMilliseconds := Tick - GetTickcount;
      end;
    finally
      CloseHandle(Event);
    end;
  end;}

  procedure Delay(dwMilliseconds:DWORD);//Longint
  var
    iStart, iStop:DWORD;
  begin
    iStart := GetTickCount;
    repeat
      if (Terminated) then begin
        break;
      end;
      iStop := GetTickCount;
      Sleep(0);
      Application.ProcessMessages;
    until (iStop - iStart) >= dwMilliseconds;
  end;

begin
  //delay(0);
  //上述循环也可以改为
  while (not Terminated) do begin
    //Inc(totalCount);
    //Writeln('第' + IntToStr(totalCount) + '次循环 @' + FormatDateTime('yyyy-MM-dd HH:mm:ss', Now));
    //Sleep(500);
    if not FuncSendEvent(Terminated) then begin
      break;
    end;
    //Sleep(10);
    //Application.ProcessMessages;
    //delay(FBreakTm);
  end;
end;

end.
