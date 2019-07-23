unit uEventTypeMap;

interface

uses
  Generics.Collections, brisdklib;

type
  TEventTypeMap = class
  private
    FMap: TDictionary<BRIINT32, string>;
    procedure addEvent(Map: TDictionary<BRIINT32, string>);
  protected
    function getEventName(const id: BRIINT32): string;
  public
    constructor Create();
    destructor Destroy; override;
    class function getEvent(const id: BRIINT32): string; static;
    //class function fmtInfo(const evData: TBriEvent_Data): string;
    class function getDevErr(const lErrorId: longint): string; static;
  end;

var
  gEventTypeMap: TEventTypeMap;

implementation

{ TEventTypeMap }

constructor TEventTypeMap.create;
begin
  inherited;
  FMap := TDictionary<BRIINT32, string>.create;
  addEvent(FMap);
end;

destructor TEventTypeMap.Destroy;
begin
  FMap.Free;
  inherited;
end;

{class function TEventTypeMap.fmtInfo(const evData: TBriEvent_Data): string;
const FMT_STR = 'channl=%d, tName=%s, tId=%d'
  + ', handle=%d, result=%d, param=%d'
  + ', szData=%s, szDataEx=%s'
  + ', linehook=%d, linefree=%d'
  ;
begin
  Result := format(FMT_STR, [evData.uChannelID
    , TEventTypeMap.getEvent(evData.lEventType), evData.lEventType
    , evData.lEventHandle, evData.lResult, evData.lParam
    , toStr(evData.szData), toStr(evData.szDataEx)
    , QNV_General(evData.uChannelID, QNV_GENERAL_ISLINEHOOK, 0, 0)
    , QNV_General(evData.uChannelID, QNV_GENERAL_ISLINEFREE, 0, 0)
  ]);
end;}

class function TEventTypeMap.getDevErr(const lErrorId : longint): string;
var S: string;
begin
  case lErrorId of
    0: begin
      S := '��ȡ���ݴ���';
    end;
    1: begin
      S := 'д�����ݴ���';
    end;
    2: begin
      S := '����֡ID��ʧ,������CPU̫æ';
    end;
    3: begin
      S := '�豸�Ѿ����ε�';
    end;
    4: begin
      S := '���кų�ͻ';
    end;
    else begin
      S := 'δ֪����';
    end;
  end;
  Result := S;
end;

function TEventTypeMap.getEventName(const id: BRIINT32): string;
begin
  if not FMap.tryGetValue(id, Result) then begin
    Result := 'ϵͳ�����¼�';
  end;
end;

class function TEventTypeMap.getEvent(const id: BRIINT32): string;
begin
  Result := gEventTypeMap.getEventName(id);
end;

