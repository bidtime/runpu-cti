unit uPhoneRecFileAuto;

interface

uses
  Classes, Messages, brisdklib, uPhoneConfig, uPhoneRecFile;

type
  TPhoneRecFileAuto = class(TPhoneRecFile)
  private
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
    //
    function autoEndRec(const uChnId: BRIINT32; const fName, msg: string): longint;
    function autosaveRec(const uChnId: BRIINT32; const fName, msg: string): longint;
  end;

implementation

uses SysUtils, StrUtils;

{ TPhoneRecFileAuto }

constructor TPhoneRecFileAuto.Create();
begin
  inherited create;
end;

destructor TPhoneRecFileAuto.Destroy;
begin
  inherited;
end;

function TPhoneRecFileAuto.autosaveRec(const uChnId: BRIINT32; const fName, msg: string): longint;
begin
  if FPhoneConfig.AutoCallRec then begin
    Result := inherited startRecord(uChnId, FPhoneConfig.fileEcho,
        FPhoneConfig.fileAgc, FPhoneConfig.recFileFormat, fName);
    ShowMsg(uChnId, format('开始录音文件%s, %d, %s, %s',
      [IfThen(Result>0, '成功', '失败'), Result, msg, fName]));
  end else begin
    Result := 0;
  end;
end;

function TPhoneRecFileAuto.autoEndRec(const uChnId: BRIINT32; const fName, msg: string): longint;
begin
  if FPhoneConfig.AutoCallRec then begin
    Result := inherited endRecord(uChnId);
    ShowMsg(uChnId, format('停止录音文件%s, %d, %s, %s',
      [IfThen(Result>0, '成功', '失败'), Result, msg, fName]));
  end else begin
    Result := 0;
  end;
end;

end.



