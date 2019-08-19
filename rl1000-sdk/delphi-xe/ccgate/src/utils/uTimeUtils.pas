unit uTimeUtils;

interface

uses windows;

  //procedure delay1(ms: DWORD); //�ӳٺ��� ��sleep��
  procedure delay2(const dwMilliseconds: DWORD); overload; //Longint
  procedure delaySec(const sec: DWORD); overload; //�ӳٺ��� ��sleep��

  procedure delay2(const dwMilliseconds: DWORD; const bclosed: boolean); overload; //Longint
  procedure delaySec(const sec: DWORD; const bClosed: boolean); overload; //�ӳٺ��� ��sleep��

implementation

uses Forms;

//procedure delay1(ms: DWORD); //�ӳٺ��� ��sleep��
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

procedure delay2(const dwMilliseconds: DWORD);//Longint
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
end;

procedure delaySec(const sec: DWORD); //�ӳٺ��� ��sleep��
begin
  delay2(sec * 1000);
end;

procedure delay2(const dwMilliseconds: DWORD; const bclosed: boolean);//Longint
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
    if bClosed then begin
      break;
    end;
    iStop := GetTickCount;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
end;

procedure delaySec(const sec: DWORD; const bclosed: boolean); //�ӳٺ��� ��sleep��
begin
  delay2(sec * 1000, bClosed);
end;

end.
