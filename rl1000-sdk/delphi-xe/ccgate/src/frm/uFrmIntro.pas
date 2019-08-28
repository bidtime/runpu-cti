unit uFrmIntro;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, jpeg;

type
  TfrmIntro = class(TForm)
    gbTitle: TGroupBox;
    Memo1: TMemo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
      class procedure showNewForm(Owner: TComponent);
  end;

implementation

uses ShellApi, uVerInfo, uPhoneConfig;

{$R *.DFM}

constructor TfrmIntro.Create(AOwner: TComponent);
begin
  inherited;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'intro.txt') then begin
    self.memo1.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'intro.txt', TEncoding.UTF8);
  end;
end;

destructor TfrmIntro.Destroy;
begin

  inherited;
end;

class procedure TfrmIntro.showNewForm(Owner: TComponent);
var frm: TfrmIntro;
begin
  frm := TfrmIntro.create(Owner);
  try
    frm.ShowModal();
  finally
    if Assigned(frm) then begin
      frm.Hide;
      frm.Free;
    end;
  end;
end;

end.
