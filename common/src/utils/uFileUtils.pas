unit uFileUtils;

interface

uses Classes;

type
  TFileUtils = class
  private
    class var cur_dir: string;
    { Private declarations }
    class constructor create;
    class destructor destroy;
  public
    { Public declarations }
    class function getDirOfSub(const sub: string): string; static;
    class function saveToFile(const S: string; const fName: string): boolean;
    class function loadFromFile(const fName: string): string;
    //
    class function rename(const OldName, NewName: string): boolean;
    class function copy(const OldName, NewName: string; const bFailIfExists: boolean=true): boolean;
    class function rename_force(const OldName, NewName: string): boolean;
    class function delete(const fName: string): boolean; static;
    class function exists(const fName: string): boolean; static;
    class procedure makeFileList(Path: string; const FileExt: string; strs: TStrings;
      const includeSub: boolean; const maxRows:integer=-1); overload;
    class procedure makeFileList(srcStrs: TStrings; const FileExt: string; strs: TStrings;
      const includeSub: boolean; const maxRows:integer=-1); overload;
    class procedure getFileList(Path: string; const FileExt: string;
      const includeSub: boolean; const ev: TGetStrProc); overload; static;
    class procedure getFileList(srcStrs: TStrings; const FileExt: string;
      const includeSub: boolean; const ev: TGetStrProc); overload; static;
    class function DeletePath(const mDirName: string): Boolean; { ����ɾ��ָ��Ŀ¼�Ƿ�ɹ� }
    class function DoCopyDir(sDirName, sToDirName: String): Boolean; static;
    //
    class function _removeDir(const vSrcPath, vDestPath: AnsiString; vOverwrite: Boolean=true): Boolean;
    class function _copyDir(const vSrcPath, vDestPath: AnsiString; vOverwrite: Boolean=true): Boolean;
    class function formatDir(const path: string; const Args: array of const): string; overload;
    class function formatDir(const path: string; const Args: array of const;
      const lastest: boolean): string; overload;
    class function appDir(const Args: array of const): string; overload;
    class function appDir(const sub: string): string; overload;
    class function appFile(const Args: array of const): string; overload;
    class function appFile(const sub: string): string; overload;
  end;

implementation

uses Windows, SysUtils, Forms, IOUtils;

{ TFileUtils }

class constructor TFileUtils.create;
begin
  cur_dir := ExtractFilePath(ParamStr(0));
end;

class destructor TFileUtils.destroy;
begin

end;

class function TFileUtils.delete(const fName: string): boolean;
begin
  Result := DeleteFile(PChar(fName));
end;

class function TFileUtils.exists(const fName: string): boolean;
begin
  Result := FileExists(PChar(fName));
end;

class function TFileUtils.getDirOfSub(const sub: string): string;
begin
  //Result := cur_dir + '\' + sub + '\';
  Result := formatDir(cur_dir, [sub]);
end;

class function TFileUtils.appDir(const sub: string): string;
begin
  Result := formatDir(cur_dir, [sub]);
end;

class function TFileUtils.appDir(const Args: array of const): string;
begin
  Result := formatDir(cur_dir, Args);
end;

class function TFileUtils.appFile(const sub: string): string;
begin
  Result := appFile([sub]);
end;

class function TFileUtils.appFile(const Args: array of const): string;
begin
  Result := formatDir(cur_dir, Args, false);
end;

class function TFileUtils.formatDir(const path: string; const Args: array of const): string;
begin
 Result := formatDir(path, Args, true);
end;