procedure TEventTypeMap.addEvent(Map: TDictionary<BRIINT32, string>);
begin
  // ���ص绰��ժ���¼�
  //const	BriEvent_PhoneHook				=1;
  map.add(BriEvent_PhoneHook, '���ص绰��ժ���¼�');

  // ���ص绰���һ��¼�
  //const BriEvent_PhoneHang				=2;
  map.add(BriEvent_PhoneHang, '���ص绰���һ��¼�');

  // ����ͨ�����������¼�
  // BRI_EVENT.lResult		Ϊ�������
  // BRI_EVENT.szData[0]='0'	��ʼ1������
  // BRI_EVENT.szData[0]='1'	Ϊ1��������ɣ���ʼ4�뾲��
  //const BriEvent_CallIn					=3;
  map.add(BriEvent_CallIn, '����ͨ�����������¼�');

  // �õ��������
  // BRI_EVENT.lResult		�������ģʽ(CALLIDMODE_FSK/CALLIDMODE_DTMF
  // BRI_EVENT.szData		������������
  // ���¼�����������ǰ,Ҳ�����������
  //const BriEvent_GetCallID				=4;
  map.add(BriEvent_GetCallID, '�õ��������');

  // �Է�ֹͣ����(����һ��δ�ӵ绰)
  //const BriEvent_StopCallIn				=5;
  map.add(BriEvent_StopCallIn, '�Է�ֹͣ����(����һ��δ�ӵ绰)');

  // ���ÿ�ʼ���ź�ȫ�����벦�Ž���
  //nst BriEvent_DialEnd				        =6;
  map.add(BriEvent_DialEnd, '���ÿ�ʼ���ź�ȫ�����벦�Ž���');

  // �����ļ������¼�
  // BRI_EVENT.lResult	   �����ļ�ʱ���صľ��ID
  //nst BriEvent_PlayFileEnd			        =7;
  map.add(BriEvent_PlayFileEnd, '�����ļ������¼�');

  // ���ļ����������¼�
  //const BriEvent_PlayMultiFileEnd		                =8;
  map.add(BriEvent_PlayMultiFileEnd, '���ļ����������¼�');

  //�����ַ�����
  //const	BriEvent_PlayStringEnd			        =9;
  map.add(BriEvent_PlayStringEnd, '�����ַ�����');

  // �����ļ�����׼���ظ�����
  // BRI_EVENT.lResult	   �����ļ�ʱ���صľ��ID
  //const BriEvent_RepeatPlayFile			        =10;
  map.add(BriEvent_RepeatPlayFile, '�����ļ�����׼���ظ�����');

  // �������豸���������ź�ʱ���ͺ������
  //const BriEvent_SendCallIDEnd			        =11;
  map.add(BriEvent_SendCallIDEnd, '�������豸���������ź�ʱ���ͺ������');

  //�������豸���������ź�ʱ��ʱ
  //Ĭ�ϲ��ᳬʱ
  //const BriEvent_RingTimeOut			        =12;
  map.add(BriEvent_RingTimeOut, '�������豸���������ź�ʱ��ʱ');

  //������������
  //BRI_EVENT.lResult	   �Ѿ�����Ĵ���
  // BRI_EVENT.szData[0]='0'	��ʼһ������
  // BRI_EVENT.szData[0]='1'	һ��������ɣ�׼������
  //const BriEvent_Ringing				        =13;
  map.add(BriEvent_Ringing, '������������');

  // ͨ��ʱ��⵽һ��ʱ��ľ���.Ĭ��Ϊ5��
  //const BriEvent_Silence				        =14;
  map.add(BriEvent_Silence, 'ͨ��ʱ��⵽һ��ʱ��ľ���');

  // ��·��ͨʱ�յ�DTMF���¼�
  // ���¼���������ͨ�����Ǳ��ػ����������ǶԷ�������������
  //const BriEvent_GetDTMFChar			        =15;
  map.add(BriEvent_GetDTMFChar, '��·��ͨʱ�յ�DTMF���¼�');

  // ���ź�,���з�ժ���¼������¼������ο�,ԭ�����£���
  // ԭ��
  // ���¼�ֻ�����ڲ����Ǳ�׼�ź����ĺ���ʱ��Ҳ���ǲ��ź���б�׼�������ĺ��롣
  // �磺������ĶԷ������ǲ���(�����ֻ���)��ϵͳ��ʾ��(179xx)�����Ǳ�׼������ʱ���¼���Ч��
  //
  //const BriEvent_RemoteHook				=16;
  map.add(BriEvent_RemoteHook, '���ź�,���з�ժ���¼�');

  // ���з��һ��¼�
  // �����·��⵽���з�ժ���󣬱��з��һ�ʱ�ᴥ�����¼�����Ȼ���з��һ���ʹ���BriEvent_Busy�¼�
  // ���¼�����BriEvent_Busy�Ĵ�������ʾPSTN��·�Ѿ����Ͽ�
  //const BriEvent_RemoteHang				=17;
  map.add(BriEvent_RemoteHang, '���з��һ��¼�');

  // �һ��¼�
  // �����·��⵽���з�ժ���󣬱��з��һ�ʱ�ᴥ�����¼�����Ȼ���з��һ���ʹ���BriEvent_Busy�¼�
  // ���¼�����BriEvent_Busy�Ĵ�������ʾPSTN��·�Ѿ����Ͽ�

  // ��⵽æ���¼�,��ʾPSTN��·�Ѿ����Ͽ�
  //const BriEvent_Busy					=18;
  map.add(BriEvent_Busy, '��⵽æ���¼�,��ʾPSTN��·�Ѿ����Ͽ�');

  // ����ժ�����⵽������
  //const BriEvent_DialTone				        =19;
  map.add(BriEvent_DialTone, '����ժ�����⵽������');

  // ֻ���ڱ��ػ���ժ����û�е�����ժ��ʱ����⵽DTMF����
  //const BriEvent_PhoneDial				=20;
  map.add(BriEvent_PhoneDial, 'ֻ���ڱ��ػ���ժ����û�е�����ժ��ʱ����⵽DTMF����');

  // ���ص绰�����Ž��������¼���
  // Ҳ��ʱ�绰�����ź���յ���׼����������15�볬ʱ
  // BRI_EVENT.lResult=0 ��⵽������// ע�⣺�����·�ǲ����ǲ��ᴥ��������
  // BRI_EVENT.lResult=1 ���ų�ʱ
  // BRI_EVENT.lResult=2 ��̬��Ⲧ�������(�����й���½�ĺ������������ܷ����������ο�)
  // BRI_EVENT.szData[0]='1' ��ժ�����Ž����������
  // BRI_EVENT.szData[0]='0' �绰�������л�����
  //const BriEvent_RingBack				        =21;
  map.add(BriEvent_RingBack, '���ص绰�����Ž��������¼�');

  // MIC����״̬
  // ֻ���þ��иù��ܵ��豸
  //const BriEvent_MicIn					=22;
  map.add(BriEvent_MicIn, 'MIC����״̬');

  // MIC�γ�״̬
  // ֻ���þ��иù��ܵ��豸
  //const BriEvent_MicOut					=23;
  map.add(BriEvent_MicOut, 'MIC�γ�״̬');

  // �Ĳ��(Flash)����¼����Ĳ����ɺ���Լ�Ⲧ��������ж��β���
  // BRI_EVENT.lResult=TEL_FLASH  �û�ʹ�õ绰�������Ĳ�����
  // BRI_EVENT.lResult=SOFT_FLASH ����StartFlash���������Ĳ�����
  //const BriEvent_FlashEnd				        =24;
  map.add(BriEvent_FlashEnd, '�Ĳ��(Flash)����¼�');

  // �ܽ����
  //const BriEvent_RefuseEnd				=25;
  map.add(BriEvent_RefuseEnd, '�ܽ����');

  // ����ʶ�����
  //const BriEvent_SpeechResult		        	=26;
  map.add(BriEvent_SpeechResult, '����ʶ�����');

  //PSTN��·�Ͽ�,��·�������״̬
  //��ǰû����ժ�����һ���Ҳûժ��
  //const BriEvent_PSTNFree			        	=27;
  map.add(BriEvent_PSTNFree, 'PSTN��·�Ͽ�,��·�������״̬');

  // ���յ��Է�׼�����ʹ�����ź�
  //const BriEvent_RemoteSendFax			        =30;
  map.add(BriEvent_RemoteSendFax, '���յ��Է�׼�����ʹ�����ź�');

  // ���մ������
  //const BriEvent_FaxRecvFinished	                	=31;
  map.add(BriEvent_FaxRecvFinished, '���մ������');

  // ���մ���ʧ��
  //const BriEvent_FaxRecvFailed		        	=32;
  map.add(BriEvent_FaxRecvFailed, '���մ���ʧ��');

  // ���ʹ������
  //const BriEvent_FaxSendFinished		                =33;
  map.add(BriEvent_FaxSendFinished, '���ʹ������');

  // ���ʹ���ʧ��
  //const BriEvent_FaxSendFailed		        	=34;
  map.add(BriEvent_FaxSendFailed, '���ʹ���ʧ��');

  // ��������ʧ��
  //const BriEvent_OpenSoundFailed		                =35;
  map.add(BriEvent_OpenSoundFailed, '���ʹ���ʧ��');

  // ����һ��PSTN����/������־
  //const BriEvent_CallLog				        =36;
  map.add(BriEvent_CallLog, '����һ��PSTN����/������־');

  //��⵽�����ľ���
  //ʹ��QNV_GENERAL_CHECKSILENCE�������⵽�趨�ľ�������
  //const BriEvent_RecvSilence			        =37;
  map.add(BriEvent_RecvSilence, '��⵽�����ľ���');

  //��⵽����������
  //ʹ��QNV_GENERAL_CHECKVOICE�������⵽�趨����������
  //const BriEvent_RecvVoice				=38;
  map.add(BriEvent_RecvVoice, '��⵽����������');

  //Զ���ϴ��¼�
  //const BriEvent_UploadSuccess			        =50;
  map.add(BriEvent_UploadSuccess, 'Զ���ϴ��¼�');

  //const BriEvent_UploadFailed			        =51;
  map.add(BriEvent_UploadFailed, 'Զ���ϴ��¼�ʧ��');

  // Զ�������ѱ��Ͽ�
  //const BriEvent_RemoteDisconnect		                =52;
  map.add(BriEvent_RemoteDisconnect, 'Զ�������ѱ��Ͽ�');

  //HTTPԶ�������ļ����
  //BRI_EVENT.lResult	   ��������ʱ���صı��β����ľ��
  //const BriEvent_DownloadSuccess				=60;
  map.add(BriEvent_DownloadSuccess, 'HTTPԶ�������ļ����');

  //const BriEvent_DownloadFailed				=61;
  map.add(BriEvent_DownloadFailed, 'HTTPԶ������ʧ��');

  //��·�����
  //BRI_EVENT.lResult Ϊ�������Ϣ
  //const BriEvent_CheckLine				=70;
  map.add(BriEvent_CheckLine, '��·�����');

  // Ӧ�ò������ժ��/��һ��ɹ��¼�
  // BRI_EVENT.lResult=0 ��ժ��
  // BRI_EVENT.lResult=1 ��һ�
  //const BriEvent_EnableHook				=100;
  map.add(BriEvent_EnableHook, 'Ӧ�ò������ժ��/��һ��ɹ��¼�');

  // ���ȱ��򿪻���/�ر�
  // BRI_EVENT.lResult=0 �ر�
  // BRI_EVENT.lResult=1 ��
  //const BriEvent_EnablePlay				=101;
  map.add(BriEvent_EnablePlay, '���ȱ��򿪻���/�ر�');

  // MIC���򿪻��߹ر�
  // BRI_EVENT.lResult=0 �ر�
  // BRI_EVENT.lResult=1 ��
  //const BriEvent_EnableMic				=102;
  map.add(BriEvent_EnableMic, 'MIC���򿪻��߹ر�');

  // �������򿪻��߹ر�
  // BRI_EVENT.lResult=0 �ر�
  // BRI_EVENT.lResult=1 ��
  //const BriEvent_EnableSpk				=103;
  map.add(BriEvent_EnableSpk, '�������򿪻��߹ر�');

  // �绰�����绰��(PSTN)�Ͽ�/��ͨ(DoPhone)
  // BRI_EVENT.lResult=0 �Ͽ�
  // BRI_EVENT.lResult=1 ��ͨ
  //const BriEvent_EnableRing				=104;
  map.add(BriEvent_EnableRing, '�绰�����绰��(PSTN)�Ͽ�/��ͨ(DoPhone)');

  // �޸�¼��Դ (����/����)
  // BRI_EVENT.lResult ¼��Դ��ֵ
  //const BriEvent_DoRecSource			        =105;
  map.add(BriEvent_DoRecSource, '�޸�¼��Դ (����/����)');

  // ��ʼ�������
  // BRI_EVENT.szData	׼�����ĺ���
  //const BriEvent_DoStartDial			        =106;
  map.add(BriEvent_DoStartDial, '��ʼ�������');

  //const BriEvent_EnablePlayMux			        =107;
  map.add(BriEvent_EnablePlayMux, '��ʼ��������');

  // ���յ�FSK�źţ�����ͨ����FSK/��������FSK
  //const BriEvent_RecvedFSK				=198;
  map.add(BriEvent_RecvedFSK, '���յ�FSK�źţ�����ͨ����FSK/��������FSK');

  //�豸����
  //const BriEvent_DevErr					=199;
  map.add(BriEvent_DevErr, '�豸����');

end;

initialization
  //ShowMessage('1 ini');{��Ԫ��ʼ������}
  gEventTypeMap := TEventTypeMap.create;

finalization
  //ShowMessage('1 final');{��Ԫ�˳�ʱ�Ĵ���}
  gEventTypeMap.Free;

end.

