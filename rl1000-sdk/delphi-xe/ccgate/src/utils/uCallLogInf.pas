unit uCallLogInf;

interface

uses
  brisdklib;

type
  {TCallRstInf = record
  public
    beginTime: longint;
    endTime: longint;
    ringBackTime: longint;
    connectedTime: longint;
    callType: integer;
    callResult: integer;
    //callId: string;
    function toJson: string;
  end;}

  TCallLogInf = record
  public
    //beginTime: longint;
    //endTime: longint;
    //ringBackTime: longint;
    //connectedTime: longint;
    callType: integer;
    callResult: integer;
  end;

implementation

//uses Windows, SysUtils, uJsonSUtils;

{ TCallRstInf }

//function TCallRstInf.toJson: string;
//begin
//  Result := TJsonSUtils.Serialize(self);
//end;

end.


