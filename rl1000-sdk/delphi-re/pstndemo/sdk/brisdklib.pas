unit brisdklib;

interface

const           NULL                            =nil;//c++->delphi //nil
//2009/10/10
//const		QNV_DLL_VER		      	=$101;
//const         QNV_DLL_VER_STR                 ='1.01';
//2010/01/08
//const		QNV_DLL_VER			=$102;
//const		QNV_DLL_VER_STR			='1.02';
//2010/02/04 ����c/s socketԶ��ͨ�Žӿ�
//const 	QNV_DLL_VER	                =$103;
//const		QNV_DLL_VER_STR			='1.03';

//2010/03/05
//const		QNV_DLL_VER			=$104;
//const		QNV_DLL_VER_STR			='1.04';

//2010/09/20
//const		QNV_DLL_VER			=$105;
//const		QNV_DLL_VER_STR			='1.05';

//2010/10/29
const		QNV_DLL_VER			=$106;
const		QNV_DLL_VER_STR			='1.06';


const		QNV_FILETRANS_VER		=$30301;


const		QNV_CC_LICENSE			='quniccub_x';

//---------------------------------------------
//typedef  __int64			BRIINT64;//���� 64bit(8�ֽ�)
//typedef  __int32			BRIINT32;//���� 32bit(4�ֽ�)
//typedef  unsigned __int32             BRIUINT32;//�޷��� 32bit(4�ֽ�)
//typedef  __int16			BRIINT16;//���� 16bit(2�ֽ�)
//typedef  unsigned __int16	        BRIUINT16;//���� 16bit(2�ֽ�)
//typedef  unsigned char		BRIBYTE8;//�޷��� 8bit(1�ֽ�)
//typedef  char				BRICHAR8;//���� 8bit(1�ֽ�)
//typedef  char*			BRIPCHAR8;//�ַ���ָ��(ANSI)
//typedef  short*			BRIPSHORT16;//�ַ���ָ��(UNICODE)
type BRIINT64 = Int64;
type BRIINT32 = Integer;
type BRIUINT32= Cardinal;
type BRIINT16 = Smallint;
type BRIUINT16= Word;
type BRIBYTE8 = Byte;
type BRICHAR8 = AnsiChar;//Shortint;
type BRIPCHAR8= PAnsiChar;//^Shortint   Pchar ����Ϊ  PAnsiChar ,Char����ΪAnsiChar
type BRIPSHORT16=^Smallint;
//---------------------------------------------

//����/¼���ص�ʱ������ظ�ֵ��ϵͳ���Զ�ɾ���ûص�ģ�飬�´ν����ᱻ�ص�
const		CB_REMOVELIST				=-1;

const		MULTI_SEPA_CHAR				='|';//����ļ������б�ָ����
Const           PROXYDIAL_SIGN                          = $40000000;//�������
Const           PROXYDIAL_SIGN_STRU                     = 'P';//�������
Const           PROXYDIAL_SIGN_STRL                     = 'p';//�������

const		RING_BEGIN_SIGN_STR			='0';
const		RING_END_SIGN_STR			='1';
const		RING_BEGIN_SIGN_CH			='0';
const		RING_END_SIGN_CH			='1';

const		RINGBACK_TELDIAL_STR		        ='0';
const		RINGBACK_PCDIAL_STR			='1';
const		RINGBACK_PCDIAL_CH			='1';
const		RINGBACK_TELDIAL_CH			='0';



const		DIAL_DELAY_SECOND			=',';//����ʱ����֮���ӳ�1��
const		DIAL_DELAY_HSECOND			='.';//����ʱ����֮���ӳ�0.5��
const		DIAL_CHECK_CITYCODE			=':';//����ʱ�÷��ź��Զ����˳�������

const		CC_PARAM_SPLIT				=',';//CC�����ķָ�����


//�Զ�����¼���ļ�ʱ��Ĭ��Ŀ¼��
const		RECFILE_DIR			       ='recfile';
//������Ϣ���KEY
const		INI_QNVICC			       ='qnvicc';
//Ĭ�������ļ���
const		INI_FILENAME			       ='cc301config.ini';
//VOIP�������
const		CC_VOIP_SIGN			       ='VOIP';
//������½CC,���������Ϊ��ͬ
const   	WEB_802ID			       ='800002000000000000';



const		MAX_USB_COUNT				=64;//֧�ֵ����USBоƬ��
const		MAX_CHANNEL_COUNT			=128;//֧�ֵ����ͨ����
//����������Чͨ��ID��
//0->255ΪUSB�豸ͨ����
const		SOUND_CHANNELID				=256;
//Զ��ͨ��ͨ��,HTTP�ϴ�/����
const		REMOTE_CHANNELID			=257;
//CC����ͨ��
const		CCCTRL_CHANNELID			=258;
//
//socket ��������ͨ��
const		SOCKET_SERVER_CHANNELID		        =259;
//socket �ն�ͨ��
const		SOCKET_CLIENT_CHANNELID		        =260;

const		MAX_CCMSG_LEN				=400;//������Ϣ����󳤶�
const		MAX_CCCMD_LEN				=400;//�����������󳤶�

const		DEFAULT_FLASH_ELAPSE			=600;//Ĭ���Ĳ�ɼ��ʱ��(ms)
const		DEFAULT_FLASHFLASH_ELAPSE		=1000;//Ĭ���Ĳ�ɺ���һ��ʱ��ص��¼�ms
const		DEFAULT_RING_ELAPSE			=1000;//Ĭ�ϸ��ڲ�����/����������ʱ��ms�� 1��
const		DEFAULT_RINGSILENCE_ELAPSE		=4000;//Ĭ�ϸ��ڲ�����/�����������ֹͣms 4��
const		DEFAULT_RING_TIMEOUT			=12;//Ĭ�ϸ��������峬ʱ����,ÿ��1����4��ͣ,�ܹ�ʱ���ΪN*5
const		DEFAULT_REFUSE_ELAPSE			=500;//�ܽ�ʱĬ��ʹ�ü��(ms)
const		DEFAULT_DIAL_SPEED			=75;//Ĭ�ϲ����ٶ�ms
const		DEFAULT_DIAL_SILENCE			=75;//Ĭ�Ϻ���֮�侲��ʱ��ms
const		DEFAULT_CHECKDIALTONE_TIMEOUT		=3000;//��Ⲧ������ʱ��ǿ�ƺ���ms
const		DEFAULT_CALLINTIMEOUT			=5500;//�������峬ʱms

//�豸����
const		DEVTYPE_UNKNOW				=-1;//δ֪�豸
//cc301ϵ��
const		DEVTYPE_T1		   		=$1009;
const		DEVTYPE_T2		   		=$1000;
const		DEVTYPE_T3		   		=$1008;
const		DEVTYPE_T4		   		=$1005;
const		DEVTYPE_T5		   		=$1002;
const		DEVTYPE_T6		   		=$1004;

const		DEVTYPE_IR1		   		=$8100;

const		DEVTYPE_IA1				=$8111;
const		DEVTYPE_IA2				=$8112;
const		DEVTYPE_IA3				=$8113;
const		DEVTYPE_IA4		   		=$8114;

const		DEVTYPE_IB1				=$8121;
const		DEVTYPE_IB2				=$8122;
const		DEVTYPE_IB3				=$8123;
const		DEVTYPE_IB4				=$8124;

const		DEVTYPE_IP1				=$8131;
const		DEVTYPE_IP1_F				=$8132;  

const		DEVTYPE_IC2_R		        	=$8200;
const		DEVTYPE_IC2_LP			        =$8203;
const		DEVTYPE_IC2_LPQ				=$8207;
const		DEVTYPE_IC2_LPF				=$8211;

const		DEVTYPE_IC4_R		        	=$8400;
const		DEVTYPE_IC4_LP			        =$8403;
const		DEVTYPE_IC4_LPQ				=$8407;
const		DEVTYPE_IC4_LPF				=$8411;

const		DEVTYPE_IC7_R		        	=$8700;
const		DEVTYPE_IC7_LP			        =$8703;
const		DEVTYPE_IC7_LPQ				=$8707;
const		DEVTYPE_IC7_LPF				=$8711;


//������
const		DEVTYPE_A1				=$1100000;
const		DEVTYPE_A2				=$1200000;
const		DEVTYPE_A3				=$1300000;
const		DEVTYPE_A4				=$1400000;
const		DEVTYPE_B1		       		=$2100000;
const		DEVTYPE_B2		       		=$2200000;
const		DEVTYPE_B3		       		=$2300000;
const		DEVTYPE_B4		       		=$2400000;
const 	        DEVTYPE_C4_L		       		=$3100000;
const 	        DEVTYPE_C4_P		       		=$3200000;
const 	        DEVTYPE_C4_LP		       		=$3300000;
const 	        DEVTYPE_C4_LPQ		       		=$3400000;
const		DEVTYPE_C7_L		       		=$3500000;
const		DEVTYPE_C7_P		       		=$3600000;
const		DEVTYPE_C7_LP		       		=$3700000;
const		DEVTYPE_C7_LPQ		       		=$3800000;
const		DEVTYPE_R1		       		=$4100000;
const		DEVTYPE_C_PR		       		=$4200000;

//--------------------------------------------------------------
//�豸����ģ��
//�Ƿ�����������ȹ���
//����PC��������������/ͨ��ʱ��·����������
const		DEVMODULE_DOPLAY			=$1;
//�Ƿ���пɽ������߻�ȡ�������(FSK/DTMF˫��ʽ)/ͨ��¼������
//�������絯��/ͨ��¼��/ͨ��ʱ��ȡ�Է�����(DTMF)
const		DEVMODULE_CALLID			=$2;
//�Ƿ���пɽ��뻰������PSTNͨ������
//����ʹ�õ绰������PSTNͨ��/��ȡ���������ĺ���
const		DEVMODULE_PHONE				 =$4;
//�Ƿ���м̵����л��Ͽ�/��ͨ��������
//�Ͽ����������:����ʱ����������/ʹ�û���MIC�����ɼ�¼�����DEVFUNC_RINGģ�������ģ����������
const		DEVMODULE_SWITCH			  =$8;
//PC����������������Ͳ,���� DEVMODULE_SWITCHģ��,switch�󲥷�������������Ͳ
const		DEVMODULE_PLAY2TEL			 =$10;
//�Ƿ���л���ժ���󲦺�/��������·�Ĺ���
//����ʹ��PC�Զ�ժ�����в���/ͨ��ʱ���Ը��Է���������/��������/�Ⲧ֪ͨ/����IVR(������¼)
const		DEVMODULE_HOOK				  =$20;
//�Ƿ���в���MIC/��������
//������MIC/��������PSTNͨ��/ʹ��MIC����¼��/PC��������������
const		DEVMODULE_MICSPK			   =$40;
//�Ƿ�����ý���phone�ڵ��豸(�绰��,��������)ģ�����幦��
//��������ʱ����phone�ڵ��豸ģ����������.��:������IVR(������¼)֮����빤����ʱ���ڲ������򽻻���ģ������
const		DEVMODULE_RING				    =$80;
//�Ƿ���н���/���ʹ��湦��
//���Է���ͼƬ,�ĵ����Է��Ĵ����/���Խ��ձ���Է���������͹�����ͼƬ
const		DEVMODULE_FAX				     =$100;
//���м��Է�ת���Է�ժ���Ĺ���
//���PSTN��·�ڵ��ص��Ų���ͬʱ��ͨ�ü��Է�ת������,�Ϳ������Ⲧʱ��ȷ��⵽�Է�ժ��/�һ�
//���û�иù���,ֻ�в���ĺ�����б�׼����Ų��ܼ�⵽�Է�ժ��,���ֻ�����,IP�Ȳ����б�׼������·�Ĳ��ܼ��Է�ժ��/�һ�
const		DEVMODULE_POLARITY			      =$800;
//----------------------------------------------------------------


