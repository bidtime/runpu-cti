unit uTimeUtils;

interface

uses windows;

  //procedure delay1(ms: DWORD); //延迟函数 比sleep好
  procedure delay2(dwMilliseconds: DWORD); overload; //Longint
  procedure delaySec(sec: DWORD); overload; //延迟函数 比sleep好

  procedure delay2(dwMilliseconds: DWORD; const bclosed: boolean); overload; //Longint
  procedure delaySec(sec: DWORD; const bClosed: boolean); overload; //延迟函数 比sleep好

implementation

uses Forms;

//procedure delay1(ms: DWORD); //延迟函数 比sleep好
//var
//  Tick: DWord;
//  Event: THandle;
//begin
//  Event := CreateEvent(nil, False, False, nil);
//  try
//    Tick := GetTickCount + ms;
//    while (ms > 0) and (MsgWaitForMultipleObjects(1, Event, False, ms,
//        QS_ALLINPUT) <> WAIT_TIMEOUT) do begin
//      Application.ProcessMessages;
//      ms := Tick - GetTickcount;
//    end;
//  finally
//    CloseHandle(Event);
//  end;
//end;

procedure delay2(dwMilliseconds: DWORD);//Longint
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
      Application.ProcessMessages;
      dwMilliseconds := Tick - GetTickcount;
    end;
  finally
    CloseHandle(Event);
  end;
end;
{var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
    Application.ProcessMessages;
    //Sleep(10);
    Application.ProcessMessages;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
end;}

procedure delaySec(sec: DWORD); //延迟函数 比sleep好
begin
  delay2(sec * 1000);
end;

procedure delay2(dwMilliseconds: DWORD; const bclosed: boolean);//Longint
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
      if bClosed then begin
        break;
      end;
      Application.ProcessMessages;
      dwMilliseconds := Tick - GetTickcount;
    end;
  finally
    CloseHandle(Event);
  end;
end;
{var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    if bClosed then begin
      break;
    end;
    iStop := GetTickCount;
    Application.ProcessMessages;
    Application.ProcessMessages;
    //Sleep(10);
    Application.ProcessMessages;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
end;}

procedure delaySec(sec: DWORD; const bclosed: boolean); //延迟函数 比sleep好
begin
  delay2(sec * 1000, bClosed);
end;

end.
