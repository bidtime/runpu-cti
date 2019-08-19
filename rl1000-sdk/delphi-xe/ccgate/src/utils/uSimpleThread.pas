unit uSimpleThread;
interface
uses
  System.Classes, System.SysUtils, System.SyncObjs;

type

  // ��ʾ��Ϣ,���÷��� DoOnStatusMsg(AMsg);
  TOnStatusMsg = procedure(AMsg: string) of object;

  // ��ʾ������Ϣ,һ��������ʾ������Ϣ,�÷� DoOnDebugMsg(AMsg);
  TOnDebugMsg = TOnStatusMsg;

  TSimpleThread = class(TThread)
  public type // "ִ�й���"�������

    TGeneralProc = procedure; // ��ͨ��,�� procedure DoSomeThing;
    TObjectProc = procedure of object; // ���,�� TXxxx.DoSomeThign; �õö�
    TAnonymousProc = reference to procedure; // ������
  private type
    TProcKind = (pkGeneral, pkObject, pkAnonymous); // "ִ�й���"�����
  private

    FGeneralProc: TGeneralProc;
    FObjProc: TObjectProc;
    FAnoProc: TAnonymousProc;

    FProcKind: TProcKind;

    FEvent: TEvent; // ��������������һ���ź���
    FActiveX: boolean; // �Ƿ����߳���֧�� Com ,�����Ҫ���߳��з��� IE �Ļ������趨Ϊ True

    FOnStatusMsg: TOnStatusMsg;
    FOnDebugMsg: TOnDebugMsg;

    FTagID: integer; // ���߳�һ������,���̳߳ص�ʱ������������
    FParam: integer; // ���߳�һ������������ʶ��

    procedure SelfStart; // �����߳�����

    procedure DoExecute; // ��������������еĴ����ǡ��߳̿ռ䡱
    procedure DoOnException(e: exception); // �쳣��Ϣ��ʾ ���� DoOnDebugMsg(AMsg);

    procedure SetTagID(const Value: integer);
    procedure SetParam(const Value: integer);

    procedure SetOnStatusMsg(const Value: TOnStatusMsg);
    procedure SetOnDebugMsg(const Value: TOnDebugMsg);

  protected

    FWaitStop: boolean; // ������־�������ڼ̳�����ʹ��������ȷ���߳��Ƿ�ֹͣ����

    procedure DoOnStatusMsg(AMsg: string); // ��ʾ��ͨ��Ϣ
    procedure DoOnDebugMsg(AMsg: string); // ��ʾ��ʽ��Ϣ

    procedure Execute; override; // ���� TThread.Execute

    procedure OnThreadProcErr(e: exception); virtual; // �쳣�����¼�

    procedure WaitThreadStop; // �ȴ��߳̽���

    procedure BeforeExecute; virtual; // ������,������
    Procedure AfterExecute; virtual; // ������,������

    procedure SleepExceptStopped(ATimeOut: Cardinal); // ����ߴ����ˣ�Ҫ����һ�¡�
    { ��ʱ�߳�û������ʱ���ͻ���Ϣһ��������ǣ���Ϣ��ʱ�򣬿��ܻ���յ��˳��̵߳�ָ��
      �˺�����������Ϣ��ʱ��Ҳ���һ��ָֹͣ��
    }

  public

    // �ı�һ�� Create �Ĳ���,AllowedActiveX���Ƿ������̴߳������ Com
    constructor Create(AllowedActiveX: boolean = false); reintroduce;

    destructor Destroy; override;

    procedure ExeProcInThread(AProc: TGeneralProc); overload; // ������,����Ľӿڡ�
    procedure ExeProcInThread(AProc: TObjectProc); overload;
    procedure ExeProcInThread(AProc: TAnonymousProc); overload;

    procedure StartThread; virtual;
    { �����̣߳�һ��ֻ����һ�Ρ�
      �Ժ�����̵߳���Ӧ�¼���ִ����
    }

    procedure StopThread; virtual; // ֹͣ�߳�

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
  FreeOnTerminate := false; // ����Ҫ�ֶ�Free�߳�
  CreateGUID(BGUID);
  FEvent := TEvent.Create(nil, true, false, GUIDToString(BGUID));
end;

destructor TSimpleThread.Destroy;
begin
  StopThread; // ��ֹͣ
  WaitThreadStop; // �ٵȴ��߳�ֹͣ
  {
    �ڼ̳���� Destroy �У�ҲҪд��������. ��:
    ��ʱδ�ҵ����õİ취��������ʡ����
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

procedure TSimpleThread.DoExecute; // �˺�����ִ�еĴ���,�����ڶ��߳̿ռ�������
begin
  BeforeExecute;
  repeat

    FEvent.WaitFor;
    FEvent.ResetEvent; // �´�waitfor һֱ��
    { ���ﳢ���˺ܶ�Щ���� SelfStart �����г�ͻ����������޸Ĳ�ʹ��֤����
      û�б�Ҫ���������,��Ϊֻ���� startThread һ�Σ�ʣ�µĽ����߳�ӰӦ�¼�
    }

    if not Terminated then // ����߳���Ҫ�˳�
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
  //�������е�����ͱ�ʾ����̲߳������ˡ���Ҳ�ز�ȥ�ˣ������ͷ���Դ�ˡ�
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
  //�Ƿ�֧�� Com
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
  //������γ��ԣ�����д������������û������
  if FEvent.WaitFor(0) <> wrSignaled then
    FEvent.SetEvent; // ��waitfor ���ٵ�
end;

procedure TSimpleThread.StopThread;
begin
  //�̳���Ĵ����У���Ҫ��� FWaitStop ���������߳̽���
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
  // sleep ʱ����˳�ָ��,��ȷ���߳�˳���˳�
  // ����߳�ͬʱ������Ҫ��֤��ȷ�˳���ȷʵ������
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
  //�ȴ��߳̽���
  StopThread;
  Terminate;
  SelfStart;
  WaitFor;
end;

end.
