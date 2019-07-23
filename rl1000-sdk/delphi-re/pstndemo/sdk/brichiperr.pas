unit brichiperr;

interface

//USB�豸���� ���صĴ���ID
const		BCERR_VALIDHANDLE			=-9;  //���Ϸ��ľ��
const		BCERR_NOPLAYHANDLE			=-10; //û�п��в��ž��
const		BCERR_OPENFILEFAILED		        =-11; //���ļ�ʧ��
const		BCERR_READFILEFAILED		        =-12; //��ȡ�ļ����ݴ���
const		BCERR_WAVHEADERFAILED		        =-13; //�����ļ�ͷʧ��
const		BCERR_NOTSUPPORTFORMAT		        =-14; //������ʽ��֧��
const		BCERR_NORECHANDLE			=-15; //û���㹻��¼�����
const		BCERR_CREATEFILEFAILED		        =-16; //����¼���ļ�ʧ��
const		BCERR_NOBUFSIZE				=-17; //���岻��
const		BCERR_PARAMERR				=-18; //��������
const		BCERR_INVALIDTYPE			=-19; //���Ϸ��Ĳ�������		
const		BCERR_INVALIDCHANNEL		        =-20; //���Ϸ���ͨ��ID
const		BCERR_ISMULTIPLAYING		        =-21; //���ڶ��ļ�����,����ֹͣ����
const		BCERR_ISCONFRECING			=-22; //���ڻ���¼��,����ֹͣ¼��
const		BCERR_INVALIDCONFID			=-23; //����Ļ���ID��
const		BCERR_NOTCREATECONF			=-24; //����ģ�黹δ����
const		BCERR_NOTCREATEMULTIPLAY	        =-25; //û�п�ʼ���ļ�����
const		BCERR_NOTCREATESTRINGPLAY	        =-26; //û�п�ʼ�ַ�����
const		BCERR_ISFLASHING			=-27; //�����Ĳ��,����ֹͣ
const		BCERR_FLASHNOTLINE			=-28; //�豸û�н�ͨ��·�����Ĳ��
const		BCERR_NOTLOADFAXMODULE		        =-29; //δ��������ģ��
const		BCERR_FAXMODULERUNING		        =-30; //��������ʹ�ã�����ֹͣ
const		BCERR_VALIDLICENSE			=-31; //�����license
const		BCERR_ISFAXING				=-32; //���ڴ��治����һ�
const		BCERR_CCMSGOVER				=-33; //CC��Ϣ����̫��
const		BCERR_CCCMDOVER				=-34; //CC�����̫��
const 		BCERR_INVALIDSVR			=-35; //����������
const		BCERR_INVALIDFUNC			=-36; //δ�ҵ�ָ������ģ��
const		BCERR_INVALIDCMD			=-37; //δ�ҵ�ָ������
const		BCERR_UNSUPPORTFUNC			=-38; //�豸��֧�ָù���unsupport func
const		BCERR_DEVNOTOPEN			=-39; //δ��ָ���豸
const		BCERR_INVALIDDEVID			=-40; //���Ϸ���ID
const		BCERR_INVALIDPWD			=-41; //�������
const		BCERR_READSTOREAGEERR		        =-42; //��ȡ�洢����
const		BCERR_INVALIDPWDLEN			=-43; //���볤��̫��
const		BCERR_NOTFORMAT				=-44; //flash��δ��ʽ��
const		BCERR_FORMATFAILED			=-45; //��ʽ��ʧ��
const		BCERR_NOTENOUGHSPACE		        =-46; //д���FLASH����̫��,�洢�ռ䲻��
const		BCERR_WRITESTOREAGEERR		        =-47; //д��洢����
const		BCERR_NOTSUPPORTCHECK		        =-48; //ͨ����֧����·��⹦��
const		BCERR_INVALIDPATH			=-49; //���Ϸ����ļ�·��
const		BCERR_AUDRVINSTALLED			=-50; //�������������Ѿ���װ
const		BCERR_AUDRVUSEING			=-51; //������������ʹ�ò��ܸ���,���˳�����ʹ�ø���������������������������ٰ�װ
const		BCERR_AUDRVCOPYFAILED			=-52; //�������������ļ�����ʧ��


const		ERROR_INVALIDDLL			=-198;//���Ϸ���DLL�ļ�
const		ERROR_NOTINIT				=-199;//��û�г�ʼ���κ��豸
const		BCERR_UNKNOW				=-200;//δ֪����

