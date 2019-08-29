unit uPhoneRecFile;

interface

uses
  Classes, Messages, brisdklib, uPhoneCfgMsgBase;

type
  TPhoneRecFile = class(TPhoneCfgMsgBase)
  private
  protected
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
    //
    function startRecord(const uChnId: BRIINT32; const fileEcho: boolean;
      const fileAgc: boolean; const recFileFmt: integer; const fName: string): longint;
    function endRecord(const uChnId: BRIINT32; const quiet: boolean=false): longint;
    function getRecFileLen(const uChnId: BRIINT32): longint;
  end;

implementation

uses SysUtils, channeldata, uChannelCmd;

{ TPhoneRecFile }

constructor TPhoneRecFile.Create();
begin
  inherited create;
end;

destructor TPhoneRecFile.Destroy;
begin
  inherited;
end;

function TPhoneRecFile.endRecord(const uChnId: BRIINT32; const quiet: boolean): longint;
begin
	Result := TCallFileRec.endRecord(uChnId, ChannelStatus[uChnId].lRecFileID,
    quiet);
  ChannelStatus[uChnId].lRecFileID := -1;
end;

function TPhoneRecFile.startRecord(const uChnId: BRIINT32; const fileEcho,
  fileAgc: boolean; const recFileFmt: integer; const fName: string): longint;
begin
  endRecord(uChnId, true);
  Result := TCallFileRec.startRecord(uChnId, FPhoneConfig.fileEcho,
    FPhoneConfig.fileAgc, FPhoneConfig.recFileFormat, fName);
  ChannelStatus[uChnId].lRecFileID := Result;
end;

function TPhoneRecFile.getRecFileLen(const uChnId: BRIINT32): longint;
begin
  Result := TCallFileRec.getRecFileLen(uChnId, ChannelStatus[uChnId].lRecFileID);
end;

//function TPhoneRecFile.startRec(const uChnId: BRIINT32; const fileName: string): longint;
//const FMT_STR = '文件录音%s, handle=%d, file=%s';
//var
//  lMask: longint;
//  lFormat: longint;
//begin
//  endRec(uChnId);            // 尝试可以关闭录音
//  //
//  lMask := 0;  //RECORD_MASK_ECHO | RECORD_MASK_AGC
//  if Integer(FPhoneConfig.fileecho) > 0 then begin
//    lMask := (lMask OR RECORD_MASK_ECHO);
//  end;
//
//  if Integer(FPhoneConfig.fileagc) > 0 then begin
//    lMask := (lMask OR RECORD_MASK_AGC);
//  end;
//
//  lFormat := FPhoneConfig.recFileFormat;
//  ChannelStatus[uChnId].lRecFileID :=
//    CPC_RecordFile(uChnId, CPC_RECORD_FILE_START, lFormat,
//      lMask, BRIPCHAR8(AnsiString(fileName)));
//  Result := ChannelStatus[uChnId].lRecFileID;
//  if Result <= 0 then begin
//    ShowMsg(uChnId, format(FMT_STR, ['出错', Result, fileName]));
//  end else begin
//    ShowMsg(uChnId, format(FMT_STR, ['开始', Result, fileName]));
//  end;
//end;

end.


