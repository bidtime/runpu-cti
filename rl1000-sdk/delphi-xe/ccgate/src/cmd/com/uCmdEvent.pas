unit uCmdEvent;

interface

type
  TGetObjectFuncEvent = function(Sender: TObject):TObject of object;
  TGetFunStrProc = function(const S: string): string of object;
  TGetStrObject = function(Sender: TObject): string of object;
  TGetBooleanFuncEvent = function(Sender: TObject):boolean of object;
  TGetBooleanStrEvent = function(const S: string):boolean of object;
  //TGetBoolean2FuncEvent = function(Sender: TObject; Sender2: TObject):boolean of object;
  TGetIntegerFuncEvent = function(Sender: TObject):integer of object;

implementation

end.