//���豸����
const		ODT_LBRIDGE				       =$0;//������
const		ODT_SOUND				       =$1;//����
const		ODT_CC					       =$2;//CCģ��
const		ODT_SOCKET_CLIENT			       =$4;//SOCKET�ն�ģ��
const		ODT_SOCKET_SERVER			       =$8;//SOCKET������ģ��
const		ODT_SOCKET_UDP				       =$10;//UDPģ��
const		ODT_ALL					       =$FF;//ȫ��
const		ODT_CHANNEL				       =$100;//�ر�ָ��ͨ��
//

//-----------------------------------------------------
//linein��·ѡ��
const		LINEIN_ID_1				       =$0;//Ĭ������״̬¼�����ɼ���������
const		LINEIN_ID_2				       =$1;//�绰���Ͽ��󻰱�¼��
const		LINEIN_ID_3				       =$2;//hook line ��ժ����¼��,¼�����ݿ�����߶Է�������,���ͱ�������
const		LINEIN_ID_LOOP				       =$3;//�ڲ���·����,�豸����ʹ��,�����û�����Ҫʹ��
//-----------------------------------------------------

const		ADCIN_ID_MIC				       =$0;//mic¼��
const		ADCIN_ID_LINE				       =$1;//�绰��¼��

//adc
const		DOPLAY_CHANNEL1_ADC			       =$0;
const		DOPLAY_CHANNEL0_ADC			       =$1;
const		DOPLAY_CHANNEL0_DAC			       =$2;
const		DOPLAY_CHANNEL1_DAC			       =$3;

//------------
const		SOFT_FLASH				       =$1;//ʹ����������Ĳ����
const		TEL_FLASH				       =$2;//ʹ�û����Ĳ����
//------------
//�ܽ�ʱʹ��ģʽ
const		REFUSE_ASYN				       =$0;//�첽ģʽ,���ú����������أ���������ʾ�ܽ���ɣ��ܽ���ɺ󽫽��յ�һ���ܽ���ɵ��¼�
const		REFUSE_SYN				       =$1;//ͬ��ģʽ,���ú�ú������������ȴ��ܽ���ɷ��أ�ϵͳ�����оܽ���ɵ��¼�

//�Ĳ������
const		FT_NULL					       =$0;
const		FT_TEL					       =$1;//�����Ĳ��
const		FT_PC					       =$2;//���Ĳ��
const		FT_ALL					       =$3;
//-------------------------------

//��������
const		DTT_DIAL				       =$0;//����
const		DTT_SEND				       =$1;//���η���/���巢��CALLID
//-------------------------------

//�������ģʽ
const		CALLIDMODE_NULL				       =$0;//δ֪
const		CALLIDMODE_FSK				       =$1;//FSK����
const		CALLIDMODE_DTMF				       =$2;//DTMF����
//

//��������
const		CTT_NULL				       =$0;
const		CTT_MOBILE				       =$1;//�ƶ�����
const		CTT_PSTN				       =$2;//��ͨ�̻�����
//------------------------------

const		CALLT_NULL				       =$0;//
const		CALLT_CALLIN				       =$1;//����
const		CALLT_CALLOUT				       =$2;//ȥ��
//-------------------

const		CRESULT_NULL				       =$0;
const		CRESULT_MISSED				       =$1;//����δ��
const		CRESULT_REFUSE				       =$2;//����ܽ�
const		CRESULT_RINGBACK			       =$3;//���к������
const		CRESULT_CONNECTED			       =$4;//��ͨ
//--------------------------------------

const		OPTYPE_NULL				       =$0;
const		OPTYPE_REMOVE				       =$1;//�ϴ��ɹ���ɾ�������ļ�

//�豸����ID
const		DERR_READERR				       =$0;//��ȡ���ݷ��ʹ���
const		DERR_WRITEERR				       =$1;//д�����ݴ���
const		DERR_FRAMELOST				       =$2;//�����ݰ�
const		DERR_REMOVE				       =$3;//�豸�Ƴ�
const		DERR_SERIAL				       =$4;//�豸���кų�ͻ
//---------------------------------------

//����ʶ��ʱ���Ա�����
const		SG_NULL					       =$0;
const		SG_MALE					       =$1;//����
const		SG_FEMALE				       =$2;//Ů��
const		SG_AUTO					       =$3;//�Զ�
//--------------------------------

//�豸����ģʽ
const		SM_NOTSHARE				       =$0 ;
const		SM_SENDVOICE				       =$1;//��������
const		SM_RECVVOICE				       =$2;//��������
//----------------------------------

//----------------------------------------------
//�������/����
const		FAX_TYPE_NULL				       =$0;
const		FAX_TYPE_SEND				       =$1;//���ʹ���
const		FAX_TYPE_RECV				       =$2;//���մ���
//------------------------------------------------

//
const		TTS_LIST_REINIT				       =$0;//���³�ʼ���µ�TTS�б�
const		TTS_LIST_APPEND				       =$1;//׷��TTS�б��ļ�
//------------------------------------------------

//--------------------------------------------------------
const		DIALTYPE_DTMF				       =$0;//DTMF����
const		DIALTYPE_FSK				       =$1;//FSK����
//--------------------------------------------------------

//--------------------------------------------------------
const		PLAYFILE_MASK_REPEAT				=$1;//ѭ������
const		PLAYFILE_MASK_PAUSE				=$2;//Ĭ����ͣ
//--------------------------------------------------------

//�����ļ��ص���״̬
const		PLAYFILE_PLAYING				=$1;//���ڲ���
const		PLAYFILE_REPEAT					=$2;//׼���ظ�����
const		PLAYFILE_END					=$3;//���Ž���


const		CONFERENCE_MASK_DISABLEMIC		        =$100;//ֹͣMIC,������������Ա�����������û�˵��
const		CONFERENCE_MASK_DISABLESPK		        =$200;//ֹͣSPK,��������������������Ա˵��


const		RECORD_MASK_ECHO			        =$1;//���������������
const		RECORD_MASK_AGC				        =$2;//�Զ������¼��
const		RECORD_MASK_PAUSE			        =$4;//��ͣ

const		CHECKLINE_MASK_DIALOUT				=$1;//��·�Ƿ�������������(�оͿ�����������)
const		CHECKLINE_MASK_REV				=$2;//��·LINE��/PHONE�ڽ����Ƿ�����,�������ͱ�ʾ�ӷ���

const		OUTVALUE_MAX_SIZE			        =260;//location���ص���󳤶�


//-----------------------------------------------

//cc ��Ϣ����
//�����������������鿴windows����ĵ�
const		MSG_KEY_CC				        ='cc:'; //��Ϣ��ԴCC��
const		MSG_KEY_NAME			                ='name:';//��Ϣ��Դ���ƣ�����
const		MSG_KEY_TIME			                ='time:';//��Ϣ��Դʱ��
const		MSG_KEY_FACE			                ='face:';//��������
const		MSG_KEY_COLOR			                ='color:';//������ɫ
const		MSG_KEY_SIZE			                ='size:';//����ߴ�
const		MSG_KEY_CHARSET			                ='charset:';//��������
const		MSG_KEY_EFFECTS			                ='effects:';//����Ч��
const		MSG_KEY_LENGTH			                ='length:';//��Ϣ���ĳ���
const		MSG_KEY_CID				        ='cid:';//����ID
const		MSG_KEY_IMTYPE			                ='imtp:';//��Ϣ����
//CC�ļ�����
const		MSG_KEY_FILENAME		                ='filename:';//�ļ���
const		MSG_KEY_FILESIZE		                ='filesize:';//�ļ�����
const		MSG_KEY_FILETYPE		                ='filetype:';//�ļ�����

//
const		MSG_KEY_CALLPARAM		                ='callparam:';//CC����ʱ�Ĳ���

//
//const		MSG_KEY_SPLIT			                ='\r\n';//����֮��ָ�����
//const		MSG_TEXT_SPLIT		                	='\r\n\r\n';//��Ϣ��������Ϣ���ݵķָ�����
const		MSG_KEY_SPLIT			                =#13#10;
const		MSG_TEXT_SPLIT		                	=#13#10#13#10;




//���ݽṹ
const		MAX_BRIEVENT_DATA	=600;//�¼������󱣴��������󳤶�
type
  TBriEvent_Data = record
    uVersion:           BRIBYTE8;
    uReserv:            BRIBYTE8;
    uChannelID:         BRIINT16;//�¼�����ͨ��ID
    lEventType:         BRIINT32;//�¼�����ID �鿴BRI_EVENT.lEventType Define
    lEventHandle:       BRIINT32;//�¼���ؾ��
    lResult:            BRIINT32;//�¼������ֵ
    lParam:             BRIINT32;//����,��չʱʹ��
    szData: Array[1..MAX_BRIEVENT_DATA] of BRICHAR8; //�¼��������.�磺����ʱ������������ĺ���
    szDataEx: Array[1..32] of BRICHAR8; //����,��չʱʹ��
  end;

type PTBriEvent_Data = ^TBriEvent_Data;


//----------------------------------------------------------------------
//�ص�����ԭ��
//----------------------------------------------------------------------
//
//���岥�Żص�ԭ��
//uChannelID:ͨ��ID
//dwUserData:�û��Զ��������
//lHandle:����ʱ���صľ��
//lDataSize:��ǰ�������������
//lFreeSize:��ǰ����Ŀ��г���
//���� CB_REMOVELIST(-1) ����ϵͳɾ���ûص���Դ���´β��ٻص�/��������ֵ����
//typedef BRIINT32 (CALLBACK *PCallBack_PlayBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lDataSize,BRIINT32 lFreeSize);
type PCallBack_PlayBuf = function(uChannelID:BRIINT16;dwUserData:longint;lHandle:longint;lDataSize:longint;lFreeSize:longint):longint;stdcall;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//�����ļ����Żص�ԭ��
//uChannelID:ͨ��ID
//nPlayState:�ļ����ŵ�״̬,PLAYING/REPLAY/END
//dwUserData:�û��Զ��������
//lHandle:����ʱ���صľ��
//lElapses:�ܹ����ŵ�ʱ��(��λ��)
//���� CB_REMOVELIST(-1) ϵͳ���Զ�ֹͣ���Ÿ��ļ�/��������ֵ����
//typedef BRIINT32 (CALLBACK *PCallBack_PlayFile)(BRIINT16 uChannelID,BRIUINT32 nPlayState,BRIUINT32 dwUserData,BRIINT32 lHandle,BRIINT32 lElapses);
type PCallBack_PlayFile = function(uChannelID:BRIINT16;nPlayState:longint;dwUserData:longint;lHandle:longint;lElapses:longint):longint;stdcall;

