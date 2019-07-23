unit uRegUtils;

interface

uses Windows;

type

  TRegUtils = class
  private
    class function writeUserRunKey(const key, value: string): boolean; static;
    class function readUserRunKey(const key: string): string; static;
    class function deleteUserRunKey(const key: string): boolean; static;
  public
    { Public declarations }
    class function isAutoRun(): boolean; static;
    class function setAutoRun(const autoRun: boolean): boolean; static;
 end;

implementation

uses SysUtils, Registry;

{ TRegUtils }

const CCGATE_KEY = 'ytccgate';
const WIN_RUN_KEY = 'Software\Microsoft\Windows\CurrentVersion\Run';

class function TRegUtils.isAutoRun: boolean;
var pathExe, regExe: string;
begin
  Result := false;
  pathExe := ExpandFileName(ParamStr(0));
  regExe := readUserRunKey(CCGATE_KEY);
  if not regExe.IsEmpty then begin
    if regExe.Equals(pathExe) then begin
      Result := true;
    end;
  end;
end;

class function TRegUtils.readUserRunKey(const key: string): string;
var
 Reg: TRegistry;       //首先定义一个TRegistry类型的变量Reg
begin
  Reg := TRegistry.Create;
  try                           //创建一个新键
    Reg.LazyWrite := false;
    Reg.RootKey := HKEY_CURRENT_USER;     //将根键设置为 HKEY_CURRENT_USER
    if Reg.openkey(WIN_RUN_KEY, false) then begin //打开一个键
      Result := Reg.ReadString(CCGATE_KEY);           //在Reg这个键中写入数据名称和数据数值
    end;
    Reg.CloseKey;       //关闭键
  finally
    Reg.Free;
  end;
end;

class function TRegUtils.setAutoRun(const autoRun: boolean): boolean;
begin
  if autoRun then begin
    writeUserRunKey(CCGATE_KEY, ExpandFileName(ParamStr(0)));
  end else begin
    deleteUserRunKey(CCGATE_KEY);
  end;
end;

class function TRegUtils.writeUserRunKey(const key, value: string): boolean;
var
 Reg: TRegistry;       //首先定义一个TRegistry类型的变量Reg
begin
  Reg := TRegistry.Create;
  try                           //创建一个新键
    Reg.LazyWrite := false;
    Reg.RootKey := HKEY_CURRENT_USER;     //将根键设置为 HKEY_CURRENT_USER
    if Reg.OpenKey(WIN_RUN_KEY, true) then begin//打开一个键
      Reg.WriteString(key, value);           //在Reg这个键中写入数据名称和数据数值
    end;
    Reg.CloseKey;       //关闭键
  finally
    Reg.Free;
  end;
end;

class function TRegUtils.deleteUserRunKey(const key: string): boolean;
var
 Reg: TRegistry;       //首先定义一个TRegistry类型的变量Reg
 b: boolean;
begin
  Reg := TRegistry.Create;
  try                           //创建一个新键
    Reg.LazyWrite := false;
    Reg.RootKey := HKEY_CURRENT_USER;     //将根键设置为 HKEY_CURRENT_USER
    if Reg.OpenKey(WIN_RUN_KEY, false) then begin //打开一个键
      Reg.WriteString(key, '');           //在Reg这个键中写入数据名称和数据数值
      Reg.DeleteValue(Reg.ReadString(key));
    end;
    Reg.CloseKey;       //关闭键
  finally
    Reg.Free;
  end;
end;

end.

