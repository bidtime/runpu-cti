unit uRecInf;

interface

type
  TRecInf = class
  public
    class var REC: string;
    class var CALL: string;
    class var BAD: string;
    class var LOG: string;
    class var FAIL: string;
    class var UPLOAD: string;
    //
    class var UPGRADE: string;
    class var REPACK: string;
    //
    class var RES_EXT: string;
    class var JSON_EXT: string;
    //
    class constructor create;
  end;

implementation

uses SysUtils;

{ TRecInf }

class constructor TRecInf.create;
begin
  REC:= 'rec';
  CALL:= 'call';
  BAD:= 'bad';
  FAIL := 'fail';
  UPLOAD := 'upload';
  LOG := 'log';
  UPGRADE := 'upgrade';
  REPACK := 'repack';
  //
  RES_EXT := '.wav';
  JSON_EXT := '.json';
end;

end.


