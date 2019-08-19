unit uSimpleThread;
interface
uses
  System.Classes, System.SysUtils, System.SyncObjs;

type

  // 显示信息,调用方法 DoOnStatusMsg(AMsg);
  TOnStatusMsg = procedure(AMsg: string) of object;

  // 显示调试信息,一般用于显示出错信息,用法 DoOnDebugMsg(AMsg);
  TOnDebugMsg = TOnStatusMsg;

  TSimpleThread = class(TThread)
  public type // "执行过程"的类别定义

    TGeneralProc = procedure; // 普通的,即 procedure DoSomeThing;
    TObjectProc = procedure of object; // 类的,即 TXxxx.DoSomeThign; 用得多
    TAnonymousProc = reference to procedure; // 匿名的
  private type
    TProcKind = (pkGeneral, pkObject, pkAnonymous); // "执行过程"的类别
  private

    FGeneralProc: TGeneralProc;
    FObjProc: TObjectProc;
    FAnoProc: TAnonymousProc;

    FProcKind: TProcKind;

    FEvent: TEvent; // 用于阻塞，它是一个信号量
    FActiveX: boolean; // 是否在线程中支持 Com ,如果你要在线程中访问 IE 的话，就设定为 True

    FOnStatusMsg: TOnStatusMsg;
    FOnDebugMsg: TOnDebugMsg;

    FTagID: integer; // 给线程一个代号,在线程池的时候用来作区别
    FParam: integer; // 给线程一个参数，方便识别

    procedure SelfStart; // 触发线程运行

    procedure DoExecute; // 这个函数里面运行的代码是“线程空间”
    procedure DoOnException(e: exception); // 异常信息显示 调用 DoOnDebugMsg(AMsg);

    procedure SetTagID(const Value: integer);
    procedure SetParam(const Value: integer);

    procedure SetOnStatusMsg(const Value: TOnStatusMsg);
    procedure SetOnDebugMsg(const Value: TOnDebugMsg);

  protected

    FWaitStop: boolean; // 结束标志，可以在继承类中使用它，以确定线程是否停止运行

    procedure DoOnStatusMsg(AMsg: string); // 显示普通信息
    procedure DoOnDebugMsg(AMsg: string); // 显示调式信息

    procedure Execute; override; // 重载 TThread.Execute

    procedure OnThreadProcErr(e: exception); virtual; // 异常发生事件

    procedure WaitThreadStop; // 等待线程结束

    procedure BeforeExecute; virtual; // 看名字,不解释
    Procedure AfterExecute; virtual; // 看名字,不解释

    procedure SleepExceptStopped(ATimeOut: Cardinal); // 这个高大上了，要解释一下。
    { 有时线程没有任务时，就会休息一会儿，但是，休息的时候，可能会接收到退出线程的指令
      此函数就是在休息的时候也检查一下停止指令
    }

  public

    // 改变一下 Create 的参数,AllowedActiveX：是否允许线程代码访问 Com
    constructor Create(AllowedActiveX: boolean = false); reintroduce;

    destructor Destroy; override;

    procedure ExeProcInThread(AProc: TGeneralProc); overload; // 这三个,对外的接口。
    procedure ExeProcInThread(AProc: TObjectProc); overload;
    procedure ExeProcInThread(AProc: TAnonymousProc); overload;

    procedure StartThread; virtual;
    { 启动线程，一般只调用一次。
      以后就由线程的响应事件来执行了
    }

    procedure StopThread; virtual; // 停止线程

    property OnStatusMsg: TOnStatusMsg read FOnStatusMsg write SetOnStatusMsg;
    property OnDebugMsg: TOnDebugMsg read FOnDebugMsg write SetOnDebugMsg;
    property WaitStop: boolean read FWaitStop;
    property TagID: integer read FTagID write SetTagID;
    property Param: integer read FParam write SetParam;

  end;

implementation

uses
  ActiveX;

procedure TSimpleThread.AfterExecute;
begin
end;

procedure TSimpleThread.BeforeExecute;
begin
end;

constructor TSimpleThread.Create(AllowedActiveX: boolean);
var
  BGUID: TGUID;
begin
  inherited Create(false);
  FActiveX := AllowedActiveX;
  FreeOnTerminate := false; // 我们要手动Free线程
  CreateGUID(BGUID);
  FEvent := TEvent.Create(nil, true, false, GUIDToString(BGUID));
end;

