unit uCmdType;

interface

// phone operation

const EV_LOCAL_PHONE_HOOK      =       'evLocalPhoneHook';            //本地话筒摘机
const EV_LOCAL_PHONE_HANG      =       'evLocalPhoneHang';            //本地话筒挂机

const EV_REMOTE_PHONE_HOOK     =       'evRemotePhoneHook';          //远程话筒摘机
const EV_REMOTE_PHONE_HANG     =       'evRemotePhoneHang';          //远程话筒挂机

const EV_GET_CALL_ID           =       'evGetCallId';                //获取到来电号码
const EV_STOP_CALL_IN          =       'evStopCallIn';               //对方停止呼入产生一个未接电话

const EV_CALL_IN_RING          =       'evCallInRing';               //来电响铃
const EV_CALL_IN_START         =       'evCallInStart';              //来电开始
const EV_CALL_IN_ESTABLISHED   =       'evCallInEstablished';        //来电接通
const EV_CALL_IN_END           =       'evCallInEnd';                //来电结束

const EV_CALL_OUT_START_DIAL   =       'evCallOutStartDial';         //去电拨号开始
const EV_CALL_OUT_DIAL_END     =       'evCallOutDialEnd';           //去电拨号结束
const EV_CALL_OUT_RING_BACK    =       'evCallOutRingBack';          //拨号结束，检测到回铃

const EV_PSTNFree              =       'evPSTNFree';                 //电话线路空闲

const EV_DEV_ERROR             =       'evDevError';                 //硬件错误

const EV_SHOW_LOG              =       'evShowLog';                  //显示日志
const EV_SHOW_STATE            =       'evShowState';                //显示状态

// cmd

const CMD_START_DIAL           =       'cmdStartDial';                //开始拨号
const CMD_STOP_DIAL            =       'cmdStopDial';                 //停止拨号
const CMD_DO_HOOK              =       'cmdDoHook';                   //摘机、挂机
const CMD_DO_PHONE             =       'cmdDoPhone';                  //断线、连线
const CMD_CONFIRM_DIAL         =       'cmdConfirmDial';              //确认去电

const CMD_CONFIRM_CALL_IN      =       'cmdConfirmCallIn';            //确认来电
const CMD_REFUSE_CALL_IN       =       'cmdRefuseCallIn';             //拒接来电

const CMD_RESET_CALL           =       'cmdResetCall';                //清除通话日志
const CMD_ADD_COOKIE           =       'cmdAddCookie';                //addCookie

// 过时，换 startDial
//const DIAL_UP          =       'dialup';                 //拨打电话
//const HANG_UP          =       'hangup';                 //接听电话
//const HOOK_UP          =       'hookup';                 //挂掉电话

//const START_CALL_IN_   =       'startCallIn';            //有来电
//const HANG_CALL_IN     =       'hangCallIn';           //接听来电
//const HANG_PHONE_HOOK     =       'hangPhoneHook';     //来电摘机
//const HANG_PHONE_HOOK     =       'hangPhoneHook';     //来电摘机

//const HANG_CALL_OUT  =       'hangCallOut';            //接听去电
//const HOOK_CALL_OUT  =       'hookCallOut';            //挂掉去电
//const HOOK_CALL_IN   =       'hookCallIn';            //挂掉来电

//const EV_CALL_OUT_RING         =       'evCallOutRing';              //去电响铃
//const EV_CALL_OUT_START        =       'evCallOutStart';             //去电开始
//const EV_CALL_OUT_ESTABLISHED  =       'evCallOutEstablished';       //去电接通
//const EV_CALL_OUT_END          =       'evCallOutEnd';               //去电结束

//----------------------------------------------------------

implementation

end.
