unit uFrmUrlParam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TframeUrlParam = class(TFrame)
    memoCtx: TMemo;
    edtUrl: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
