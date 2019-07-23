unit uComObj;

interface

function newUUID(const rm: boolean=true): string;


implementation

uses ComObj;

{ TProcessPhoneMsg }

function newUUID(const rm: boolean): string;
var
  //AGuid: TGUID;
  sGUID: string;
begin
  sGUID := CreateClassID;
  //ShowMessage(sGUID); // 两边带大括号的Guid
  Delete(sGUID, 1, 1);
  Delete(sGUID, Length(sGUID), 1);
  //ShowMessage(sGUID); // 去掉大括号的Guid，占36位中间有减号
  //sGUID:= StringReplace(sGUID, '-', '', [rfReplaceAll]);
  //ShowMessage(sGUID); // 去掉减号的Guid，占32位
  Result := sGUID;
end;

end.


