unit uThreadTimer;

interface

uses
  uSimpleThread;

type

  TThreadTimer = class; // 提前申明 TThreadTimer 是一个类

  TOnThreadTimer = procedure(Sender: TThreadTimer) of object;
  // 此处就可以引用 TThreadTimer,这种写法避免将 Sender 写为 TObject;
  // 为什么要写这个 sender ，主要是为了区别是谁引发了事件，并且 sender 上可以带参数
  // 方便进一步使用

  TThreadTimer = Class(TSimpleThread)
  private
    FInterval: Cardinal;
    FOnThreadTimer: TOnThreadTimer;

    procedure CountTimer;
    procedure DoCountTimer;
    procedure SetInterval(val: Cardinal);
    procedure SetOnThreadTimer(val: TOnThreadTimer);

    procedure DoOnThreadTimer; // 请学习此写法

  public
    constructor Create(AAllowActiveX: Boolean = false); // AAlowActiveX 在父类中有说明
    procedure StartThread; override; // 重载父类的 StartThread
    property Interval: Cardinal read FInterval write SetInterval default 1000;

    // 这个 default 1000 是给人看的，不会产生实际作用。
    // 故还需要在 Create 事件中指定 FInterval:=1000;
    // 如果可视化控件的 published 块中，此值会显示在属性编辑框中

    property OnThreadTimer: TOnThreadTimer read FOnThreadTimer write SetOnThreadTimer;

  End;

implementation

{ TThreadTimer }

procedure TThreadTimer.CountTimer;
begin
  ExeProcInThread(DoCountTimer);
  // 将 DoCountTimer 置入线程中去执行
  // 这是 TSimpleThread 的用法
end;

constructor TThreadTimer.Create(AAllowActiveX: Boolean);
begin
  inherited Create(AAllowActiveX);
  FInterval := 1000; // 默认间隔时间为 1 秒
end;

procedure TThreadTimer.DoCountTimer;
begin

  if WaitStop then // 这是父类的一个属性,表示线程现在需要停止了。
    exit;

  SleepExceptStopped(FInterval); // sleep 指定的时间,如果中途接到退出指令，则马上响应。
  // 父类中有源码，可看一看

  if not WaitStop then
  begin
    DoOnThreadTimer; // 引发时间到事件
  end;

  CountTimer; // 再次在线程中执行 DoCountTimer;
  // 父类已经设计好了，就这样简单地调用，即可实现在线程中执行本过程，但又不会引起“递归”

end;

procedure TThreadTimer.DoOnThreadTimer;
begin
  if Assigned(FOnThreadTimer) then
    FOnThreadTimer(Self);
  // 把这句写为一个过程，看似啰嗦，但为了程序可读性，是值得的。
end;

procedure TThreadTimer.StartThread;
begin
  inherited;
  CountTimer; // 启动计时
end;

procedure TThreadTimer.SetInterval(val: Cardinal);
begin
  FInterval := val;
end;

procedure TThreadTimer.SetOnThreadTimer(val: TOnThreadTimer);
begin
  FOnThreadTimer := val;
end;

end.
