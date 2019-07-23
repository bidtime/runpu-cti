unit uCmdType;

interface

// phone operation

const EV_LOCAL_PHONE_HOOK      =       'evLocalPhoneHook';            //���ػ�Ͳժ��
const EV_LOCAL_PHONE_HANG      =       'evLocalPhoneHang';            //���ػ�Ͳ�һ�

const EV_REMOTE_PHONE_HOOK     =       'evRemotePhoneHook';          //Զ�̻�Ͳժ��
const EV_REMOTE_PHONE_HANG     =       'evRemotePhoneHang';          //Զ�̻�Ͳ�һ�

const EV_GET_CALL_ID           =       'evGetCallId';                //��ȡ���������
const EV_STOP_CALL_IN          =       'evStopCallIn';               //�Է�ֹͣ�������һ��δ�ӵ绰

const EV_CALL_IN_RING          =       'evCallInRing';               //��������
const EV_CALL_IN_START         =       'evCallInStart';              //���翪ʼ
const EV_CALL_IN_ESTABLISHED   =       'evCallInEstablished';        //�����ͨ
const EV_CALL_IN_END           =       'evCallInEnd';                //�������

const EV_CALL_OUT_START_DIAL   =       'evCallOutStartDial';         //ȥ�粦�ſ�ʼ
const EV_CALL_OUT_DIAL_END     =       'evCallOutDialEnd';           //ȥ�粦�Ž���
const EV_CALL_OUT_RING_BACK    =       'evCallOutRingBack';          //���Ž�������⵽����

const EV_PSTNFree              =       'evPSTNFree';                 //�绰��·����

const EV_DEV_ERROR             =       'evDevError';                 //Ӳ������

const EV_SHOW_LOG              =       'evShowLog';                  //��ʾ��־
const EV_SHOW_STATE            =       'evShowState';                //��ʾ״̬

// cmd

const CMD_START_DIAL           =       'cmdStartDial';                //��ʼ����
const CMD_STOP_DIAL            =       'cmdStopDial';                 //ֹͣ����
const CMD_DO_HOOK              =       'cmdDoHook';                   //ժ�����һ�
const CMD_DO_PHONE             =       'cmdDoPhone';                  //���ߡ�����
const CMD_CONFIRM_DIAL         =       'cmdConfirmDial';              //ȷ��ȥ��

const CMD_CONFIRM_CALL_IN      =       'cmdConfirmCallIn';            //ȷ������
const CMD_REFUSE_CALL_IN       =       'cmdRefuseCallIn';             //�ܽ�����

const CMD_RESET_CALL           =       'cmdResetCall';                //���ͨ����־
const CMD_ADD_COOKIE           =       'cmdAddCookie';                //addCookie

// ��ʱ���� startDial
//const DIAL_UP          =       'dialup';                 //����绰
//const HANG_UP          =       'hangup';                 //�����绰
//const HOOK_UP          =       'hookup';                 //�ҵ��绰

//const START_CALL_IN_   =       'startCallIn';            //������
//const HANG_CALL_IN     =       'hangCallIn';           //��������
//const HANG_PHONE_HOOK     =       'hangPhoneHook';     //����ժ��
//const HANG_PHONE_HOOK     =       'hangPhoneHook';     //����ժ��

//const HANG_CALL_OUT  =       'hangCallOut';            //����ȥ��
//const HOOK_CALL_OUT  =       'hookCallOut';            //�ҵ�ȥ��
//const HOOK_CALL_IN   =       'hookCallIn';            //�ҵ�����

//const EV_CALL_OUT_RING         =       'evCallOutRing';              //ȥ������
//const EV_CALL_OUT_START        =       'evCallOutStart';             //ȥ�翪ʼ
//const EV_CALL_OUT_ESTABLISHED  =       'evCallOutEstablished';       //ȥ���ͨ
//const EV_CALL_OUT_END          =       'evCallOutEnd';               //ȥ�����

//----------------------------------------------------------

implementation

end.
