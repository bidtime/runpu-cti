unit uThreadTimer;

interface

uses
  uSimpleThread;

type

  TThreadTimer = class; // ��ǰ���� TThreadTimer ��һ����

  TOnThreadTimer = procedure(Sender: TThreadTimer) of object;
  // �˴��Ϳ������� TThreadTimer,����д�����⽫ Sender дΪ TObject;
  // ΪʲôҪд��� sender ����Ҫ��Ϊ��������˭�������¼������� sender �Ͽ��Դ�����
  // �����һ��ʹ��

  TThreadTimer = Class(TSimpleThread)
  private
    FInterval: Cardinal;
    FOnThreadTimer: TOnThreadTimer;

    procedure CountTimer;
    procedure DoCountTimer;
    procedure SetInterval(val: Cardinal);
    procedure SetOnThreadTimer(val: TOnThreadTimer);

    procedure DoOnThreadTimer; // ��ѧϰ��д��

  public
    constructor Create(AAllowActiveX: Boolean = false); // AAlowActiveX �ڸ�������˵��
    procedure StartThread; override; // ���ظ���� StartThread
    property Interval: Cardinal read FInterval write SetInterval default 1000;

    // ��� default 1000 �Ǹ��˿��ģ��������ʵ�����á�
    // �ʻ���Ҫ�� Create �¼���ָ�� FInterval:=1000;
    // ������ӻ��ؼ��� published ���У���ֵ����ʾ�����Ա༭����

    property OnThreadTimer: TOnThreadTimer read FOnThreadTimer write SetOnThreadTimer;

  End;

implementation

{ TThreadTimer }

procedure TThreadTimer.CountTimer;
begin
  ExeProcInThread(DoCountTimer);
  // �� DoCountTimer �����߳���ȥִ��
  // ���� TSimpleThread ���÷�
end;

constructor TThreadTimer.Create(AAllowActiveX: Boolean);
begin
  inherited Create(AAllowActiveX);
  FInterval := 1000; // Ĭ�ϼ��ʱ��Ϊ 1 ��
end;

procedure TThreadTimer.DoCountTimer;
begin

  if WaitStop then // ���Ǹ����һ������,��ʾ�߳�������Ҫֹͣ�ˡ�
    exit;

  SleepExceptStopped(FInterval); // sleep ָ����ʱ��,�����;�ӵ��˳�ָ���������Ӧ��
  // ��������Դ�룬�ɿ�һ��

  if not WaitStop then
  begin
    DoOnThreadTimer; // ����ʱ�䵽�¼�
  end;

  CountTimer; // �ٴ����߳���ִ�� DoCountTimer;
  // �����Ѿ���ƺ��ˣ��������򵥵ص��ã�����ʵ�����߳���ִ�б����̣����ֲ������𡰵ݹ顱

end;

procedure TThreadTimer.DoOnThreadTimer;
begin
  if Assigned(FOnThreadTimer) then
    FOnThreadTimer(Self);
  // �����дΪһ�����̣����Ɔ��£���Ϊ�˳���ɶ��ԣ���ֵ�õġ�
end;

procedure TThreadTimer.StartThread;
begin
  inherited;
  CountTimer; // ������ʱ
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