//////////////////////////////////////////////////////////////////////////////////////////
//����¼���ص�ԭ�� Ĭ�ϸ�ʽΪ8K/16λ/������/����
//uChannelID:ͨ��ID
//dwUserData:�û��Զ�������
//pBufData:��������
//lBufSize:�������ݵ��ڴ��ֽڳ���
//���� CB_REMOVELIST(-1) ����ϵͳɾ���ûص���Դ���´β��ٻص�/��������ֵ����
//typedef BRIINT32 (CALLBACK *PCallBack_RecordBuf)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIBYTE8 *pBufData,BRIINT32 lBufSize);
type PCallBack_RecordBuf = function(uChannelID:BRIINT16;dwUserData:longint;pBufData:BRIPCHAR8;lBufSize:longint):longint;stdcall;
////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
//�¼������ص�ԭ��
//uChannelID:ͨ��ID
//dwUserData:�û��Զ�������
//lType:�¼�����ID �鿴BRI_EVENT.lEventType Define
//lResult:�¼��������
//lParam:��������,��չʹ��
//szData:�¼��������
//pDataEx:��������,��չʹ��
/////////////////////////////////////////////////////////////////////////////////////////
//typedef BRIINT32 (CALLBACK *PCallBack_Event)(BRIINT16 uChannelID,BRIUINT32 dwUserData,BRIINT32 lType,BRIINT32 lHandle,BRIINT32 lResult,,BRIINT32 lParam,BRIPCHAR8 pData,BRIPCHAR8 pDataEx);
type PCallBack_Event = function(uChannelID:BRIINT16;dwUserData:longint;lType:longint;lHandle:longint;lResult:longint;lParam:longint;pData:BRIPCHAR8;pDataEx:BRIPCHAR8):longint;stdcall;

//////////////////////////////////////////////////////////////////////////////////////////
//�¼������ص�ԭ��,ʹ�ýṹ�巽ʽ
//pEvent:�¼��ṹ������
//dwUserData:�û��Զ�������
//��ע:��PCallBack_EventֻҪʹ������һ�ַ��ǾͿ�����
/////////////////////////////////////////////////////////////////////////////////////////
//typedef BRIINT32 (CALLBACK *PCallBack_EventEx)(PBRI_EVENT pEvent,BRIUINT32 dwUserData);
type PCallBack_EventEx = function(pEvent:PTBriEvent_Data;dwUserData:longint):longint;stdcall;



//////////////////////////////////////////////////////////////////////
//  BRI_EVENT.lEventType Define
//  �¼����Ͷ���.ͬ����ϵͳ�����Ĵ�����Ϣ(��ѡ������һ�ַ�ʽ����)
///////////////////////////////////////////////////////////////////////


// ���ص绰��ժ���¼�
const	BriEvent_PhoneHook				=1;
// ���ص绰���һ��¼�
const BriEvent_PhoneHang				=2;

// ����ͨ�����������¼�
// BRI_EVENT.lResult		Ϊ�������
// BRI_EVENT.szData[0]='0'	��ʼ1������
// BRI_EVENT.szData[0]='1'	Ϊ1��������ɣ���ʼ4�뾲��
const BriEvent_CallIn					=3;

// �õ��������
// BRI_EVENT.lResult		�������ģʽ(CALLIDMODE_FSK/CALLIDMODE_DTMF
// BRI_EVENT.szData		������������
// ���¼�����������ǰ,Ҳ�����������
const BriEvent_GetCallID				=4;

// �Է�ֹͣ����(����һ��δ�ӵ绰)
const BriEvent_StopCallIn				=5;

// ���ÿ�ʼ���ź�ȫ�����벦�Ž���
const BriEvent_DialEnd				        =6;

// �����ļ������¼�
// BRI_EVENT.lResult	   �����ļ�ʱ���صľ��ID 
const BriEvent_PlayFileEnd			        =7;

// ���ļ����������¼�
// 
const BriEvent_PlayMultiFileEnd		                =8;

//�����ַ�����
const	BriEvent_PlayStringEnd			        =9;

// �����ļ�����׼���ظ�����
// BRI_EVENT.lResult	   �����ļ�ʱ���صľ��ID 
// 
const BriEvent_RepeatPlayFile			        =10;

// �������豸���������ź�ʱ���ͺ������
const BriEvent_SendCallIDEnd			        =11;

//�������豸���������ź�ʱ��ʱ
//Ĭ�ϲ��ᳬʱ
const BriEvent_RingTimeOut			        =12;

//������������
//BRI_EVENT.lResult	   �Ѿ�����Ĵ���
// BRI_EVENT.szData[0]='0'	��ʼһ������
// BRI_EVENT.szData[0]='1'	һ��������ɣ�׼������
const BriEvent_Ringing				        =13;

// ͨ��ʱ��⵽һ��ʱ��ľ���.Ĭ��Ϊ5��
const BriEvent_Silence				        =14;

// ��·��ͨʱ�յ�DTMF���¼�
// ���¼���������ͨ�����Ǳ��ػ����������ǶԷ�������������
const BriEvent_GetDTMFChar			        =15;

// ���ź�,���з�ժ���¼������¼������ο�,ԭ�����£���
// ԭ��
// ���¼�ֻ�����ڲ����Ǳ�׼�ź����ĺ���ʱ��Ҳ���ǲ��ź���б�׼�������ĺ��롣
// �磺������ĶԷ������ǲ���(�����ֻ���)��ϵͳ��ʾ��(179xx)�����Ǳ�׼������ʱ���¼���Ч��
// 
const BriEvent_RemoteHook				=16;

// �һ��¼�
// �����·��⵽���з�ժ���󣬱��з��һ�ʱ�ᴥ�����¼�����Ȼ���з��һ���ʹ���BriEvent_Busy�¼�
// ���¼�����BriEvent_Busy�Ĵ�������ʾPSTN��·�Ѿ����Ͽ�
const BriEvent_RemoteHang				=17;

// ��⵽æ���¼�,��ʾPSTN��·�Ѿ����Ͽ�
const BriEvent_Busy					=18;

// ����ժ�����⵽������
const BriEvent_DialTone				        =19;

// ֻ���ڱ��ػ���ժ����û�е�����ժ��ʱ����⵽DTMF����
const BriEvent_PhoneDial				=20;

// �绰�����Ž��������¼���
// Ҳ��ʱ�绰�����ź���յ���׼����������15�볬ʱ
// BRI_EVENT.lResult=0 ��⵽������// ע�⣺�����·�ǲ����ǲ��ᴥ��������
// BRI_EVENT.lResult=1 ���ų�ʱ
// BRI_EVENT.lResult=2 ��̬��Ⲧ�������(�����й���½�ĺ������������ܷ����������ο�)
// BRI_EVENT.szData[0]='1' ��ժ�����Ž����������
// BRI_EVENT.szData[0]='0' �绰�������л�����
const BriEvent_RingBack				        =21;

// MIC����״̬
// ֻ���þ��иù��ܵ��豸
const BriEvent_MicIn					=22;
// MIC�γ�״̬
// ֻ���þ��иù��ܵ��豸
const BriEvent_MicOut					=23;

// �Ĳ��(Flash)����¼����Ĳ����ɺ���Լ�Ⲧ��������ж��β���
// BRI_EVENT.lResult=TEL_FLASH  �û�ʹ�õ绰�������Ĳ�����
// BRI_EVENT.lResult=SOFT_FLASH ����StartFlash���������Ĳ�����
const BriEvent_FlashEnd				        =24;

// �ܽ����
const BriEvent_RefuseEnd				=25;

// ����ʶ����� 
const BriEvent_SpeechResult		        	=26;

//PSTN��·�Ͽ�,��·�������״̬
//��ǰû����ժ�����һ���Ҳûժ��
const BriEvent_PSTNFree			        	=27;

// ���յ��Է�׼�����ʹ�����ź�
const BriEvent_RemoteSendFax			        =30;

// ���մ������
const BriEvent_FaxRecvFinished	                	=31;
// ���մ���ʧ��
const BriEvent_FaxRecvFailed		        	=32;

// ���ʹ������
const BriEvent_FaxSendFinished		                =33;
// ���ʹ���ʧ��
const BriEvent_FaxSendFailed		        	=34;

// ��������ʧ��
const BriEvent_OpenSoundFailed		                =35;

// ����һ��PSTN����/������־
const BriEvent_CallLog				        =36;

//��⵽�����ľ���
//ʹ��QNV_GENERAL_CHECKSILENCE�������⵽�趨�ľ�������
const BriEvent_RecvSilence			        =37;

//��⵽����������
//ʹ��QNV_GENERAL_CHECKVOICE�������⵽�趨����������
const BriEvent_RecvVoice				=38;

//Զ���ϴ��¼�
const BriEvent_UploadSuccess			        =50;
const BriEvent_UploadFailed			        =51;
// Զ�������ѱ��Ͽ�
const BriEvent_RemoteDisconnect		                =52;

//HTTPԶ�������ļ����
//BRI_EVENT.lResult	   ��������ʱ���صı��β����ľ��
const BriEvent_DownloadSuccess				=60;
const BriEvent_DownloadFailed				=61;

//��·�����
//BRI_EVENT.lResult Ϊ�������Ϣ
const BriEvent_CheckLine				=70;


// Ӧ�ò������ժ��/��һ��ɹ��¼�
// BRI_EVENT.lResult=0 ��ժ��
// BRI_EVENT.lResult=1 ��һ�			
const BriEvent_EnableHook				=100;
// ���ȱ��򿪻���/�ر�
// BRI_EVENT.lResult=0 �ر�
// BRI_EVENT.lResult=1 ��			
const BriEvent_EnablePlay				=101;
// MIC���򿪻��߹ر�	
// BRI_EVENT.lResult=0 �ر�
// BRI_EVENT.lResult=1 ��			
const BriEvent_EnableMic				=102;
// �������򿪻��߹ر�
// BRI_EVENT.lResult=0 �ر�
// BRI_EVENT.lResult=1 ��			
const BriEvent_EnableSpk				=103;
// �绰�����绰��(PSTN)�Ͽ�/��ͨ(DoPhone)
// BRI_EVENT.lResult=0 �Ͽ�
// BRI_EVENT.lResult=1 ��ͨ		
const BriEvent_EnableRing				=104;
// �޸�¼��Դ (����/����)
// BRI_EVENT.lResult ¼��Դ��ֵ
const BriEvent_DoRecSource			        =105;
// ��ʼ�������
// BRI_EVENT.szData	׼�����ĺ���
const BriEvent_DoStartDial			        =106;

const BriEvent_EnablePlayMux			        =107;

// ���յ�FSK�źţ�����ͨ����FSK/��������FSK		
const BriEvent_RecvedFSK				=198;
//�豸����
const BriEvent_DevErr					=199;

