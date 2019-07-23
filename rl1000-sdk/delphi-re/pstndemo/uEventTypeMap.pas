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
      S := '读取数据错误';
    end;
    1: begin
      S := '写入数据错误';
    end;
    2: begin
      S := '数据帧ID丢失,可能是CPU太忙';
    end;
    3: begin
      S := '设备已经被拔掉';
    end;
    4: begin
      S := '序列号冲突';
    end;
    else begin
      S := '未知错误';
    end;
  end;
  Result := S;
end;

function TEventTypeMap.getEventName(const id: BRIINT32): string;
begin
  if not FMap.tryGetValue(id, Result) then begin
    Result := '系统其它事件';
  end;
end;

class function TEventTypeMap.getEvent(const id: BRIINT32): string;
begin
  Result := gEventTypeMap.getEventName(id);
end;

procedure TEventTypeMap.addEvent(Map: TDictionary<BRIINT32, string>);
begin
  // 本地电话机摘机事件
  //const	BriEvent_PhoneHook				=1;
  map.add(BriEvent_PhoneHook, '本地电话机摘机事件');

  // 本地电话机挂机事件
  //const BriEvent_PhoneHang				=2;
  map.add(BriEvent_PhoneHang, '本地电话机挂机事件');

  // 外线通道来电响铃事件
  // BRI_EVENT.lResult		为响铃次数
  // BRI_EVENT.szData[0]='0'	开始1秒响铃
  // BRI_EVENT.szData[0]='1'	为1秒响铃完成，开始4秒静音
  //const BriEvent_CallIn					=3;
  map.add(BriEvent_CallIn, '外线通道来电响铃事件');

  // 得到来电号码
  // BRI_EVENT.lResult		来电号码模式(CALLIDMODE_FSK/CALLIDMODE_DTMF
  // BRI_EVENT.szData		保存的来电号码
  // 该事件可能在响铃前,也可能在响铃后
  //const BriEvent_GetCallID				=4;
  map.add(BriEvent_GetCallID, '得到来电号码');

  // 对方停止呼叫(产生一个未接电话)
  //const BriEvent_StopCallIn				=5;
  map.add(BriEvent_StopCallIn, '对方停止呼叫(产生一个未接电话)');

  // 调用开始拨号后，全部号码拨号结束
  //nst BriEvent_DialEnd				        =6;
  map.add(BriEvent_DialEnd, '调用开始拨号后，全部号码拨号结束');

  // 播放文件结束事件
  // BRI_EVENT.lResult	   播放文件时返回的句柄ID
  //nst BriEvent_PlayFileEnd			        =7;
  map.add(BriEvent_PlayFileEnd, '播放文件结束事件');

  // 多文件连播结束事件
  //const BriEvent_PlayMultiFileEnd		                =8;
  map.add(BriEvent_PlayMultiFileEnd, '多文件连播结束事件');

  //播放字符结束
  //const	BriEvent_PlayStringEnd			        =9;
  map.add(BriEvent_PlayStringEnd, '播放字符结束');

  // 播放文件结束准备重复播放
  // BRI_EVENT.lResult	   播放文件时返回的句柄ID
  //const BriEvent_RepeatPlayFile			        =10;
  map.add(BriEvent_RepeatPlayFile, '播放文件结束准备重复播放');

  // 给本地设备发送震铃信号时发送号码结束
  //const BriEvent_SendCallIDEnd			        =11;
  map.add(BriEvent_SendCallIDEnd, '给本地设备发送震铃信号时发送号码结束');

  //给本地设备发送震铃信号时超时
  //默认不会超时
  //const BriEvent_RingTimeOut			        =12;
  map.add(BriEvent_RingTimeOut, '给本地设备发送震铃信号时超时');

  //正在内线震铃
  //BRI_EVENT.lResult	   已经响铃的次数
  // BRI_EVENT.szData[0]='0'	开始一次响铃
  // BRI_EVENT.szData[0]='1'	一次响铃完成，准备静音
  //const BriEvent_Ringing				        =13;
  map.add(BriEvent_Ringing, '正在内线震铃');

  // 通话时检测到一定时间的静音.默认为5秒
  //const BriEvent_Silence				        =14;
  map.add(BriEvent_Silence, '通话时检测到一定时间的静音');

  // 线路接通时收到DTMF码事件
  // 该事件不能区分通话中是本地话机按键还是对方话机按键触发
  //const BriEvent_GetDTMFChar			        =15;
  map.add(BriEvent_GetDTMFChar, '线路接通时收到DTMF码事件');

  // 拨号后,被叫方摘机事件（该事件仅做参考,原因如下：）
  // 原因：
  // 该事件只适用于拨打是标准信号音的号码时，也就是拨号后带有标准回铃音的号码。
  // 如：当拨打的对方号码是彩铃(彩铃手机号)或系统提示音(179xx)都不是标准回铃音时该事件无效。
  //
  //const BriEvent_RemoteHook				=16;
  map.add(BriEvent_RemoteHook, '拨号后,被叫方摘机事件');

  // 被叫方挂机事件
  // 如果线路检测到被叫方摘机后，被叫方挂机时会触发该事件，不然被叫方挂机后就触发BriEvent_Busy事件
  // 该事件或者BriEvent_Busy的触发都表示PSTN线路已经被断开
  //const BriEvent_RemoteHang				=17;
  map.add(BriEvent_RemoteHang, '被叫方挂机事件');

  // 挂机事件
  // 如果线路检测到被叫方摘机后，被叫方挂机时会触发该事件，不然被叫方挂机后就触发BriEvent_Busy事件
  // 该事件或者BriEvent_Busy的触发都表示PSTN线路已经被断开

  // 检测到忙音事件,表示PSTN线路已经被断开
  //const BriEvent_Busy					=18;
  map.add(BriEvent_Busy, '检测到忙音事件,表示PSTN线路已经被断开');

  // 本地摘机后检测到拨号音
  //const BriEvent_DialTone				        =19;
  map.add(BriEvent_DialTone, '本地摘机后检测到拨号音');

  // 只有在本地话机摘机，没有调用软摘机时，检测到DTMF拨号
  //const BriEvent_PhoneDial				=20;
  map.add(BriEvent_PhoneDial, '只有在本地话机摘机，没有调用软摘机时，检测到DTMF拨号');

  // 本地电话机拨号结束呼出事件。
  // 也就时电话机拨号后接收到标准回铃音或者15秒超时
  // BRI_EVENT.lResult=0 检测到回铃音// 注意：如果线路是彩铃是不会触发该类型
  // BRI_EVENT.lResult=1 拨号超时
  // BRI_EVENT.lResult=2 动态检测拨号码结束(根据中国大陆的号码规则进行智能分析，仅做参考)
  // BRI_EVENT.szData[0]='1' 软摘机拨号结束后回铃了
  // BRI_EVENT.szData[0]='0' 电话机拨号中回铃了
  //const BriEvent_RingBack				        =21;
  map.add(BriEvent_RingBack, '本地电话机拨号结束呼出事件');

  // MIC插入状态
  // 只适用具有该功能的设备
  //const BriEvent_MicIn					=22;
  map.add(BriEvent_MicIn, 'MIC插入状态');

  // MIC拔出状态
  // 只适用具有该功能的设备
  //const BriEvent_MicOut					=23;
  map.add(BriEvent_MicOut, 'MIC拔出状态');

  // 拍插簧(Flash)完成事件，拍插簧完成后可以检测拨号音后进行二次拨号
  // BRI_EVENT.lResult=TEL_FLASH  用户使用电话机进行拍叉簧完成
  // BRI_EVENT.lResult=SOFT_FLASH 调用StartFlash函数进行拍叉簧完成
  //const BriEvent_FlashEnd				        =24;
  map.add(BriEvent_FlashEnd, '拍插簧(Flash)完成事件');

  // 拒接完成
  //const BriEvent_RefuseEnd				=25;
  map.add(BriEvent_RefuseEnd, '拒接完成');

  // 语音识别完成
  //const BriEvent_SpeechResult		        	=26;
  map.add(BriEvent_SpeechResult, '语音识别完成');

  //PSTN线路断开,线路进入空闲状态
  //当前没有软摘机而且话机也没摘机
  //const BriEvent_PSTNFree			        	=27;
  map.add(BriEvent_PSTNFree, 'PSTN线路断开,线路进入空闲状态');

  // 接收到对方准备发送传真的信号
  //const BriEvent_RemoteSendFax			        =30;
  map.add(BriEvent_RemoteSendFax, '接收到对方准备发送传真的信号');

  // 接收传真完成
  //const BriEvent_FaxRecvFinished	                	=31;
  map.add(BriEvent_FaxRecvFinished, '接收传真完成');

  // 接收传真失败
  //const BriEvent_FaxRecvFailed		        	=32;
  map.add(BriEvent_FaxRecvFailed, '接收传真失败');

  // 发送传真完成
  //const BriEvent_FaxSendFinished		                =33;
  map.add(BriEvent_FaxSendFinished, '发送传真完成');

  // 发送传真失败
  //const BriEvent_FaxSendFailed		        	=34;
  map.add(BriEvent_FaxSendFailed, '发送传真失败');

  // 启动声卡失败
  //const BriEvent_OpenSoundFailed		                =35;
  map.add(BriEvent_OpenSoundFailed, '发送传真失败');

  // 产生一个PSTN呼入/呼出日志
  //const BriEvent_CallLog				        =36;
  map.add(BriEvent_CallLog, '产生一个PSTN呼入/呼出日志');

  //检测到连续的静音
  //使用QNV_GENERAL_CHECKSILENCE启动后检测到设定的静音长度
  //const BriEvent_RecvSilence			        =37;
  map.add(BriEvent_RecvSilence, '检测到连续的静音');

  //检测到连续的声音
  //使用QNV_GENERAL_CHECKVOICE启动后检测到设定的声音长度
  //const BriEvent_RecvVoice				=38;
  map.add(BriEvent_RecvVoice, '检测到连续的声音');

  //远程上传事件
  //const BriEvent_UploadSuccess			        =50;
  map.add(BriEvent_UploadSuccess, '远程上传事件');

  //const BriEvent_UploadFailed			        =51;
  map.add(BriEvent_UploadFailed, '远程上传事件失败');

  // 远程连接已被断开
  //const BriEvent_RemoteDisconnect		                =52;
  map.add(BriEvent_RemoteDisconnect, '远程连接已被断开');

  //HTTP远程下载文件完成
  //BRI_EVENT.lResult	   启动下载时返回的本次操作的句柄
  //const BriEvent_DownloadSuccess				=60;
  map.add(BriEvent_DownloadSuccess, 'HTTP远程下载文件完成');

  //const BriEvent_DownloadFailed				=61;
  map.add(BriEvent_DownloadFailed, 'HTTP远程下载失败');

  //线路检测结果
  //BRI_EVENT.lResult 为检测结果信息
  //const BriEvent_CheckLine				=70;
  map.add(BriEvent_CheckLine, '线路检测结果');

  // 应用层调用软摘机/软挂机成功事件
  // BRI_EVENT.lResult=0 软摘机
  // BRI_EVENT.lResult=1 软挂机
  //const BriEvent_EnableHook				=100;
  map.add(BriEvent_EnableHook, '应用层调用软摘机/软挂机成功事件');

  // 喇叭被打开或者/关闭
  // BRI_EVENT.lResult=0 关闭
  // BRI_EVENT.lResult=1 打开
  //const BriEvent_EnablePlay				=101;
  map.add(BriEvent_EnablePlay, '喇叭被打开或者/关闭');

  // MIC被打开或者关闭
  // BRI_EVENT.lResult=0 关闭
  // BRI_EVENT.lResult=1 打开
  //const BriEvent_EnableMic				=102;
  map.add(BriEvent_EnableMic, 'MIC被打开或者关闭');

  // 耳机被打开或者关闭
  // BRI_EVENT.lResult=0 关闭
  // BRI_EVENT.lResult=1 打开
  //const BriEvent_EnableSpk				=103;
  map.add(BriEvent_EnableSpk, '耳机被打开或者关闭');

  // 电话机跟电话线(PSTN)断开/接通(DoPhone)
  // BRI_EVENT.lResult=0 断开
  // BRI_EVENT.lResult=1 接通
  //const BriEvent_EnableRing				=104;
  map.add(BriEvent_EnableRing, '电话机跟电话线(PSTN)断开/接通(DoPhone)');

  // 修改录音源 (无用/保留)
  // BRI_EVENT.lResult 录音源数值
  //const BriEvent_DoRecSource			        =105;
  map.add(BriEvent_DoRecSource, '修改录音源 (无用/保留)');

  // 开始软件拨号
  // BRI_EVENT.szData	准备拨的号码
  //const BriEvent_DoStartDial			        =106;
  map.add(BriEvent_DoStartDial, '开始软件拨号');

  //const BriEvent_EnablePlayMux			        =107;
  map.add(BriEvent_EnablePlayMux, '开始静音播放');

  // 接收到FSK信号，包括通话中FSK/来电号码的FSK
  //const BriEvent_RecvedFSK				=198;
  map.add(BriEvent_RecvedFSK, '接收到FSK信号，包括通话中FSK/来电号码的FSK');

  //设备错误
  //const BriEvent_DevErr					=199;
  map.add(BriEvent_DevErr, '设备错误');

end;

initialization
  //ShowMessage('1 ini');{单元初始化代码}
  gEventTypeMap := TEventTypeMap.create;

finalization
  //ShowMessage('1 final');{单元退出时的代码}
  gEventTypeMap.Free;

end.

