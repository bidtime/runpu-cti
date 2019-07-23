unit Iocp.AtomQueue;

interface

Uses
  SysUtils,
  SyncObjs;

Type
  TAtomFIFO = Class
  Protected
    FWritePtr: Integer;
    FReadPtr: Integer;
    FCount:Integer;
    FHighBound:Integer;
    FisEmpty:Integer;
    FData: array of Pointer;
    function GetSize:Integer;
  Public
    procedure Push(Item: Pointer);
    function Pop: Pointer;
    Constructor Create(Size: Integer); Virtual;
    Destructor Destroy; Override;
    Procedure Empty;
    property Size: Integer read GetSize;
    property UsedCount:Integer read FCount;
  End;

Implementation

//�������У���С������2���ݣ���Ҫ�����㹻��Ķ��У���ֹ�������

Constructor TAtomFIFO.Create(Size: Integer);
var
  //i:NativeInt;
  OK:Boolean;
Begin
  Inherited Create;
  OK:=(Size and (Size-1)=0);

  if not OK then raise Exception.Create('FIFO���ȱ�����ڵ���256��Ϊ2����');

  try
    SetLength(FData, Size);
    FHighBound:=Size-1;
  except
    Raise Exception.Create('FIFO�����ڴ�ʧ��');
  end;
End;

Destructor TAtomFIFO.Destroy;
Begin
  SetLength(FData, 0);
  Inherited;
End;

procedure TAtomFIFO.Empty;
begin
  while (TInterlocked.Exchange(FReadPtr, 0)<>0) and
  (TInterlocked.Exchange(FWritePtr, 0)<>0) and
  (TInterlocked.Exchange(FCount, 0)<>0) do;
end;

function TAtomFIFO.GetSize: Integer;
begin
  Result:=FHighBound+1;
end;

procedure TAtomFIFO.Push(Item:Pointer);
var
  N:Integer;
begin
  if Item=nil then Exit;

  N:=TInterlocked.Increment(FWritePtr) and FHighBound;
  FData[N]:=Item;
  TInterlocked.Increment(FCount);
end;

Function TAtomFIFO.Pop:Pointer;
var
  N:Integer;
begin
  if TInterlocked.Decrement(FCount)<0 then
  begin
    TInterlocked.Increment(FCount);
    Result:=nil;
  end
  else
  begin
    N:=TInterlocked.Increment(FReadPtr) and FHighBound;
    //�����߳�A������Push,���������ǵ�1��push��
    //ִ����N:=TInterlocked.Increment(FWritePtr) and FHighBound,
    //��ûִ��FData[N]:=Item, ���л��������߳�
    //��ʱ�����߳�B������Push�����������ǵ�2��push,����ִ����ϣ���������FCount=1,��2��Item��Ϊ�գ�����һ��Item����nil���߳�A��ûִ�и�ֵ��
    //�����߳�Cִ��Pop������Count>0���߳�B�����ã����Կ���ִ�е��������ʱFData[N]=nil���߳�A��ûִ�и�ֵ����
    //����߳�CҪ�ȴ��߳�A���FData[N]:=Item�󣬲���ȡ��FData[N]
    //������������ĸ���Ӧ�ñȽ�С�������ϲ����˷�̫��CPU
    while FData[N]=nil do Sleep(1);
    Result:=FData[N];

    FData[N]:=nil;
  end;
end;

End.