//CCCtrl Event
//CC��������¼�
const BriEvent_CC_ConnectFailed		                =200;//����ʧ��
const BriEvent_CC_LoginFailed		               	=201;//��½ʧ��
const BriEvent_CC_LoginSuccess		                =202;//��½�ɹ�
const BriEvent_CC_SystemTimeErr		                =203;//ϵͳʱ�����
const BriEvent_CC_CallIn				=204;//��CC��������
const BriEvent_CC_CallOutFailed		                =205;//����ʧ��
const BriEvent_CC_CallOutSuccess		        =206;//���гɹ������ں���
const BriEvent_CC_Connecting			        =207;//������������
const BriEvent_CC_Connected			        =208;//������ͨ
const BriEvent_CC_CallFinished		                =209;//���н���
const BriEvent_CC_ReplyBusy		                =210;//���н���

const BriEvent_CC_RecvedMsg			        =220;//���յ��û���ʱ��Ϣ
const BriEvent_CC_RecvedCmd			        =221;//���յ��û��Զ�������

const BriEvent_CC_RegSuccess			        =225;//ע��CC�ɹ�
const BriEvent_CC_RegFailed			        =226;//ע��CCʧ��

const BriEvent_CC_RecvFileRequest       	        =230;//���յ��û����͵��ļ�����
const BriEvent_CC_TransFileFinished	                =231;//�����ļ�����

const BriEvent_CC_AddContactSuccess	                =240;//���Ӻ��ѳɹ�
const BriEvent_CC_AddContactFailed	                =241;//���Ӻ���ʧ��
const BriEvent_CC_InviteContact		                =242;//���յ����Ӻú�������
const BriEvent_CC_ReplyAcceptContact	                =243;//�Է��ظ�ͬ��Ϊ����
const BriEvent_CC_ReplyRefuseContact	                =244;//�Է��ظ��ܾ�Ϊ����
const BriEvent_CC_AcceptContactSuccess                  =245;//���ܺ��ѳɹ�
const BriEvent_CC_AcceptContactFailed	                =246;//���ܺ���ʧ��
const BriEvent_CC_RefuseContactSuccess                  =247;//�ܾ����ѳɹ�
const BriEvent_CC_RefuseContactFailed	                =248;//�ܾ�����ʧ��
const BriEvent_CC_DeleteContactSuccess                  =249;//ɾ�����ѳɹ�
const BriEvent_CC_DeleteContactFailed                   =250;//ɾ������ʧ��
const BriEvent_CC_ContactUpdateStatus	                =251;//���ѵ�½״̬�ı�
const BriEvent_CC_ContactDownendStatus                  =252;//��ȡ�����к��Ѹı����

//�ն˽��յ����¼�
const BriEvent_Socket_C_ConnectSuccess                  =300;//���ӳɹ�
const BriEvent_Socket_C_ConnectFailed                   =301;//����ʧ��
const BriEvent_Socket_C_ReConnect                       =302;//��ʼ��������
const BriEvent_Socket_C_ReConnectFailed                 =303;//��������ʧ��
const BriEvent_Socket_C_ServerClose                     =304;//�������Ͽ�����
const BriEvent_Socket_C_DisConnect                      =305;//���Ӽ��ʱ
const BriEvent_Socket_C_RecvedData                      =306;//���յ�����˷��͹���������
//�������˽��յ����¼�
const BriEvent_Socket_S_NewLink                         =340;//�������ӽ���
const BriEvent_Socket_S_DisConnect                      =341;//�ն����Ӽ��ʱ
const BriEvent_Socket_S_ClientClose                     =342;//�ն˶Ͽ�������
const BriEvent_Socket_S_RecvedData                      =343;//���յ��ն˷��͹���������

//UDP�¼�
const BriEvent_Socket_U_RecvedData			=360;//���յ�UDP����
//
const BriEvent_EndID					=500;//��ID





///////////////////////////////////////////////////////////////
//��Ϣ����˵��
//////////////////////////////////////////////////////////////
const           WM_USER                                 =1024;
const		BRI_EVENT_MESSAGE			=WM_USER+2000;//�¼���Ϣ
const		BRI_RECBUF_MESSAGE			=WM_USER+2001;//����¼��������Ϣ

//�ļ�¼����ʽ
const		BRI_WAV_FORMAT_DEFAULT			=0; // BRI_AUDIO_FORMAT_PCM8K16B
const		BRI_WAV_FORMAT_ALAW8K			=1; // 8k/s
const		BRI_WAV_FORMAT_ULAW8K			=2; // 8k/s
const		BRI_WAV_FORMAT_IMAADPCM8K4B		=3; // 4k/s
const		BRI_WAV_FORMAT_PCM8K8B			=4; // 8k/s
const		BRI_WAV_FORMAT_PCM8K16B			=5; //16k/s
const		BRI_WAV_FORMAT_MP38K8B			=6; //~1.2k/s
const		BRI_WAV_FORMAT_MP38K16B			=7; //~2.4k/s
const		BRI_WAV_FORMAT_TM8K1B			=8; //~1.5k/s
const		BRI_WAV_FORMAT_GSM6108K			=9; //~2.2k/s
const		BRI_WAV_FORMAT_END			=255; //��ЧID
//�������256��
////////////////////////////////////////////////////////////




//-------------------------------------------------------------------------------------
//
//
//----------------------------------------------------------------------------------
//�豸��Ϣ
const		QNV_DEVINFO_GETCHIPTYPE			=1;//��ȡUSBģ������
const		QNV_DEVINFO_GETCHIPS			=2;//��ȡUSBģ������,��ֵ�������һ��ͨ����DEVID
const		QNV_DEVINFO_GETTYPE			=3;//��ȡͨ������
const		QNV_DEVINFO_GETMODULE			=4;//��ȡͨ������ģ��
const		QNV_DEVINFO_GETCHIPCHID			=5;//��ȡͨ������USBоƬ���еĴ���ID(0����1)
const		QNV_DEVINFO_GETSERIAL			=6;//��ȡͨ�����к�(0-n)
const		QNV_DEVINFO_GETCHANNELS			=7;//��ȡͨ������
const		QNV_DEVINFO_GETDEVID			=8;//��ȡͨ�����ڵ�USBģ��ID(0-n)
const		QNV_DEVINFO_GETDLLVER		       	=9;//��ȡDLL�汾��
const           QNV_DEVINFO_GETCHIPCHANNEL              =10;//��ȡ��USBģ���һ������ID���ڵ�ͨ����
const		QNV_DEVINFO_GETCHANNELTYPE		=11;//ͨ����·�����߻��ǻ�������
const		QNV_DEVINFO_GETCHIPCHANNELS		=12;//��ȡ��USBģ��ڶ�������ID���ڵ�ͨ����

const		QNV_DEVINFO_FILEVERSION			=20;//��ȡDLL���ļ��汾

//-----------------------------------------------------------------

//���������б�
//uParamType (����ʹ��API�Զ�����/��ȡ)
const		QNV_PARAM_BUSY				=1;//��⵽����æ���ص�
const		QNV_PARAM_DTMFLEVEL		        =2;//dtmf���ʱ�������������(0-5)
const		QNV_PARAM_DTMFVOL			=3;//dtmf���ʱ���������(1-100)
const		QNV_PARAM_DTMFNUM			=4;//dtmf���ʱ����ĳ���ʱ��(2-10)
const		QNV_PARAM_DTMFLOWINHIGH			=5;//dtmf��Ƶ���ܳ�����Ƶֵ(Ĭ��Ϊ6)
const		QNV_PARAM_DTMFHIGHINLOW			=6;//dtmf��Ƶ���ܳ�����Ƶֵ(Ĭ��Ϊ4)
const		QNV_PARAM_DIALSPEED			=7;//���ŵ�DTMF����(1ms-60000ms)
const		QNV_PARAM_DIALSILENCE			=8;//����ʱ�ļ����������(1ms-60000ms)
const		QNV_PARAM_DIALVOL			=9;//����������С
const		QNV_PARAM_RINGSILENCE			=10;//���粻�������ʱ�䳬ʱ��δ�ӵ绰
const		QNV_PARAM_CONNECTSILENCE		=11;//ͨ��ʱ��������ʱ�侲����ص�
const		QNV_PARAM_RINGBACKNUM			=12;//�������������Ϻ�����忪ʼ��Ч//Ĭ��Ϊ2��,���𵽺��Գ��ֺ������Ļ�����
const		QNV_PARAM_SWITCHLINEIN			=13;//�Զ��л�LINEINѡ��
const		QNV_PARAM_FLASHELAPSE			=14;//�Ĳ�ɼ��
const		QNV_PARAM_FLASHENDELAPSE		=15;//�Ĳ�ɺ��ӳ�һ��ʱ���ٻص��¼�
const		QNV_PARAM_RINGELAPSE			=16;//��������ʱʱ�䳤��
const		QNV_PARAM_RINGSILENCEELAPSE		=17;//��������ʱ��������
const		QNV_PARAM_RINGTIMEOUT			=18;//��������ʱ��ʱ����
const		QNV_PARAM_RINGCALLIDTYPE		=19;//��������ʱ���ͺ���ķ�ʽdtmf/fsk
const		QNV_PARAM_REFUSEELAPSE			=20;//�ܽ�ʱ���ʱ�䳤��
const		QNV_PARAM_DIALTONETIMEOUT		=21;//��Ⲧ������ʱ
const		QNV_PARAM_MINCHKFLASHELAPSE		=22;//�Ĳ�ɼ��ʱ�һ����ٵ�ʱ��ms,�һ�ʱ��С�ڸ�ֵ�Ͳ����Ĳ��
const		QNV_PARAM_MAXCHKFLASHELAPSE		=23;//�Ĳ�ɼ��ʱ�һ����ʱ��ms,�һ�ʱ����ڸ�ֵ�Ͳ����Ĳ��
const		QNV_PARAM_HANGUPELAPSE			=24;//���绰���һ�ʱ������ʱ�䳤��ms,//����һ����������Ĳ�����ϣ����ⷢ���һ����ּ�⵽�Ĳ�
const		QNV_PARAM_OFFHOOKELAPSE			=25;//���绰��ժ��ʱ������ʱ�䳤��ms
const		QNV_PARAM_RINGHIGHELAPSE		=26;//�����������ʱ���������ʱ�䳤��ms
const		QNV_PARAM_RINGLOWELAPSE			=27;//�����������ʱ�����������ʱ�䳤��ms

const		QNV_PARAM_SPEECHGENDER			=30;//���������Ա�
const		QNV_PARAM_SPEECHTHRESHOLD		=31;//����ʶ������
const		QNV_PARAM_SPEECHSILENCEAM		=32;//����ʶ��������
const		QNV_PARAM_ECHOTHRESHOLD			=33;//������������������޲���
const		QNV_PARAM_ECHODECVALUE			=34;//����������������������
const		QNV_PARAM_SIGSILENCEAM			=35;//�ź���/��·ͨ�������ľ�������

const		QNV_PARAM_LINEINFREQ1TH			=40;//��һ����·˫Ƶģʽ�ź���Ƶ��
const		QNV_PARAM_LINEINFREQ2TH			=41;//�ڶ�����·˫Ƶģʽ�ź���Ƶ��
const		QNV_PARAM_LINEINFREQ3TH			=42;//��������·˫Ƶģʽ�ź���Ƶ��

