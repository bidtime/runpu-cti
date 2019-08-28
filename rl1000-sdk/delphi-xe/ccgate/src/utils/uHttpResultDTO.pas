unit uHttpResultDTO;

interface

uses
  Classes, SysUtils, uCallRecordDTO, uUploadDTO;

type
  THttpResultDTO = class
  private
  protected
    class procedure ShowSysLog(const S: String);
  public
    class function uploadR(const url, fileName: String; const tmConn,
      tmRes: integer): TReturnDTO<TFileUpData>; static;
    class function postR<K>(const url, json: String; const tmConn,
      tmRes: integer): TReturnDTO<K>; static;
  end;

  THttpPostData = class(THttpResultDTO)
  private
  public
    class function post<K>(const url: string; const callRecDTO: TCallRecordDTO;
      const tmConn: integer; const tmUpdate: integer): boolean;
    class function postS(const url: string; const callRecDTO: TCallRecordDTO;
      const tmConn: integer; const tmUpdate: integer): boolean;
    class function postN(const url: string; const callRecDTO: TCallRecordDTO;
      const tmConn: integer; const tmUpdate: integer): boolean;
  end;

  THttpPostFile = class(THttpResultDTO)
  private
  public
    class function upload(const url, fileName: string; var recDTO: TCallRecordDTO;
      const tmConn, tmRes: integer): boolean;
  end;

implementation

uses System.JSON.Serializers, uFileRecUtils, uHttpUtils, StrUtils, windows,
  uJsonFUtils, uPhoneConfig, Forms, uShowMsgBase, uDateTimeUtils, DateUtils,
  uTimeUtils, uFileUtils, uRecInf, uLog4me, brisdklib, uLocalRemoteCallEv, uHttpException;

class procedure THttpResultDTO.ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

{ THttpResultDTO }

class function THttpResultDTO.uploadR(Const url, fileName: String;
  const tmConn: integer; const tmRes: integer): TReturnDTO<TFileUpData>;
var S: string;
  dto: TReturnDTO<TFileUpData>;
begin
  try
    S := THttpUtils.upload(url, fileName, tmConn, tmRes);
    dto := TReturnDTOUtils.DeSerialize<TFileUpData>(S);
    if dto.success then begin
      if dto.data.url.IsEmpty then begin
        ShowSysLog(format('上传文件成功: %s, fileKey为空, %s', [url, fileName]));
      end else begin
        ShowSysLog(format('上传文件成功: %s, fileKey=%s, %s', [url, dto.data.url, fileName]));
      end;
    end else begin
      ShowSysLog(format('上传文件失败: %s, %d, %s, %s ', [url, dto.code, dto.msg, fileName]));
      if (dto.code=100107) then begin
        raise THttpNoLoginException.Create('no login');
      end;
    end;
    Result := dto;
  except
    on E: THttpNoLoginException do begin
      raise THttpNoLoginException.Create(e.Message);
    end;
    on E: Exception do begin
      ShowSysLog(format('上传文件出错: %s, %s, %s', [url, fileName, e.Message]));
    end;
  end;
end;

class function THttpResultDTO.postR<K>(Const url, json: String;
  const tmConn: integer; const tmRes: integer): TReturnDTO<K>;
var S: string;
  dto: TReturnDTO<K>;
begin
  try
    S := THttpUtils.postJson(url, json, tmConn, tmRes);
    dto := TReturnDTOUtils.DeSerialize<K>(S);
    if dto.success then begin
      ShowSysLog(format('上传数据成功: %s, %s ', [url, json]));
    end else begin
      ShowSysLog(format('上传数据失败: %s, %d, %s, %s ', [url, dto.code, dto.msg, json]));
      if (dto.code=100107) then begin
        raise THttpNoLoginException.Create('no login');
      end;
    end;
    Result := dto;
  except
    on E: THttpNoLoginException do begin
      raise THttpNoLoginException.Create(e.Message);
    end;
    on E: Exception do begin
      ShowSysLog(format('上传数据出错: %s, %s, %s ', [url, e.Message, json]));
    end;
  end;
end;

{ THttpPostFile }

class function THttpPostFile.upload(const url, fileName: string;
  var recDTO: TCallRecordDTO; const tmConn, tmRes: integer): boolean;

  procedure cloneFileData(const fileData: TFileUpData);
  begin
    recDTO.fileKey := fileData.url;
    recDTO.fileName := fileData.name;
    recDTO.fileSize := fileData.size;
  end;

var
  dto: TReturnDTO<TFileUpData>;
begin
  dto := THttpPostFile.uploadR(url, fileName, tmConn, tmRes);
  if dto.success then begin
    cloneFileData(dto.data);
  end;
  Result := dto.success;
end;

{ THttpPostData }

class function THttpPostData.post<K>(const url: string; const callRecDTO: TCallRecordDTO;
  const tmConn: integer; const tmUpdate: integer): boolean;
var dto: TReturnDTO<K>;
begin
  dto := THttpPostData.postR<K>(url, callRecDTO.toBaseJson(), tmConn, tmUpdate);
  Result := dto.success;
end;

class function THttpPostData.postN(const url: string;
  const callRecDTO: TCallRecordDTO; const tmConn, tmUpdate: integer): boolean;
begin
  Result := post<Long>(url, callRecDTO, tmConn, tmUpdate);
end;

class function THttpPostData.postS(const url: string;
  const callRecDTO: TCallRecordDTO; const tmConn, tmUpdate: integer): boolean;
begin
  Result := post<String>(url, callRecDTO, tmConn, tmUpdate);
end;

end.


