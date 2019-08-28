unit uFileStrsProcess;

interface

uses
  Classes, SysUtils, ExtCtrls, uCallRecordDTO, uUploadDTO;

type
  TFileStrsProcess = class
  private
    //FFileSize: integer;
    //FStrsDir: TStrings;
    //FSubDir: string;
    class procedure makeFileList(Path: string; const FileExt: string; strs: TStrings;
      const includeSub: boolean; const maxRows:integer);
  public
    constructor Create();
    destructor Destroy; override;
    //
    class procedure readStrs(Path: string; strs: TStrings); static;
    //function readFiles(strs: TStrings): boolean;
    //class procedure readStrs(Path: string; strs: TStrings);
    //property SubDir: string read FSubDir write FSubDir;
    //property StrsDir: TStrings read FStrsDir write FStrsDir;
  end;

implementation

uses System.JSON.Serializers, uFileRecUtils, uHttpUtils, StrUtils, windows,
  uJsonFUtils, uPhoneConfig, Forms, uShowMsgBase, uDateTimeUtils, DateUtils,
  uTimeUtils, uFileUtils, uRecInf, uLog4me, brisdklib, uLocalRemoteCallEv,
  uHttpException, uHttpResultDTO;

{ TFileDirProcess }

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

constructor TFileStrsProcess.Create;
begin
  //FFileSize := -1;
  //FStrsDir := TStringList.create;
end;

destructor TFileStrsProcess.Destroy;
begin
  //FStrsDir.Free;
  inherited;
end;

class procedure TFileStrsProcess.makeFileList(Path: string; const FileExt: string; strs: TStrings;
      const includeSub: boolean; const maxRows:integer);
var
  sch: TSearchrec;
  sFull, sExt: string;
begin
  //if RightStr(trim(Path), 1) <> '\' then begin
  if not Path.EndsWith('\') then begin
    Path := Path + '\';
  end;
  if not SysUtils.DirectoryExists(Path) then begin
    exit;
  end;
  //
  //if FindFirst(Path + '*', faAnyfile, sch) = 0 then begin
  if SysUtils.FindFirst(Path + '\*.*', faAnyfile, sch) = 0 then begin
    repeat
      if (p_closed^) then begin
        break;
      end;
      Application.ProcessMessages;
      sleep(0);
      if ((sch.Name = '.') or (sch.Name = '..')) then begin
        Continue;
      end;
      if (maxRows>-1) and (strs.Count >= maxRows) then begin
        break;
      end;
      sFull := Path + sch.Name;
      sExt := ExtractFileExt(sFull);
      //ShowSysLog(sFull);
      //ShowSysLog(BoolToStr(g_closed, true) + ': ' + sFull);
      if (includeSub) and DirectoryExists(sFull) then begin
        MakeFileList(sFull, FileExt, strs, includeSub, maxRows);
      //end else if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt))
      end else if SameText(sExt, FileExt) or (FileExt='.*') then begin
        if ((p_LocalCallEv^.callUuid + sExt) <> sch.Name) then begin
        //if (not sch.Name.StartsWith(g_LocalCallEv.callUuid))) then begin
          strs.Add( sFull );
        end;
      end;
      //
      Application.ProcessMessages;
      sleep(0);
    until SysUtils.FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

{function TFileStrsProcess.readFiles(strs: TStrings): boolean;
begin
  if FStrsDir.Count<=0 then begin
    readStrs(self.FSubDir, self.FStrsDir);
    Result := true;
  end else begin
    Result := false;
  end;
end;}

class procedure TFileStrsProcess.readStrs(Path: string; strs: TStrings);
begin
  if strs.Count<=0 then begin
    TFileStrsProcess.MakeFileList(Path, TRecInf.JSON_EXT, strs, false, -1);
    ShowSysLog('processDir: make list,' + format('size(%d)', [strs.Count]));
  end else begin
    ShowSysLog('processDir: list,' + format('size(%d)', [strs.Count]));
  end;
end;

end.