Const           QNV_PARAM_ADBUSYMINFREQ                 =45;//���æ������ʱ��СƵ��
Const           QNV_PARAM_ADBUSYMAXFREQ                 =46;//���æ������ʱ���Ƶ��

//�������
const		QNV_PARAM_AM_MIC			=50;//MIC����
const		QNV_PARAM_AM_SPKOUT			=51;//����spk����
const		QNV_PARAM_AM_LINEIN			=52;//��·��������
const		QNV_PARAM_AM_LINEOUT			=53;//mic����·����+��������������·����
const		QNV_PARAM_AM_DOPLAY			=54;//�����������

const		QNV_PARAM_CITYCODE			=60;//��������,�ʺ��й���½
const		QNV_PARAM_PROXYDIAL			=61;//������

const		QNV_PARAM_FINDSVRTIMEOUT		=70;//�����Զ�CC������ʱʱ��
const		QNV_PARAM_CONFJITTERBUF			=71;//���齻���Ķ�̬�����С

const		QNV_PARAM_RINGTHRESHOLD			=80;//���������źŷ�������

const		QNV_PARAM_DTMFCALLIDLEVEL		=100;//dtmf���������ʱ�������������(0-7)
const		QNV_PARAM_DTMFCALLIDNUM			=101;//dtmf���������ʱ����ĳ���ʱ��(2-10)
const		QNV_PARAM_DTMFCALLIDVOL			=102;//dtmf���������ʱ���������Ҫ��

//

//�豸����/״̬
//uCtrlType
const		QNV_CTRL_DOSHARE			=1;//�豸����
const		QNV_CTRL_DOHOOK				=2;//���ժ�һ�����
const		QNV_CTRL_DOPHONE			=3;//���Ƶ绰���Ƿ����,�ɿ��ƻ�������,ʵ��Ӳ�Ĳ�ɵ�
const		QNV_CTRL_DOPLAY				=4;//���ȿ��ƿ���
const		QNV_CTRL_DOLINETOSPK			=5;//��·�������������ö���ͨ��ʱ��
const		QNV_CTRL_DOPLAYTOSPK			=6;//���ŵ�����������
const		QNV_CTRL_DOMICTOLINE			=7;//MIC˵�������绰��
const		QNV_CTRL_ECHO				=8;//��/�رջ�������
const		QNV_CTRL_RECVFSK			=9;//��/�رս���FSK�������
const		QNV_CTRL_RECVDTMF			=10;//��/�رս���DTMF
const		QNV_CTRL_RECVSIGN			=11;//��/�ر��ź������
const		QNV_CTRL_WATCHDOG			=12;//�򿪹رտ��Ź�
const		QNV_CTRL_PLAYMUX			=13;//ѡ�����ȵ�����ͨ�� line1x/pcplay ch0/line2x/pcplay ch1
const		QNV_CTRL_PLAYTOLINE			=14;//���ŵ�������line
const		QNV_CTRL_SELECTLINEIN			=15;//ѡ���������·lineͨ��
const		QNV_CTRL_SELECTADCIN			=16;//ѡ�������Ϊ��·����MIC����
const		QNV_CTRL_PHONEPOWER			=17;//��/�رո���������ʹ��,���������������,dophone�л���,������������,���жԻ����Ĳ�������Ч
const		QNV_CTRL_RINGPOWER			=18;//��������ʹ��
const		QNV_CTRL_LEDPOWER			=19;//LEDָʾ��
const		QNV_CTRL_LINEOUT			=20;//��·���ʹ��
const		QNV_CTRL_SWITCHOUT			=21;//Ӳ����������
const		QNV_CTRL_UPLOAD				=22;//��/�ر��豸USB�����ϴ�����,�رպ󽫽��ղ����豸��������
const		QNV_CTRL_DOWNLOAD			=23;//��/�ر��豸USB�������ع���,�رպ󽫲��ܷ�������/���ŵ��豸
const		QNV_CTRL_POLARITY			=24;//���ؼ��Է�תժ�����
const		QNV_CTRL_ADBUSY				=25;//�Ƿ�򿪼��æ������ʱ����(ֻ����ʹ����·��������ʱ����ͬʱ�һ��Żᴥ��æ�������ӵĻ���,��ͨ�û�����Ҫʹ��)
const		QNV_CTRL_RECVCALLIN			=26;//��/�ر����������
const		QNV_CTRL_READFRAMENUM			=27;//һ�������ȡ��USB֡������Խ��ռ��CPUԽС���ӳ�Ҳ��Խ��һ֡Ϊ4ms,���30֡��Ҳ�������÷�ΧΪ(1-30)
const		QNV_CTRL_DTMFCALLID			=28;//����DTMFģʽ�����������,Ĭ���ǿ�������

//����״̬��������(set),ֻ�ܻ�ȡ(get)
const		QNV_CTRL_PHONE				=30;//�绰��ժ�һ�״̬
const		QNV_CTRL_MICIN				=31;//mic����״̬
const		QNV_CTRL_RINGTIMES			=32;//��������Ĵ���
const		QNV_CTRL_RINGSTATE			=33;//��������״̬�������컹�ǲ���
//

//��������
//uPlayType
const		QNV_PLAY_FILE_START		       	=1;//��ʼ�����ļ�
const		QNV_PLAY_FILE_SETCALLBACK		=2;//���ò����ļ��ص�����
const		QNV_PLAY_FILE_SETVOLUME			=3;//���ò����ļ�����
const		QNV_PLAY_FILE_GETVOLUME			=4;//��ȡ�����ļ�����
const		QNV_PLAY_FILE_PAUSE			=5;//��ͣ�����ļ�
const		QNV_PLAY_FILE_RESUME			=6;//�ָ������ļ�
const		QNV_PLAY_FILE_ISPAUSE			=7;//����Ƿ�����ͣ����
const		QNV_PLAY_FILE_SETREPEAT			=8;//�����Ƿ�ѭ������
const		QNV_PLAY_FILE_ISREPEAT			=9;//����Ƿ���ѭ������
const		QNV_PLAY_FILE_SEEKTO			=11;//��ת��ĳ��ʱ��(ms)
const		QNV_PLAY_FILE_SETREPEATTIMEOUT	        =12;//����ѭ�����ų�ʱ����
const		QNV_PLAY_FILE_GETREPEATTIMEOUT	        =13;//��ȡѭ�����ų�ʱ����
const		QNV_PLAY_FILE_SETPLAYTIMEOUT	        =14;//���ò����ܹ���ʱʱ��(ms)
const		QNV_PLAY_FILE_GETPLAYTIMEOUT	        =15;//��ȡ�����ܹ���ʱʱ��
const		QNV_PLAY_FILE_TOTALLEN			=16;//�ܹ�ʱ��(ms)
const		QNV_PLAY_FILE_CURSEEK			=17;//��ǰ���ŵ��ļ�ʱ��λ��(ms)
const		QNV_PLAY_FILE_ELAPSE			=18;//�ܹ����ŵ�ʱ��(ms),�����ظ���,���˵�,��������ͣ��ʱ��
const		QNV_PLAY_FILE_ISPLAY			=19;//�þ���Ƿ��ڲ���
const		QNV_PLAY_FILE_ENABLEAGC			=20;//�򿪹ر��Զ�����
const		QNV_PLAY_FILE_ISENABLEAGC		=21;//����Ƿ���Զ�����
const		QNV_PLAY_FILE_STOP		       	=22;//ֹͣ����ָ���ļ�
const		QNV_PLAY_FILE_GETCOUNT			=23;//��ȡ�����ļ����ŵ�����,��������������û���˾Ϳ��Թر�����
const		QNV_PLAY_FILE_STOPALL			=24;//ֹͣ���������ļ�
const		QNV_PLAY_FILE_REMOTEBUFFERLEN		=25;//Զ�̲�����Ҫ���صĻ��峤��
const		QNV_PLAY_FILE_REMOTEBUFFERSEEK		=26;//Զ�̲����Ѿ����صĻ��峤��
//--------------------------------------------------------

const		QNV_PLAY_BUF_START			=1;//��ʼ���岥��
const		QNV_PLAY_BUF_SETCALLBACK		=2;//���û��岥�Żص�����
const		QNV_PLAY_BUF_SETWAVEFORMAT		=3;//���û��岥�������ĸ�ʽ
const		QNV_PLAY_BUF_WRITEDATA			=4;//д��������
const		QNV_PLAY_BUF_SETVOLUME			=5;//��������
const		QNV_PLAY_BUF_GETVOLUME			=6;//��ȡ����
const		QNV_PLAY_BUF_SETUSERVALUE		=7;//�����û��Զ�������
const		QNV_PLAY_BUF_GETUSERVALUE		=8;//��ȡ�û��Զ�������
const		QNV_PLAY_BUF_ENABLEAGC			=9;//�򿪹ر��Զ�����
const		QNV_PLAY_BUF_ISENABLEAGC		=10;//����Ƿ�����Զ�����
Const           QNV_PLAY_BUF_PAUSE                      =11;//��ͣ�����ļ�
Const           QNV_PLAY_BUF_RESUME                     =12;//�ָ������ļ�
Const           QNV_PLAY_BUF_ISPAUSE                    =13;//����Ƿ�����ͣ����
Const           QNV_PLAY_BUF_STOP                       =14;//ֹͣ���岥��
Const           QNV_PLAY_BUF_FREESIZE                   =15;//�����ֽ�
Const           QNV_PLAY_BUF_DATASIZE                   =16;//�����ֽ�
Const           QNV_PLAY_BUF_TOTALSAMPLES               =17;//�ܹ����ŵĲ�����
Const           QNV_PLAY_BUF_SETJITTERBUFSIZE           =18;//���ö�̬���峤�ȣ����������ݲ���Ϊ�պ��´β���ǰ�����ڱ�����ڸó��ȵ�����,�����ڲ����������ݰ����������綶��
Const           QNV_PLAY_BUF_GETJITTERBUFSIZE           =19;//��ȡ��̬���峤��
Const           QNV_PLAY_BUF_GETCOUNT                   =20;//��ȡ���ڻ��岥�ŵ�����,��������������û���˾Ϳ��Թر�����
Const           QNV_PLAY_BUF_STOPALL                    =21;//ֹͣ���в���
//-------------------------------------------------------

const		QNV_PLAY_MULTIFILE_START		=1;//��ʼ���ļ���������
const		QNV_PLAY_MULTIFILE_PAUSE		=2;//��ͣ���ļ���������
const		QNV_PLAY_MULTIFILE_RESUME		=3;//�ָ����ļ���������
const		QNV_PLAY_MULTIFILE_ISPAUSE		=4;//����Ƿ���ͣ�˶��ļ���������
const		QNV_PLAY_MULTIFILE_SETVOLUME	        =5;//���ö��ļ���������
const		QNV_PLAY_MULTIFILE_GETVOLUME	        =6;//��ȡ���ļ���������
const		QNV_PLAY_MULTIFILE_ISSTART	        =7;//�Ƿ������˶��ļ���������
const		QNV_PLAY_MULTIFILE_STOP			=8;//ֹͣ���ļ���������
const		QNV_PLAY_MULTIFILE_STOPALL		=9;//ֹͣȫ�����ļ���������
//--------------------------------------------------------