class function TFileUtils.formatDir(const path: string; const Args: array of const;
  const lastest: boolean): string;

  procedure argsAddStrs(strs: TStringBuilder; const Args: array of const);
  var I: integer;
    S: string;
  begin
    for I := 0 to Length(args)-1 do begin
      S := pchar(args[i].VString);
      if not S.StartsWith('\') then begin
        strs.Append('\');
      end;
      strs.Append(S);
    end;
  end;

  function lastestStr(const S: String): string;
  begin
    if lastest then begin
      if S.EndsWith('\') then begin
        Result := S;
      end else begin
        Result := S + '\';
      end;
    end else begin
      if S.EndsWith('\') then begin
        Result := S;
      end else begin
        Result := S.Substring(0, S.Length-1);
      end;
    end;
  end;

var i: integer;
  strs: TStringBuilder;
  S: string;
begin
  strs := TStringBuilder.Create;
  try
    if not path.EndsWith('\') then begin
      strs.Append(path);
    end else begin
      strs.Append(path.Substring(0, path.Length - 1));
    end;
    argsAddStrs(strs, args);
    Result := lastestStr(strs.ToString);
  finally
    strs.Free;
  end;
end;

class function TFileUtils.saveToFile(const S: string; const fName: string): boolean;
var strs: TStrings;
begin
  Result := false;
  strs := TStringList.Create();
  try
    strs.Text := S;
    try
      strs.SaveToFile(fName, TEncoding.UTF8);
      Result := true;
    except
      on e: exception do begin
      end;
    end;
  finally
    strs.Free;
  end;
end;

class function TFileUtils.loadFromFile(const fName: string): string;
var strs: TStrings;
begin
  Result := '';
  strs := TStringList.Create();
  try
    try
      strs.LoadFromFile(fName, TEncoding.UTF8);
      Result := strs.Text;
    except
      on e: exception do begin
      end;
    end;
  finally
    strs.Free;
  end;
end;

class function TFileUtils.rename_force(const OldName, NewName: string): boolean;
begin
  Result := false;
  if not FileExists(OldName) then begin
    exit;
  end;
  if FileExists(NewName) then begin
    TFileUtils.delete(NewName);
  end;
  Result := RenameFile(OldName, NewName);
end;

class procedure TFileUtils.getFileList(srcStrs: TStrings;
  const FileExt: string; const includeSub: boolean;
  const ev: TGetStrProc);
var I: integer;
begin
  for I := 0 to srcStrs.Count - 1 do begin
    getFileList(srcStrs[I], fileExt, includeSub, ev);
  end;
end;

class procedure TFileUtils.getFileList(Path: string; const FileExt: string;
  const includeSub: boolean; const ev: TGetStrProc);
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
      Application.ProcessMessages;
      sleep(0);
      if ((sch.Name = '.') or (sch.Name = '..')) then begin
        Continue;
      end;
      sFull := Path + sch.Name;
      sExt := ExtractFileExt(sFull);
      if (includeSub) and DirectoryExists(sFull) then begin
        getFileList(sFull, FileExt, includeSub, ev);
      //end else if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt))
      end else if SameText(sExt, FileExt) or (FileExt='.*') then begin
        if (Assigned(ev)) then begin
          ev(sFull);
        end;
      end;
      //
      sleep(0);
    until SysUtils.FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

class function TFileUtils.rename(const OldName, NewName: string): boolean;
begin
  Result := false;
  if not FileExists(OldName) then begin
    exit;
  end;
  Result := RenameFile(OldName, NewName);
end;

class function TFileUtils.copy(const OldName, NewName: string; const bFailIfExists: boolean): boolean;
begin
  Result := CopyFile(PChar(OldName), PChar(NewName), bFailIfExists);
end;

class procedure TFileUtils.makeFileList(srcStrs: TStrings; const FileExt: string; strs: TStrings;
  const includeSub: boolean; const maxRows:integer);
var I: integer;
begin
  for I := 0 to srcStrs.Count - 1 do begin
    makeFileList(srcStrs[I], fileExt, strs, includeSub, maxRows);
  end;
end;

class procedure TFileUtils.makeFileList(Path: string; const FileExt: string; strs: TStrings;
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
      if (includeSub) and DirectoryExists(sFull) then begin
        MakeFileList(sFull, FileExt, strs, includeSub, maxRows);
      //end else if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt))
      end else if SameText(sExt, FileExt) or (FileExt='.*') then begin
        strs.Add( sFull );
      end;
      //
      sleep(0);
    until SysUtils.FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

class function TFileUtils.DeletePath(const mDirName: string): Boolean; { ����ɾ��ָ��Ŀ¼�Ƿ�ɹ� }
var
  vSearchRec: TSearchRec;
  vPathName: string;
  K: Integer;
begin
  Result := True;
  vPathName := mDirName + '\*.*';
  K := FindFirst(vPathName, faAnyFile, vSearchRec);
  while K = 0 do begin
    Application.ProcessMessages;
    if (vSearchRec.Attr and faDirectory > 0) and
        (Pos(vSearchRec.Name, '..') = 0) then begin
      FileSetAttr(mDirName + '\' + vSearchRec.Name, faDirectory);
      Result := DeletePath(mDirName + '\' + vSearchRec.Name);
    end else if Pos(vSearchRec.Name, '..') = 0 then begin
      FileSetAttr(mDirName + '\' + vSearchRec.Name, 0);
      Result := DeleteFile(PChar(mDirName + '\' + vSearchRec.Name));
    end;
    if not Result then Break;
    //
    K := FindNext(vSearchRec);
  end;
  FindClose(vSearchRec);
  Result := RemoveDir(mDirName);
end;

class function TFileUtils.DoCopyDir(sDirName:String;sToDirName:String):Boolean;
var
  hFindFile:Cardinal;
  t,tfile:String;
  sCurDir:String[255];
  FindFileData:WIN32_FIND_DATA;
begin
  //��¼��ǰĿ¼
  sCurDir := cur_dir;
  ChDir(sDirName);
  hFindFile := FindFirstFile('*.*',FindFileData);
  if  hFindFile<>INVALID_HANDLE_VALUE   then
  begin
    if not DirectoryExists(sToDirName)   then
      ForceDirectories(sToDirName);
      repeat
        tfile:=FindFileData.cFileName;
        if  (tfile='.') or (tfile='..')  then
          Continue;
        if   FindFileData.dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY   then
        begin
          t:=sToDirName+'\'+tfile;
          if not DirectoryExists(t)  then
            ForceDirectories(t);
          if  sDirName[Length(sDirName)]<>'\'   then
            DoCopyDir(sDirName+'\'+tfile,t)
          else
            DoCopyDir(sDirName+tfile,sToDirName+tfile);
        end
        else
        begin
          t:=sToDirName+'\'+tFile;
          CopyFile(PChar(tfile),PChar(t),True);
        end;
      until   FindNextFile(hFindFile,FindFileData)=false;
              ///     FindClose(hFindFile);
  end
  else
  begin
    ChDir(sCurDir);
    result:=false;
    exit;
  end;
        //�ص���ǰĿ¼
  ChDir(sCurDir);
  result:=true;
end;

class function TFileUtils._copyDir(const vSrcPath, vDestPath: AnsiString; vOverwrite: Boolean): Boolean;
var
  r: TSearchRec;
  s, d: AnsiString;
  ns, nd: AnsiString;
begin
  try
    try
      result := false;
      s := IncludeTrailingPathDelimiter(vSrcPath);
      d := IncludeTrailingPathDelimiter(vDestPath);
      if not ForceDirectories(d) then Exit;                                   //��Ŀ��Ŀ䛟o�������r���t...
      //---- �_ʼ�f���ь��}�uĿ䛼��n��Ⱥ ------------------------------------
      if SysUtils.FindFirst(S + '\*.*', faAnyfile, r) = 0 then begin
      //if FindFirst(s   '*.*', faAnyFile, r) = 0 then begin
        repeat
          Application.ProcessMessages;
          if (r.Name <> '.') and (r.Name <> '..') then begin
            ns := s + r.Name;                                                 //��ԴĿ�·����n�����Q��
            nd := d + r.Name;                                                 //��Ŀ��Ŀ�·����n�����Q��
            if (r.Attr and faDirectory) = faDirectory then begin              //����Ŀ䛕r���t...
              if not ForceDirectories(nd) then Exit;                          //��ԇ����Ŀ��Ŀ䛡�
              _CopyDir(ns, nd, vOverwrite);                                                //������һ����Ŀ��}�u��
            end else begin
//              if FileExists(nd) and (not vOverwrite) then Continue;           //��Ŀ�ęn���������ֲ������r���t...
//              if not CopyFile(PChar(ns), PChar(nd), false) then Exit;
              try
                if TFile.Exists(nd) then begin
                  if (not vOverwrite) then begin
                    Continue;           //��Ŀ�ęn���������ֲ������r���t...
                  end else begin
                    //TFile.Delete(nd);
                    TFile.Copy(ns, nd);
                  end;
                end else begin
                  TFile.Copy(ns, nd);
                end;
              except
                on e: Exception do begin
                 result := false;
                end;
              end;
            end;
          end;
        until FindNext(r) <> 0;
        result := true;
      end;
    except
      on e: Exception do result := false;
    end;
  finally
    FindClose(r);
  end;
end;

class function TFileUtils._removeDir(const vSrcPath, vDestPath: AnsiString; vOverwrite: Boolean): Boolean;
var
  r: TSearchRec;
  s, d: AnsiString;
  ns, nd: AnsiString;
begin
  try
    try
      result := false;
      s := IncludeTrailingPathDelimiter(vSrcPath);
      d := IncludeTrailingPathDelimiter(vDestPath);
      if not ForceDirectories(d) then Exit;                                   //��Ŀ��Ŀ䛟o�������r���t...
      //---- �_ʼ�f���ь��}�uĿ䛼��n��Ⱥ ------------------------------------
      if SysUtils.FindFirst(S + '\*.*', faAnyfile, r) = 0 then begin
      //if FindFirst(s   '*.*', faAnyFile, r) = 0 then begin
        repeat
          Application.ProcessMessages;
          if (r.Name <> '.') and (r.Name <> '..') then begin
            ns := s + r.Name;                                                 //��ԴĿ�·����n�����Q��
            nd := d + r.Name;                                                 //��Ŀ��Ŀ�·����n�����Q��
            if (r.Attr and faDirectory) = faDirectory then begin              //����Ŀ䛕r���t...
              if not ForceDirectories(nd) then Exit;                          //��ԇ����Ŀ��Ŀ䛡�
              _removeDir(ns, nd, vOverwrite);                                                //������һ����Ŀ��}�u��
            end else begin
              try
                if TFile.Exists(nd) then begin
                  if (not vOverwrite) then begin
                    Continue;           //��Ŀ�ęn���������ֲ������r���t...
                  end else begin
                    TFile.Delete(nd);
                    TFile.Move(ns, nd);
                  end;
                end else begin
                  TFile.Move(ns, nd);
                end;
              except
                on e: Exception do begin
                 result := false;
                end;
              end;
//              if not TFile.Copy(PChar(ns), PChar(nd)) then begin
//                log4debug(ns + '->' + nd + ', false' );
//                Exit;
//              end else begin
//                log4debug(ns + '->' + nd + ', true' );
//                DeleteFile(PChar(ns));
//              end;
            end;
          end;
        until FindNext(r) <> 0;
        result := true;
      end;
    except
      on e: Exception do begin
       result := false;
      end;
    end;
  finally
    FindClose(r);
  end;
end;

end.


