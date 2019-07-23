unit uDateTimeUtils;

interface

type
  TDateTimeUtils = class
  private
//    class function DaysBetween(const src: string;
//      const AThen: TDateTime): Integer; overload; static;
  public
    { Public declarations }
    class function Str2Dt(const S: string): TDateTime; static;
    class function Dt2Str(const dt: TDateTime): string; static;
    class function Dt2StrDay(const dt: TDateTime): string;
    class function Now2Str(): string; static;
    class function DaysBetween(const SThen: string): Integer; overload; static;
    class function SecsBetween(const SNow, SThen: string): Integer; overload; static;
  end;

implementation

uses SysUtils, DateUtils;

{TDateTimeUtils}

class function TDateTimeUtils.SecsBetween(const SNow, SThen: string): Integer;
var ANow, AThen: TDateTime;
begin
  ANow := Str2Dt(SNow);
  AThen := Str2Dt(SThen);
  Result := DateUtils.SecondsBetween(ANow, AThen);
end;

class function TDateTimeUtils.Str2Dt(const S: string): TDateTime;
var
  fs: TFormatSettings;
begin
  fs.DateSeparator:='-';
  fs.TimeSeparator:=':';
  fs.ShortDateFormat:='yyyy-mm-dd';
  fs.ShortTimeFormat:='HH:mm:ss';
  //
  Result:= StrToDateTimeDef(S, 0, fs);
end;

class function TDateTimeUtils.DaysBetween(const SThen: string): Integer;
var AThen: TDateTime;
begin
  AThen := Str2Dt(SThen);
  Result := DateUtils.DaysBetween(now, AThen);
end;

//class function TDateTimeUtils.DaysBetween(const src: string; const AThen: TDateTime): Integer;
//var ANow: TDateTime;
//begin
//  ANow := Str2Dt(src);
//  Result := DaysBetween(ANow, AThen);
//end;

class function TDateTimeUtils.Dt2Str(const dt: TDateTime): string;
begin
  Result := formatDateTime('yyyy-MM-dd HH:mm:ss', dt);
end;

class function TDateTimeUtils.Dt2StrDay(const dt: TDateTime): string;
begin
  Result := formatDateTime('yyyy-MM-dd', dt);
end;

class function TDateTimeUtils.Now2Str(): string;
begin
  Result := Dt2Str(now);
end;

end.