const		QNV_PLAY_STRING_INITLIST		=1;//��ʼ���ַ������б�
const		QNV_PLAY_STRING_START			=2;//��ʼ�ַ�����
const		QNV_PLAY_STRING_PAUSE			=3;//��ͣ�ַ�����
const		QNV_PLAY_STRING_RESUME			=4;//�ָ��ַ�����
const		QNV_PLAY_STRING_ISPAUSE			=5;//����Ƿ���ͣ���ַ�����
const		QNV_PLAY_STRING_SETVOLUME		=6;//�����ַ���������
const		QNV_PLAY_STRING_GETVOLUME		=7;//��ȡ�ַ���������
const		QNV_PLAY_STRING_ISSTART 		=8;//�Ƿ��������ַ�����
const		QNV_PLAY_STRING_STOP			=9;//ֹͣ�ַ�����
const		QNV_PLAY_STRING_STOPALL			=10;//ֹͣȫ���ַ�����

//--------------------------------------------------------

//¼������
//uRecordType
const		QNV_RECORD_FILE_START			=1;//��ʼ�ļ�¼��
const		QNV_RECORD_FILE_PAUSE			=2;//��ͣ�ļ�¼��
const		QNV_RECORD_FILE_RESUME			=3;//�ָ��ļ�¼��
const		QNV_RECORD_FILE_ISPAUSE			=4;//����Ƿ���ͣ�ļ�¼��
const		QNV_RECORD_FILE_ELAPSE			=5;//��ȡ�Ѿ�¼����ʱ�䳤��,��λ(s)
const		QNV_RECORD_FILE_SETVOLUME		=6;//�����ļ�¼������
const		QNV_RECORD_FILE_GETVOLUME		=7;//��ȡ�ļ�¼������
const		QNV_RECORD_FILE_PATH			=8;//��ȡ�ļ�¼����·��
const		QNV_RECORD_FILE_STOP			=9;//ֹͣĳ���ļ�¼��
const		QNV_RECORD_FILE_STOPALL			=10;//ֹͣȫ���ļ�¼��
const		QNV_RECORD_FILE_COUNT			=11;//��ȡ����¼��������
const		QNV_RECORD_FILE_SETROOT			=20;//����Ĭ��¼��Ŀ¼
const		QNV_RECORD_FILE_GETROOT			=21;//��ȡĬ��¼��Ŀ¼
//----------------------------------------------------------

const		QNV_RECORD_BUF_HWND_START		=1;//��ʼ����¼�����ڻص�
const		QNV_RECORD_BUF_HWND_STOP		=2;//ֹͣĳ������¼�����ڻص�
const		QNV_RECORD_BUF_HWND_STOPALL		=3;//ֹͣȫ������¼�����ڻص�
const		QNV_RECORD_BUF_CALLBACK_START	        =4;//��ʼ����¼���ص�
const		QNV_RECORD_BUF_CALLBACK_STOP	        =5;//ֹͣĳ������¼���ص�
const		QNV_RECORD_BUF_CALLBACK_STOPALL	        =6;//ֹͣȫ������¼���ص�
const		QNV_RECORD_BUF_SETCBSAMPLES		=7;//���ûص�������,ÿ��8K,�����Ҫ20ms�ص�һ�ξ�����Ϊ20*8=160,/Ĭ��Ϊ20ms�ص�һ��
const		QNV_RECORD_BUF_GETCBSAMPLES		=8;//��ȡ���õĻص�������
const		QNV_RECORD_BUF_ENABLEECHO		=9;//�򿪹ر��Զ�����
const		QNV_RECORD_BUF_ISENABLEECHO		=10;//����Զ������Ƿ��
const		QNV_RECORD_BUF_PAUSE			=11;//��ͣ����¼��
const		QNV_RECORD_BUF_ISPAUSE			=12;//����Ƿ���ͣ����¼��
const		QNV_RECORD_BUF_RESUME			=13;//�ָ�����¼��
const		QNV_RECORD_BUF_SETVOLUME		=14;//���û���¼������
const		QNV_RECORD_BUF_GETVOLUME		=15;//��ȡ����¼������
const		QNV_RECORD_BUF_SETWAVEFORMAT	        =16;//����¼���ص������������ʽ,Ĭ��Ϊ8K,16λ,wav����
const		QNV_RECORD_BUF_GETWAVEFORMAT	        =17;//��ȡ¼���ص������������ʽ

const		QNV_RECORD_BUF_GETCBMSGID		=100;//��ѯ����¼���Ĵ��ڻص�����ϢID,Ĭ��ΪBRI_RECBUF_MESSAGE
const		QNV_RECORD_BUF_SETCBMSGID		=101;//���û���¼���Ĵ��ڻص�����ϢID,Ĭ��ΪBRI_RECBUF_MESSAGE
//--------------------------------------------------------

//�������
//uConferenceType
const		QNV_CONFERENCE_CREATE			=1;//��������
const		QNV_CONFERENCE_ADDTOCONF		=2;//����ͨ����ĳ������
const		QNV_CONFERENCE_GETCONFID		=3;//��ȡĳ��ͨ���Ļ���ID
const		QNV_CONFERENCE_SETSPKVOLUME		=4;//���û�����ĳ��ͨ����������
const		QNV_CONFERENCE_GETSPKVOLUME		=5;//��ȡ������ĳ��ͨ����������
const		QNV_CONFERENCE_SETMICVOLUME		=6;//���û�����ĳ��ͨ��¼������
const		QNV_CONFERENCE_GETMICVOLUME		=7;//��ȡ������ĳ��ͨ��¼������
const		QNV_CONFERENCE_PAUSE			=8;//��ͣĳ������
const		QNV_CONFERENCE_RESUME			=9;//�ָ�ĳ������
const		QNV_CONFERENCE_ISPAUSE			=10;//����Ƿ���ͣ��ĳ������
const		QNV_CONFERENCE_ENABLESPK		=11;//�򿪹رջ�����������
const		QNV_CONFERENCE_ISENABLESPK		=12;//���������������Ƿ��
const		QNV_CONFERENCE_ENABLEMIC		=13;//�򿪹رջ�����˵����
const		QNV_CONFERENCE_ISENABLEMIC		=14;//��������˵�����Ƿ��
const		QNV_CONFERENCE_ENABLEAGC		=15;//�򿪹ر��Զ�����
const		QNV_CONFERENCE_ISENABLEAGC		=16;//����Ƿ�����Զ�����
const		QNV_CONFERENCE_DELETECHANNEL	        =17;//��ͨ���ӻ�����ɾ��
const		QNV_CONFERENCE_DELETECONF		=18;//ɾ��һ������
const		QNV_CONFERENCE_DELETEALLCONF	        =19;//ɾ��ȫ������
const		QNV_CONFERENCE_GETCONFCOUNT		=20;//��ȡ��������
const		QNV_CONFERENCE_SETJITTERBUFSIZE		=21;//���û��鶯̬���峤��
const		QNV_CONFERENCE_GETJITTERBUFSIZE		=22;//��ȡ���鶯̬���峤��

const		QNV_CONFERENCE_RECORD_START		=30;//��ʼ¼��
const		QNV_CONFERENCE_RECORD_PAUSE		=31;//��ͣ¼��
const		QNV_CONFERENCE_RECORD_RESUME	        =32;//�ָ�¼��
const		QNV_CONFERENCE_RECORD_ISPAUSE	        =33;//����Ƿ���ͣ¼��
const		QNV_CONFERENCE_RECORD_FILEPATH	        =34;//��ȡ¼���ļ�·��
const		QNV_CONFERENCE_RECORD_ISSTART	        =35;//�������Ƿ��Ѿ�������¼��
const		QNV_CONFERENCE_RECORD_STOP		=36;//ָֹͣ������¼��
const		QNV_CONFERENCE_RECORD_STOPALL	        =37;//ֹͣȫ������¼��
//--------------------------------------------------------

//speech����ʶ��
const		QNV_SPEECH_CONTENTLIST			=1;//����ʶ���������б�
const		QNV_SPEECH_STARTSPEECH			=2;//��ʼʶ��
const		QNV_SPEECH_ISSPEECH		       	=3;//����Ƿ�����ʶ��
const		QNV_SPEECH_STOPSPEECH			=4;//ֹͣʶ��
const		QNV_SPEECH_GETRESULT			=5;//��ȡʶ���Ľ��
const		QNV_SPEECH_GETRESULTEX			=6;//��ȡʶ���Ľ��,ʹ�ø����ڴ淽ʽ
//------------------------------------------------------------

//����ģ��ӿ�
const		QNV_FAX_LOAD			   	=1;//������������ģ��
const		QNV_FAX_UNLOAD			  	=2;//ж�ش���ģ��
const		QNV_FAX_STARTSEND		   	=3;//��ʼ���ʹ���
const		QNV_FAX_STOPSEND		   	=4;//ֹͣ���ʹ���
const		QNV_FAX_STARTRECV		  	=5;//��ʼ���մ���
const		QNV_FAX_STOPRECV		  	=6;//ֹͣ���մ���
const		QNV_FAX_STOP			  	=7;//ֹͣȫ��
const		QNV_FAX_PAUSE			  	=8;//��ͣ
const		QNV_FAX_RESUME			  	=9;//�ָ�
const		QNV_FAX_ISPAUSE			  	=10;//�Ƿ���ͣ
const		QNV_FAX_TYPE			   	=11;//����״̬�ǽ��ܻ��߷���
const		QNV_FAX_TRANSMITSIZE			=12;//�Ѿ����͵�ͼ�����ݴ�С
const		QNV_FAX_IMAGESIZE		   	=13;//�ܹ���Ҫ����ͼ�����ݴ�С
const   	QNV_FAX_SAVESENDFILE			=14;//���淢�͵Ĵ���ͼƬ
//----------------------------------------------------------

//����event
//ueventType
const		QNV_EVENT_POP			 	=1;//��ȡ���Զ�ɾ����ǰ�¼�,pValue->PBRI_EVENT
const		QNV_EVENT_POPEX			 	=2;//��ȡ���Զ�ɾ����ǰ�¼�,pValue->�ַ��ָ���ʽ:chid,type,handle,result,data
const		QNV_EVENT_TYPE			 	=3;//��ȡ�¼�����,��ȡ�󲻻��Զ�ɾ������ȡ�ɹ���ʹ�� QNV_GENERAL_EVENT_REMOVEɾ�����¼�
const		QNV_EVENT_HANDLE		  	=4;//��ȡ�¼����ֵ
const		QNV_EVENT_RESULT		  	=5;//��ȡ�¼���ֵ
const		QNV_EVENT_PARAM 		  	=6;//��ȡ�¼���������
const		QNV_EVENT_DATA			  	=7;//��ȡ�¼�����
const		QNV_EVENT_DATAEX		  	=8;//��ȡ�¼���������

const		QNV_EVENT_REMOVE		  	=20;//ɾ�����ϵ��¼�
const		QNV_EVENT_REMOVEALL		 	=21;//ɾ�������¼�

