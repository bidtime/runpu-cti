unit uMyHttpServer;

interface

uses
  Classes, uHttpServerBase, IdCustomHTTPServer, IdContext;

type
  TMyHttpServer = class(THttpServerBase)
  private
  protected
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo:
    TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo); override;
  public
    { Public declarations }
    constructor Create();
    destructor Destroy; override;
  end;

implementation

uses SysUtils;

{ TMyHttpServer }

constructor TMyHttpServer.Create;
begin
  inherited;
end;

destructor TMyHttpServer.Destroy;
begin
  inherited;
end;

procedure TMyHttpServer.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo:
    TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var dt: string;
begin
  //��html�ļ�
  AResponseInfo.ContentEncoding:='utf-8';
  AResponseInfo.ContentType :='text/html';
  dt := FormatDateTime('yyyy-MM-dd hh:mm:ss', Now);
  AResponseInfo.ContentText:='<html><body>' +
    '��Ӧ��'+ '<br>' +
    '&nbsp;&nbsp;' + '��ã�' + '<br>' +
    '&nbsp;&nbsp;' + dt + '<br>' +
    '&nbsp;&nbsp;' + ARequestInfo.Document + '<br>' +
    //
    '</body></html>';
end;

end.
