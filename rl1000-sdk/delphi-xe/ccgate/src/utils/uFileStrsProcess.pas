unit uFileStrsProcess;

interface

uses
  Classes, System.Generics.Collections, uQueueBase;

type
//  TFileStrsProcess = class
//  private
//    class procedure makeFileList(Path: string; const FileExt: string; strs: TStrings;
//      const includeSub: boolean; const maxRows:integer);
//  public
//    class procedure readStrs(Path: string; strs: TStrings); static;
//  end;
  TFileQueueProcess = class
  private
    class procedure makeFileList(Path: string; const FileExt: string; strs: TStackBase<String>;
      const includeSub: boolean; const maxRows:integer);
  public
    class procedure readStrs(Path: string; strs: TStackBase<String>); static;
    class procedure readStrsSafe(Path: string; strs: TStackBase<String>); static;
  end;

implementation

uses SysUtils, uShowMsgBase, uHttpException, forms, uLocalRemoteCallEv, uRecInf;

{ TFileDirProcess }

procedure ShowSysLog(const S: String);
begin
  g_ShowMsgBase.ShowMsg(S);
end;

//class procedure TFileStrsProcess.makeFileList(Path: string; const FileExt: string; strs: TStrings;
//      const includeSub: boolean; const maxRows:integer);
//var
//  sch: TSearchrec;
//  sFull, sExt: string;
//begin
//  //if RightStr(trim(Path), 1) <> '\' then begin
//  if not Path.EndsWith('\') then begin
//    Path := Path + '\';
//  end;
//  if not SysUtils.DirectoryExists(Path) then begin
//    exit;
//  end;
//  //
//  //if FindFirst(Path + '*', faAnyfile, sch) = 0 then begin
//  if SysUtils.FindFirst(Path + '\*.*', faAnyfile, sch) = 0 then begin
//    repeat
//      if (p_closed^) then begin
//        break;
//      end;
//      Application.ProcessMessages;
//      sleep(0);
//      if ((sch.Name = '.') or (sch.Name = '..')) then begin
//        Continue;
//      end;
//      if (maxRows>-1) and (strs.Count >= maxRows) then begin
//        break;
//      end;
//      sFull := Path + sch.Name;
//      sExt := ExtractFileExt(sFull);
//      //ShowSysLog(sFull);
//      //ShowSysLog(BoolToStr(g_closed, true) + ': ' + sFull);
//      if (includeSub) and DirectoryExists(sFull) then begin
//        MakeFileList(sFull, FileExt, strs, includeSub, maxRows);
//      //end else if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt))
//      end else if SameText(sExt, FileExt) or (FileExt='.*') then begin
//        if ((p_LocalCallEv^.callUuid + sExt) <> sch.Name) then begin
//        //if (not sch.Name.StartsWith(g_LocalCallEv.callUuid))) then begin
//          strs.Add( sFull );
//        end;
//      end;
//      //
//      Application.ProcessMessages;
//      sleep(0);
//    until SysUtils.FindNext(sch) <> 0;
//    SysUtils.FindClose(sch);
//  end;
//end;

//class procedure TFileStrsProcess.readStrs(Path: string; strs: TStrings);
//begin
//  if strs.Count<=0 then begin
//    TFileStrsProcess.MakeFileList(Path, TRecInf.JSON_EXT, strs, false, -1);
//    ShowSysLog('processDir: make list,' + format('size(%d)', [strs.Count]));
//  end else begin
//    ShowSysLog('processDir: list,' + format('size(%d)', [strs.Count]));
//  end;
//end;

class procedure TFileQueueProcess.makeFileList(Path: string; const FileExt: string; strs: TStackBase<String>;
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
          strs.put( sFull );
        end;
      end;
      //
      Application.ProcessMessages;
      sleep(0);
    until SysUtils.FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

class procedure TFileQueueProcess.readStrs(Path: string; strs: TStackBase<String>);
begin
  TFileQueueProcess.MakeFileList(Path, TRecInf.JSON_EXT, strs, false, -1);
  ShowSysLog('processDir: make list,' + format('size(%d)', [strs.Count]));
end;

class procedure TFileQueueProcess.readStrsSafe(Path: string; strs: TStackBase<String>);
begin
  if strs.Count<=0 then begin
    TFileQueueProcess.MakeFileList(Path, TRecInf.JSON_EXT, strs, false, -1);
    ShowSysLog('processDir: make list,' + format('size(%d)', [strs.Count]));
  end else begin
    ShowSysLog('processDir: list,' + format('size(%d)', [strs.Count]));
  end;
end;

end.


