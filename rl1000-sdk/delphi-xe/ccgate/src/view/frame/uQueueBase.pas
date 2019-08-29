unit uQueueBase;

interface

uses
  Generics.Collections;

type
  TQueueBase<T> = class(TQueue<T>)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create; overload;
    destructor Destroy; override;
    //
    procedure put(const v: T);
    function get(): T;
    function peek: T;
    function Extract: T;
  end;

  TStackBase<T> = class(TStack<T>)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create; overload;
    destructor Destroy; override;
    //
    procedure put(const v: T);
    function get(): T;
    function peek: T;
    function Extract: T;
  end;

implementation

uses Classes;
//uses System.Threading;

{ TQueueBase<T> }

constructor TQueueBase<T>.Create;
begin
  inherited;
end;

destructor TQueueBase<T>.Destroy;
begin
  inherited;
end;

function TQueueBase<T>.Extract: T;
var a: T;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if self.Count > 0 then begin
      a := inherited Extract;
    end;
  end);
  Result := a;
end;

function TQueueBase<T>.get: T;
var a: T;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if self.Count > 0 then begin
      a := inherited Dequeue;
    end;
  end);
  Result := a;
end;

function TQueueBase<T>.peek: T;
var a: T;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if self.Count > 0 then begin
      a := inherited peek;
    end;
  end);
  Result := a;
end;

procedure TQueueBase<T>.put(const v: T);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    inherited Enqueue(v);
  end);
end;

{ TStackBase<T> }

constructor TStackBase<T>.Create;
begin
  inherited;
end;

destructor TStackBase<T>.Destroy;
begin
  inherited;
end;

function TStackBase<T>.get: T;
var a: T;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if self.Count > 0 then begin
      a := inherited pop;
    end;
  end);
  Result := a;
end;

function TStackBase<T>.peek: T;
var a: T;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if self.Count > 0 then begin
      a := inherited peek;
    end;
  end);
  Result := a;
end;

function TStackBase<T>.Extract: T;
var a: T;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    if self.Count > 0 then begin
      a := inherited Extract;
    end;
  end);
  Result := a;
end;

procedure TStackBase<T>.put(const v: T);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    inherited push(v);
  end);
end;


end.