destructor TSimpleThread.Destroy;
begin
  StopThread; // 先停止
  WaitThreadStop; // 再等待线程停止
  {
    在继承类的 Destroy 中，也要写上这两句. 如:
    暂时未找到更好的办法，这点代码省不了
    destructor TXXThread.Destroy;
    begin
    StopThread;
    WaitThreadStop;
    xxx.Free;
    Inherited;
    end;
  }
  FEvent.Free;
  inherited;
end;

procedure TSimpleThread.DoExecute; // 此函数内执行的代码,就是在多线程空间里运行
begin
  BeforeExecute;
  repeat

    FEvent.WaitFor;
    FEvent.ResetEvent; // 下次waitfor 一直等
    { 这里尝试了很多些，总 SelfStart 觉得有冲突，经过多次修改并使用证明，
      没有必要在这里加锁,因为只调用 startThread 一次，剩下的交给线程影应事件
    }

    if not Terminated then // 如果线程需要退出
    begin

      try

        case FProcKind of
          pkGeneral: FGeneralProc;
          pkObject: FObjProc;
          pkAnonymous: FAnoProc;
        end;

      except

        on e: exception do
        begin
          DoOnException(e);
        end;

      end;

    end;

  until Terminated;
  AfterExecute;
  //代码运行到这里，就表示这个线程不存在了。再也回不去了，必须释放资源了。
end;

procedure TSimpleThread.DoOnDebugMsg(AMsg: string);
begin
  if Assigned(FOnDebugMsg) then
    FOnDebugMsg(AMsg);
end;

procedure TSimpleThread.DoOnException(e: exception);
var
  sErrMsg: string;
begin
  sErrMsg := 'ClassName:' + ClassName + #13#10;
  sErrMsg := sErrMsg + 'TagID:' + IntToStr(FTagID) + #13#10;
  sErrMsg := sErrMsg + 'Param:' + IntToStr(Param) + #13#10;
  sErrMsg := sErrMsg + 'ErrMsg:' + e.Message + #13#10;
  DoOnDebugMsg(sErrMsg);
  OnThreadProcErr(e);
end;

procedure TSimpleThread.DoOnStatusMsg(AMsg: string);
begin
  if Assigned(FOnStatusMsg) then
    FOnStatusMsg(AMsg);
end;

procedure TSimpleThread.Execute;
begin
  //是否支持 Com
  if FActiveX then
  begin
    CoInitialize(nil);
    try
      DoExecute;
    finally
      CoUninitialize;
    end;
  end
  else
    DoExecute;
end;

procedure TSimpleThread.ExeProcInThread(AProc: TGeneralProc);
begin
  FGeneralProc := AProc;
  FProcKind := pkGeneral;
  SelfStart;
end;

procedure TSimpleThread.ExeProcInThread(AProc: TObjectProc);
begin
  FObjProc := AProc;
  FProcKind := pkObject;
  SelfStart;
end;

procedure TSimpleThread.ExeProcInThread(AProc: TAnonymousProc);
begin
  FAnoProc := AProc;
  FProcKind := pkAnonymous;
  SelfStart;
end;

procedure TSimpleThread.OnThreadProcErr(e: exception);
begin;
end;

procedure TSimpleThread.SelfStart;
begin
  //经常多次尝试，最终写成这样，运行没有问题
  if FEvent.WaitFor(0) <> wrSignaled then
    FEvent.SetEvent; // 让waitfor 不再等
end;

procedure TSimpleThread.StopThread;
begin
  //继承类的代码中，需要检查 FWaitStop ，来控制线程结束
  FWaitStop := true;
end;

procedure TSimpleThread.SetOnDebugMsg(const Value: TOnDebugMsg);
begin
  FOnDebugMsg := Value;
end;

procedure TSimpleThread.SetOnStatusMsg(const Value: TOnStatusMsg);
begin
  FOnStatusMsg := Value;
end;

procedure TSimpleThread.SetParam(const Value: integer);
begin
  FParam := Value;
end;

procedure TSimpleThread.SetTagID(const Value: integer);
begin
  FTagID := Value;
end;

procedure TSimpleThread.SleepExceptStopped(ATimeOut: Cardinal);
var
  BOldTime: Cardinal;
begin
  // sleep 时检测退出指令,以确保线程顺序退出
  // 多个线程同时工作，要保证正确退出，确实不容易
  BOldTime := GetTickCount;
  while not WaitStop do
  begin
    sleep(50);
    if (GetTickCount - BOldTime) > ATimeOut then
      break;
  end;
end;

procedure TSimpleThread.StartThread;
begin
  FWaitStop := false;
end;

procedure TSimpleThread.WaitThreadStop;
begin
  //等待线程结束
  StopThread;
  Terminate;
  SelfStart;
  WaitFor;
end;

end.