const		QNV_EVENT_REGWND		 	=30;//ע�������Ϣ�Ĵ��ھ��
const		QNV_EVENT_UNREGWND		   	=31;//ɾ��������Ϣ�Ĵ��ھ��
const		QNV_EVENT_REGCBFUNC		   	=32;//ע���¼��ص�����
const		QNV_EVENT_REGCBFUNCEX			=33;//ע���¼��ص�����(�ṹ�巽ʽ)
const		QNV_EVENT_UNREGCBFUNC			=34;//ɾ���¼��ص�����

const		QNV_EVENT_GETEVENTMSGID			=100;//��ѯ���ڻص�����ϢID,Ĭ��ΪBRI_EVENT_MESSAGE
const		QNV_EVENT_SETEVENTMSGID			=101;//���ô��ڻص�����ϢID,Ĭ��ΪBRI_EVENT_MESSAGE
//-----------------------------------------------------------

//����general
//uGeneralType
const		QNV_GENERAL_STARTDIAL			=1;//��ʼ����
const		QNV_GENERAL_SENDNUMBER			=2;//���β���
const		QNV_GENERAL_REDIAL		 	=3;//�ز����һ�κ��еĺ���,�����˳���ú��뱻�ͷ�
const		QNV_GENERAL_STOPDIAL			=4;//ֹͣ����
const		QNV_GENERAL_ISDIALING			=5;//�Ƿ��ڲ���

const		QNV_GENERAL_STARTRING			=10;//phone������
const		QNV_GENERAL_STOPRING			=11;//phone������ֹͣ
const		QNV_GENERAL_ISRINGING			=12;//phone���Ƿ�������

const		QNV_GENERAL_STARTFLASH			=20;//�Ĳ��
const		QNV_GENERAL_STOPFLASH			=21;//�Ĳ��ֹͣ
const		QNV_GENERAL_ISFLASHING			=22;//�Ƿ������Ĳ��

const		QNV_GENERAL_STARTREFUSE			=30;//�ܽӵ�ǰ����
const		QNV_GENERAL_STOPREFUSE			=31;//��ֹ�ܽӲ���
const		QNV_GENERAL_ISREFUSEING			=32;//�Ƿ����ھܽӵ�ǰ����

const		QNV_GENERAL_GETCALLIDTYPE		=50;//��ȡ���κ���������������
const		QNV_GENERAL_GETCALLID			=51;//��ȡ���κ�����������
const		QNV_GENERAL_GETTELDIALCODE		=52;//��ȡ���ε绰�������ĺ�������,return buf
const		QNV_GENERAL_GETTELDIALCODEEX	        =53;//��ȡ���ε绰�������ĺ�������,outbuf
const		QNV_GENERAL_RESETTELDIALBUF		=54;//��յ绰���ĺ��뻺��
const		QNV_GENERAL_GETTELDIALLEN		=55;//�绰���Ѳ��ĺ��볤��

const		QNV_GENERAL_STARTSHARE			=60;//�����豸�������
const		QNV_GENERAL_STOPSHARE			=61;//ֹͣ�豸�������
const		QNV_GENERAL_ISSHARE		 	=62;//�Ƿ������豸�������ģ��

const		QNV_GENERAL_ENABLECALLIN		=70;//��ֹ/�������ߺ���
const		QNV_GENERAL_ISENABLECALLIN		=71;//�����Ƿ��������
const		QNV_GENERAL_ISLINEHOOK			=72;//�����Ƿ�ժ��״̬(�绰��ժ��������line��������ժ������ʾժ��״̬)
const		QNV_GENERAL_ISLINEFREE			=73;//�����Ƿ����(û��ժ������û�������ʾ����)


const		QNV_GENERAL_RESETRINGBACK		=80;//��λ��⵽�Ļ���,�����������
const		QNV_GENERAL_CHECKCHANNELID		=81;//���ͨ��ID�Ƿ�Ϸ�
const		QNV_GENERAL_CHECKDIALTONE		=82;//��Ⲧ����
const		QNV_GENERAL_CHECKSILENCE		=83;//�����·����
const		QNV_GENERAL_CHECKVOICE			=84;//�����·����
const		QNV_GENERAL_CHECKLINESTATE		=85;//�����·״̬(�Ƿ����������/�Ƿ�ӷ�)
const		QNV_GENERAL_GETMAXPOWER			=86;//��ȡ��ǰ�����������

const		QNV_GENERAL_SETUSERVALUE		=90;//�û��Զ���ͨ������,ϵͳ�˳����Զ��ͷ�
const		QNV_GENERAL_SETUSERSTRING		=91;//�û��Զ���ͨ���ַ�,ϵͳ�˳����Զ��ͷ�
const		QNV_GENERAL_GETUSERVALUE		=92;//��ȡ�û��Զ���ͨ������
const		QNV_GENERAL_GETUSERSTRING		=93;//��ȡ�û��Զ���ͨ���ַ�

const		QNV_GENERAL_USEREVENT			=99;//�����û��Զ����¼�

//��ʼ��ͨ��INI�ļ�����
const		QNV_GENERAL_READPARAM			=100;//��ȡini�ļ�����ȫ��������ʼ��
const		QNV_GENERAL_WRITEPARAM			=101;//�Ѳ���д�뵽ini�ļ�
//

//call log
const		QNV_CALLLOG_BEGINTIME			=1;//��ȡ���п�ʼʱ��
const		QNV_CALLLOG_RINGBACKTIME		=2;//��ȡ����ʱ��
const		QNV_CALLLOG_CONNECTEDTIME		=3;//��ȡ��ͨʱ��
const		QNV_CALLLOG_ENDTIME		   	=4;//��ȡ����ʱ��
const		QNV_CALLLOG_CALLTYPE			=5;//��ȡ��������/����/����
const		QNV_CALLLOG_CALLRESULT			=6;//��ȡ���н��
const		QNV_CALLLOG_CALLID		        =7;//��ȡ����
const		QNV_CALLLOG_CALLRECFILE			=8;//��ȡ¼���ļ�·��
const		QNV_CALLLOG_DELRECFILE			=9;//ɾ����־¼���ļ���Ҫɾ��ǰ������ֹͣ¼��

const		QNV_CALLLOG_RESET			=20;//��λ����״̬
const		QNV_CALLLOG_AUTORESET			=21;//�Զ���λ
//���ߺ��������豸�޹�
//uToolType
const		QNV_TOOL_PSTNEND		 	=1;//���PSTN�����Ƿ��Ѿ�����
const		QNV_TOOL_CODETYPE		 	=2;//�жϺ�������(�ڵ��ֻ�/�̻�)
const		QNV_TOOL_LOCATION		 	=3;//��ȡ�������ڵ���Ϣ
const		QNV_TOOL_DISKFREESPACE			=4;//��ȡ��Ӳ��ʣ��ռ�(M)
const		QNV_TOOL_DISKTOTALSPACE			=5;//��ȡ��Ӳ���ܹ��ռ�(M)
const		QNV_TOOL_DISKLIST		 	=6;//��ȡӲ���б�
const		QNV_TOOL_RESERVID1			=7;//����
const		QNV_TOOL_RESERVID2			=8;//����
const		QNV_TOOL_CONVERTFMT	      		=9;//ת�������ļ���ʽ
const		QNV_TOOL_SELECTDIRECTORY		=10;//ѡ��Ŀ¼
const		QNV_TOOL_SELECTFILE			=11;//ѡ���ļ�
const		QNV_TOOL_CONVERTTOTIFF			=12;//ת��ͼƬ������tiff��ʽ,��������������ģ��,֧�ָ�ʽ:(*.doc,*.htm,*.html,*.mht,*.jpg,*.pnp.....)
const		QNV_TOOL_APMQUERYSUSPEND		=13;//�Ƿ�����PC�������/����,��USB�豸�����ʹ��
const		QNV_TOOL_SLEEP				=14;//�õ��ø÷������̵߳ȴ�N����
const		QNV_TOOL_SETUSERVALUE			=15;//�����û��Զ�����Ϣ
const		QNV_TOOL_GETUSERVALUE			=16;//��ȡ�û��Զ�����Ϣ
const		QNV_TOOL_SETUSERVALUEI			=17;//�����û��Զ�����Ϣ
const		QNV_TOOL_GETUSERVALUEI			=18;//��ȡ�û��Զ�����Ϣ
const		QNV_TOOL_ISFILEEXIST			=20;//��Ȿ���ļ��Ƿ����
const		QNV_TOOL_FSKENCODE			=21;//FSK����
const		QNV_TOOL_WRITELOG			=22;//д�ļ���־->userlogĿ¼

//------------------------------------------------------

//�洢����
const		QNV_STORAGE_PUBLIC_READ			 =1;//��ȡ������������
const		QNV_STORAGE_PUBLIC_READSTR		 =2;//��ȡ���������ַ�������,����'\0'�Զ�����
const		QNV_STORAGE_PUBLIC_WRITE		 =3;//д�빲����������
const		QNV_STORAGE_PUBLIC_SETREADPWD		 =4;//���ö�ȡ�����������ݵ�����
const		QNV_STORAGE_PUBLIC_SETWRITEPWD		 =5;//����д�빲���������ݵ�����
const		QNV_STORAGE_PUBLIC_GETSPACESIZE		 =6;//��ȡ�洢�ռ䳤��


//Զ�̲���
//RemoteType
const		QNV_REMOTE_UPLOADFILE			=1;//�ϴ��ļ���WEB������(httpЭ��)
const		QNV_REMOTE_DOWNLOADFILE			=2;//����Զ���ļ�
const		QNV_REMOTE_UPLOADDATA			=3;//�ϴ��ַ����ݵ�WEB������(send/post)
const		QNV_REMOTE_UPLOADLOG			=4;//�����ϴ���ǰû�гɹ��ļ�¼
const		QNV_REMOTE_CLEARLOG			=5;//ɾ������δ�ɹ�����־
//--------------------------------------------------------

//CC����
const		QNV_CCCTRL_SETLICENSE			=1;//����license
const		QNV_CCCTRL_SETSERVER			=2;//���÷�����IP��ַ
const		QNV_CCCTRL_LOGIN		   	=3;//��½
const		QNV_CCCTRL_LOGOUT		  	=4;//�˳�
const		QNV_CCCTRL_ISLOGON		   	=5;//�Ƿ��½�ɹ���
const		QNV_CCCTRL_REGCC		   	=6;//ע��CC����
//
//����
const		QNV_CCCTRL_CALL_START			=1;//����CC
const		QNV_CCCTRL_CALL_VOIP			=2;//VOIP�����̻�
const		QNV_CCCTRL_CALL_STOP			=3;//ֹͣ����
const		QNV_CCCTRL_CALL_ACCEPT			=4;//��������
const		QNV_CCCTRL_CALL_BUSY			=5;//����æ��ʾ
const		QNV_CCCTRL_CALL_REFUSE			=6;//�ܽ�
const		QNV_CCCTRL_CALL_STARTPLAYFILE	        =7;//�����ļ�
const		QNV_CCCTRL_CALL_STOPPLAYFILE	        =8;//ֹͣ�����ļ�
const		QNV_CCCTRL_CALL_STARTRECFILE	        =9;//��ʼ�ļ�¼��
const		QNV_CCCTRL_CALL_STOPRECFILE		=10;//ֹͣ�ļ�¼��
const   	QNV_CCCTRL_CALL_HOLD			=11;//����ͨ��,��Ӱ�첥���ļ�
const		QNV_CCCTRL_CALL_UNHOLD			=12;//�ָ�ͨ��
const		QNV_CCCTRL_CALL_SWITCH			=13;//����ת�Ƶ�����CC

