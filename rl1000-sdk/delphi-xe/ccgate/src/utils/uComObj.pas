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
  //ShowMessage(sGUID); // ���ߴ������ŵ�Guid
  Delete(sGUID, 1, 1);
  Delete(sGUID, Length(sGUID), 1);
  //ShowMessage(sGUID); // ȥ�������ŵ�Guid��ռ36λ�м��м���
  //sGUID:= StringReplace(sGUID, '-', '', [rfReplaceAll]);
  //ShowMessage(sGUID); // ȥ�����ŵ�Guid��ռ32λ
  Result := sGUID;
end;

end.


