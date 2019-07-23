unit uCallLogUtils;

interface

uses
  brisdklib, uLocalRemoteCallEv;

type
  TCallLogUtils = class
  private
    class function SIncSecs(const secs: longint): string; static;
  public
    //class procedure cloneLogInfo(const r: TCallLogInf; var u: TLocalRemoteCallEv); static;
    class function IncSecs(const secs: longint): TDateTime;
    class function getNowDay(const dt: TDateTime;
      const secs: longint): TDateTime; static;
    class function SecBetween(const strNow: string): longint; overload; static;
    class function SecBetween(const dtNow: TDateTime): longint; overload; static;
  end;

implementation

uses Windows, DateUtils, uDateTimeUtils;

{ TCallLogUtils }

const BOX_BEGIN_TIME = '1970-01-01 08:00:00';

class function TCallLogUtils.getNowDay(const dt: TDateTime; const secs: longint): TDateTime;
begin
  Result := DateUtils.IncSecond(dt, secs);
end;

class function TCallLogUtils.IncSecs(const secs: longint): TDateTime;
var dt_19700101: TDateTime;
begin
  dt_19700101 := TDateTimeUtils.Str2Dt(BOX_BEGIN_TIME);
  Result := DateUtils.IncSecond(dt_19700101, secs);
end;

class function TCallLogUtils.SecBetween(const dtNow: TDateTime): longint;
var dt_19700101: TDateTime;
begin
  dt_19700101 := TDateTimeUtils.Str2Dt(BOX_BEGIN_TIME);
  Result := DateUtils.SecondsBetween(dtNow, dt_19700101);
end;

class function TCallLogUtils.SecBetween(const strNow: string): longint;
var dtNow: TDateTime;
begin
  dtNow := TDateTimeUtils.Str2Dt(BOX_BEGIN_TIME);
  Result := SecBetween(dtNow);
end;

class function TCallLogUtils.SIncSecs(const secs: longint): string;
var dt: TDateTime;
begin
  dt := IncSecs(secs);
  Result := TDateTimeUtils.Dt2Str(dt);
end;

{class procedure TCallLogUtils.cloneLogInfo(const r: TCallLogInf; var u: TLocalRemoteCallEv);
begin
  u.callResult := r.callResult;
  u.durationSeconds := TDateTimeUtils.SecsBetween(u.finishedTime, u.establishedTime);
  u.totalSeconds := TDateTimeUtils.SecsBetween(u.finishedTime, u.startTime);
end;}
{begin
  u.call_type := r.callType;
  u.callResult := r.callResult;
  //
  if r.beginTime>0 then begin
    u.startTime := SIncSecs(r.beginTime);
    if r.ringBackTime>0 then begin
      u.ringTime := SIncSecs(r.ringBackTime);
    end;
    if (r.connectedTime>0) then begin
      u.establishedTime := SIncSecs(r.connectedTime);
    end else begin
      u.establishedTime := u.ringTime;
    end;
    if (r.endTime>0) then begin
      u.finishedTime := SIncSecs(r.endTime);
    end;
  end;
  //
  u.durationSeconds := TDateTimeUtils.SecsBetween(u.finishedTime, u.establishedTime);
  u.totalSeconds := TDateTimeUtils.SecsBetween(u.finishedTime, u.startTime);
end;}

end.