//-------------------------------------------------------
//CC ���� �ص��Ĵ���ID
const TMMERR_BASE                       =0;

const TMMERR_SUCCESS			=0;
const TMMERR_FAILED			=-1;//�쳣����
const TMMERR_ERROR			=1;//��������
const TMMERR_SERVERDEAD		        =2;//������û��Ӧ
const TMMERR_INVALIDUIN		        =3;//���Ϸ���
const TMMERR_INVALIDUSER		=4;//���Ϸ����û�
const TMMERR_INVALIDPASS		=5;//���Ϸ�������
const TMMERR_DUPLOGON			=6;//�ظ���½
const TMMERR_INVALIDCONTACT	        =7;//��ӵĺ���CC������
const TMMERR_USEROFFLINE		=8;//�û�������
const TMMERR_INVALIDTYPE		=9;//��Ч
const TMMERR_EXPIRED			=14;//��ʱ
const TMMERR_INVALIDDLL		        =15;//��Ч
const TMMERR_OVERRUN			=16;//��Ч
const TMMERR_NODEVICE			=17;//���豸ʧ��
const TMMERR_DEVICEBUSY		        =18;//��������ʱ�豸æ
const	TMMERR_NOTLOGON			=19;//δ��½
const TMMERR_ADDSELF			=20;//���������Լ�Ϊ����
const TMMERR_ADDDUP			=21;//���Ӻ����ظ�
const TMMERR_SESSIONBUSY		=23;//��Ч
const TMMERR_NOINITIALIZE		=25;//��δ��ʼ��
const TMMERR_NOANSWER			=26;//��Ч
const TMMERR_TIMEOUT			=27;//��Ч
const TMMERR_LICENCE			=28;//��Ч
const TMMERR_SENDPACKET		        =29;//��Ч
const TMMERR_EDGEOUT			=30;//��Ч
const TMMERR_NOTSUPPORT		        =31;//��Ч
const TMMERR_NOGROUP			=32;//��Ч
const TMMERR_LOWERVER_PEER	        =34;//��Ч
const TMMERR_LOWERVER			=35;//��Ч
const TMMERR_HASPOINTS		        =36;//��Ч
const TMMERR_NOTENOUGHPOINTS	        =37;//��Ч
const TMMERR_NOMEMBER			=38;//��Ч
const TMMERR_NOAUTH			=39;//��Ч
const TMMERR_REGTOOFAST		        =40;//ע��̫��
const TMMERR_REGTOOMANY		        =41;//ע��̫��
const TMMERR_POINTSFULL		        =42;//��Ч
const TMMERR_GROUPOVER		        =43;//��Ч
const TMMERR_SUBGROUPOVER		=44;//��Ч
const TMMERR_HASMEMBER		        =45;//��Ч
const TMMERR_NOCONFERENCE		=46;//��Ч
const	TMMERR_RECALL			=47;//����ת��
const	TMMERR_SWITCHVOIP		=48;//�޸�VOIP��������ַ
const	TMMERR_RECFAILED		=49;//�豸¼������

const TMMERR_CANCEL			=101;//�Լ�ȡ��
const TMMERR_CLIENTCANCEL		=102;//�Է�ȡ��
const TMMERR_REFUSE			=103;//�ܾ��Է�
const TMMERR_CLIENTREFUSE		=104;//�Է��ܾ�
const TMMERR_STOP			=105;//�Լ�ֹͣ=�ѽ�ͨ;
const TMMERR_CLIENTSTOP		        =106;//�Է�ֹͣ=�ѽ�ͨ;

const TMMERR_VOIPCALLFAILED	        =108;//�ʺ�ûǮ��
const TMMERR_VOIPCONNECTED	        =200;//VOIP������ͨ��
const TMMERR_VOIPDISCONNECTED	        =201;//���������Ͽ����ӣ�SOCKET �������ر��ˡ�
const TMMERR_VOIPACCOUNTFAILED          =202;//����
const TMMERR_VOIPPWDFAILED	        =203;//�ʺ��������
const TMMERR_VOIPCONNECTFAILED          =204;//����VOIP������ʧ��
const TMMERR_STARTPROXYTRANS	        =205;//ͨ�������������ת��
//----------------------------------------------------------

implementation

end.
