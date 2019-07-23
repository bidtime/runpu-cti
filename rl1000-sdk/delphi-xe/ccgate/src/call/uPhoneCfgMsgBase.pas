unit uPhoneCfgMsgBase;

interface

uses
  Classes, Messages, uPhoneConfig, uShowMsgBase;

type
  TPhoneCfgMsgBase = class(TShowMsgBase)
  private
  protected
    FPhoneConfig: TPhoneConfig;
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
    //
    property PhoneConfig: TPhoneConfig read FPhoneConfig write FPhoneConfig;
  end;

implementation

uses SysUtils;

{ TPhoneCfgMsgBase }

constructor TPhoneCfgMsgBase.Create();
begin
  inherited create;
end;

destructor TPhoneCfgMsgBase.Destroy;
begin
  inherited;
end;

end.