const		QNV_CCCTRL_CALL_CONFHANDLE		=20;//��ȡ���о�����ڵĻ�����

//
//��Ϣ/����
const		QNV_CCCTRL_MSG_SENDMSG			=1;//������Ϣ
const		QNV_CCCTRL_MSG_SENDCMD			=2;//��������
const		QNV_CCCTRL_MSG_REPLYWEBIM		=3;//�ظ�WEB801��Ϣ
const		QNV_CCCTRL_MSG_REPLYWEBCHECK		=4;//Ӧ��WEB801����״̬��ѯ
//
//����
const		QNV_CCCTRL_CONTACT_ADD			=1;//���Ӻ���
const		QNV_CCCTRL_CONTACT_DELETE		=2;//ɾ������
const		QNV_CCCTRL_CONTACT_ACCEPT		=3;//���ܺ���
const		QNV_CCCTRL_CONTACT_REFUSE		=4;//�ܾ�����
const		QNV_CCCTRL_CONTACT_GET			=5;//��ȡ����״̬

//������Ϣ/�Լ�����Ϣ
const		QNV_CCCTRL_CCINFO_OWNERCC	        =1;//��ȡ���˵�½��CC
const		QNV_CCCTRL_CCINFO_NICK		        =2;//��ȡCC���ǳ�,���û������CC�ͱ�ʾ��ȡ���˵��ǳ�

//socket �ն˿���
const		QNV_SOCKET_CLIENT_CONNECT		=1;//���ӵ�������
const		QNV_SOCKET_CLIENT_DISCONNECT		=2;//�Ͽ�������
const		QNV_SOCKET_CLIENT_STARTRECONNECT	=3;//�Զ�����������
const		QNV_SOCKET_CLIENT_STOPRECONNECT		=4;//ֹͣ�Զ�����������
const		QNV_SOCKET_CLIENT_SENDDATA		=5;//��������


const           QNVDLLNAME                              ='qnviccub.dll';
//------------------------------------------------------------
//�ӿں����б�
//
// ���豸
//BRIINT32	BRISDKLIBAPI	QNV_OpenDevice(BRIUINT32 uDevType,BRIUINT32 uValue,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_OpenDevice(uDevType:longint;uValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// �ر��豸
//BRIINT32	BRISDKLIBAPI	QNV_CloseDevice(BRIUINT32 uDevType);//C++ԭ��
function                        QNV_CloseDevice(uDevType:longint;uValue:longint):longint;stdcall;External QNVDLLNAME;

// set dev ctrl
//BRIINT32	BRISDKLIBAPI	QNV_SetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType,BRIINT32 nValue);//C++ԭ��
function                        QNV_SetDevCtrl(nChannelID:BRIINT16;uCtrlType:longint;nValue:longint):longint;stdcall;External QNVDLLNAME;

// get dev ctrl
//BRIINT32	BRISDKLIBAPI	QNV_GetDevCtrl(BRIINT16 nChannelID,BRIUINT32 uCtrlType);//C++ԭ��
function                        QNV_GetDevCtrl(nChannelID:BRIINT16;uCtrlType:longint):longint;stdcall;External QNVDLLNAME;

// set param
//BRIINT32	BRISDKLIBAPI	QNV_SetParam(BRIINT16 nChannelID,BRIUINT32 uParamType,BRIINT32 nValue);//C++ԭ��
function                        QNV_SetParam(nChannelID:BRIINT16;uParamType:longint;nValue:longint):longint;stdcall;External QNVDLLNAME;

// get param
//BRIINT32	BRISDKLIBAPI	QNV_GetParam(BRIINT16 nChannelID,BRIUINT32 uParamType);//C++ԭ��
function                        QNV_GetParam(nChannelID:BRIINT16;uParamType:longint):longint;stdcall;External QNVDLLNAME;

// play file
//BRIINT32	BRISDKLIBAPI	QNV_PlayFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_PlayFile(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// play buf
//BRIINT32	BRISDKLIBAPI	QNV_PlayBuf(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_PlayBuf(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// play multifile
//BRIINT32	BRISDKLIBAPI	QNV_PlayMultiFile(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_PlayMultiFile(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// play string
//BRIINT32	BRISDKLIBAPI	QNV_PlayString(BRIINT16 nChannelID,BRIUINT32 uPlayType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_PlayString(nChannelID:BRIINT16;uPlayType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// record file
//BRIINT32	BRISDKLIBAPI	QNV_RecordFile(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_RecordFile(nChannelID:BRIINT16;uRecordType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// record buf
//BRIINT32	BRISDKLIBAPI	QNV_RecordBuf(BRIINT16 nChannelID,BRIUINT32 uRecordType,BRIINT32 nValue,BRIINT32 nValueEx,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_RecordBuf(nChannelID:BRIINT16;uRecordType:longint;nValue:longint;nValueEx:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// conference
//BRIINT32	BRISDKLIBAPI	QNV_Conference(BRIINT16 nChannelID,BRIINT32 nConfID,BRIUINT32 uConferenceType,BRIINT32 nValue,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_Conference(nChannelID:BRIINT16;nConfID:longint;uConferenceType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// speech
//BRIINT32	BRISDKLIBAPI	QNV_Speech(BRIINT16 nChannelID,BRIUINT32 uSpeechType,BRIINT32 nValue,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_Speech(nChannelID:BRIINT16;uSpeechType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// fax
//BRIINT32	BRISDKLIBAPI	QNV_Fax(BRIINT16 nChannelID,BRIUINT32 uFaxType,BRIINT32 nValue,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_Fax(nChannelID:BRIINT16;uFaxType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// event
//BRIINT32	BRISDKLIBAPI	QNV_Event(BRIINT16 nChannelID,BRIUINT32 uEventType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pOutValue,BRIINT32 nBufSize);//C++ԭ��
function                        QNV_Event(nChannelID:BRIINT16;uEventType:longint;nValue:longint;pInValue:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;
function                        QNV_Event_E(nChannelID:BRIINT16;uEventType:longint;nValue:longint;pInValue:BRIPCHAR8;e:PTBriEvent_Data;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// general
//BRIINT32	BRISDKLIBAPI	QNV_General(BRIINT16 nChannelID,BRIUINT32 uGeneralType,BRIINT32 nValue,BRICHAR8 *pValue);//C++ԭ��
function                        QNV_General(nChannelID:BRIINT16;uGeneralType:longint;nValue:longint;pValue:BRIPCHAR8):longint;stdcall;External QNVDLLNAME;

// pstn call log
//BRIINT32	BRISDKLIBAPI	QNV_CallLog(BRIINT16 nChannelID,BRIUINT32 uLogType,BRICHAR8 *pValue,BRIINT32 nValue);//C++ԭ��
function                        QNV_CallLog(nChannelID:BRIINT16;uLogType:longint;pValue:BRIPCHAR8;nValue:longint):longint;stdcall;External QNVDLLNAME;

// devinfo
//BRIINT32	BRISDKLIBAPI	QNV_DevInfo(BRIINT16 nChannelID,BRIUINT32 uGeneralType);//C++ԭ��
function                        QNV_DevInfo(nChannelID:BRIINT16;uGeneralType:longint):longint;stdcall;External QNVDLLNAME;

// tool
//BRIINT32	BRISDKLIBAPI	QNV_Tool(BRIUINT32 uToolType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize);//C++ԭ��
function                        QNV_Tool(uToolType:longint;nValue:longint;pInValue:BRIPCHAR8;pInValueEx:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// storage read write
//BRIINT32	BRISDKLIBAPI	QNV_Storage(BRIINT16 nDevID,BRIUINT32 uOPType,BRIUINT32 uSeek,BRICHAR8 *pPwd,BRICHAR8 *pValue,BRIINT32 nBufSize);
function                        QNV_Storage(nDevID:longint;uOPType:longint;uSeek:longint;pPwd:BRIPCHAR8;pValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// remote
//BRIINT32	BRISDKLIBAPI	QNV_Remote(BRIUINT32 uRemoteType,BRIINT32 nValue,BRICHAR8 *pInValue,BRICHAR8 *pInValueEx,BRICHAR8 *pOutValue,BRIINT32 nBufSize);//C++ԭ��
function                        QNV_Remote(uRemoteType:longint;nValue:longint;pInValue:BRIPCHAR8;pInValueEx:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;

// CC ctrl 
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl(BRIUINT32 uCtrlType,BRICHAR8 *pInValue,BRIINT32 nValue);//C++ԭ��
function                        QNV_CCCtrl(uCtrlType:longint;pInValue:BRIPCHAR8;nValue:longint):longint;stdcall;External QNVDLLNAME;

// CC Call
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Call(BRIUINT32 uCallType,BRIINT32 lSessHandle,BRICHAR8 *pInValue,BRIINT32 nValue);//C++ԭ��
function                        QNV_CCCtrl_Call(uCallType:longint;lSessHandle:longint;pInValue:BRIPCHAR8;nValue:longint):longint;stdcall;External QNVDLLNAME;

// CC msg
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Msg(BRIUINT32 uMsgType,BRICHAR8 *pDestCC,BRICHAR8 *pMsgValue,BRICHAR8 *pParam,BRIINT32 nReserv);//C++ԭ��
function                        QNV_CCCtrl_Msg(uMsgType:longint;pDestCC:BRIPCHAR8;pMsgValue:pChar;pParam:BRIPCHAR8;nReserv:longint):longint;stdcall;External QNVDLLNAME;
//
// CC contact
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_Contact(BRIUINT32 uContactType,BRICHAR8 *pCC,BRICHAR8 *pValue);//c++ԭ��
function                        QNV_CCCtrl_Contact(uContactType:longint;pCC:BRIPCHAR8;pValue:pChar):longint;stdcall;External QNVDLLNAME;
// CC contact info
//BRIINT32	BRISDKLIBAPI	QNV_CCCtrl_CCInfo(BRIUINT32 uInfoType,BRICHAR8 *pDestCC,BRICHAR8 *pOutValue,long nBufSize);/c++ ԭ��
function	        	QNV_CCCtrl_CCInfo(uInfoType:longint;pDestCC:BRIPCHAR8;pOutValue:BRIPCHAR8;nBufSize:longint):longint;stdcall;External QNVDLLNAME;
//

//BRIINT32	BRISDKLIBAPI	QNV_Socket_Client(BRIUINT32 uSktType,BRIINT32 nHandle,BRIINT32 nValue,BRICHAR8 *pInValue,BRIINT32 nInValueLen);//c++ԭ��
function                        QNV_Socket_Client(uSktType:longint;nHandle:longint;nValue:longint;pInValue:BRIPCHAR8;nInValueLen:longint):longint;stdcall;External QNVDLLNAME;

implementation

end.
