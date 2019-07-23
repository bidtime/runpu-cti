unit uFileRecUtils;

interface

uses Classes;

type
  TFileRecUtils = class
  private
    { Private declarations }
  public
    { Public declarations }
    class function getDirOfSub(const sub: string): string; static;
    class function getDirOfRec(): string; overload;
    class function getDirOfRec(const sub: string): string; overload;
    //
    class function mergeFileJson(const uuid: string): string; static;
    class function mergeFileRes(const uuid: string): string; static;
    class constructor create;
    class destructor destroy;
  end;

implementation

uses Windows, SysUtils, uFileUtils, uRecInf;

{ TFileRecUtils }

class constructor TFileRecUtils.create;
begin
  // init dir
  ForceDirectories(TFileRecUtils.getDirOfRec(TRecInf.BAD));
  ForceDirectories(TFileRecUtils.getDirOfRec(TRecInf.CALL));
  ForceDirectories(TFileRecUtils.getDirOfRec(TRecInf.FAIL));
  ForceDirectories(TFileRecUtils.getDirOfRec(TRecInf.UPLOAD));
  //
  ForceDirectories(TFileRecUtils.getDirOfSub(TRecInf.LOG));
end;

class destructor TFileRecUtils.destroy;
begin
end;

class function TFileRecUtils.getDirOfSub(const sub: string): string;
begin
  Result := TFileUtils.getDirOfSub(sub);
end;

class function TFileRecUtils.getDirOfRec(): string;
begin
  Result := TFileUtils.getDirOfSub( TRecInf.REC );
end;

class function TFileRecUtils.getDirOfRec(const sub: string): string;
begin
  Result := getDirOfRec() + sub + '\';
end;

class function TFileRecUtils.mergeFileJson(const uuid: string): string;
begin
  Result := TFileRecUtils.getDirOfRec(TRecInf.CALL) + uuid + TRecInf.JSON_EXT;
end;

class function TFileRecUtils.mergeFileRes(const uuid: string): string;
begin
  Result := TFileRecUtils.getDirOfRec(TRecInf.CALL) + uuid + TRecInf.RES_EXT;
end;

end.


