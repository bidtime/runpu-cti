unit uZipUtils;

interface

uses Windows, SysUtils, Classes;//, ZLib;

{procedure CompressIt(var CompressedStream: TMemoryStream; const CompressionLevel: TCompressionLevel);
procedure UnCompressIt(const CompressedStream: TMemoryStream; var UnCompressedStream: TMemoryStream);
procedure unzip(const inFile: string; const outFile: string);}
procedure unzipDir(const zipFile: string; const path: string);

implementation

uses zip;

{procedure CompressIt(var CompressedStream: TMemoryStream; const CompressionLevel: TCompressionLevel);
// �����Ǵ��ݵ�����ѹ����ʽ
var
    SourceStream: TCompressionStream;
    DestStream: TMemoryStream;
    Count: int64; //ע�⣬�˴��޸���,ԭ����int
begin
    //�������ԭʼ�ߴ�
    Count := CompressedStream.Size;
    DestStream := TMemoryStream.Create;
    SourceStream := TCompressionStream.Create(CompressionLevel, DestStream);
    try
        //SourceStream�б�����ԭʼ����
        CompressedStream.SaveToStream(SourceStream);
        //��ԭʼ������ѹ���� DestStream�б�����ѹ�������
        SourceStream.Free;
        CompressedStream.Clear;
        //д��ԭʼ���ĳߴ�
        CompressedStream.WriteBuffer(Count, SizeOf(Count));
        //д�뾭��ѹ������
        CompressedStream.CopyFrom(DestStream, 0);
    finally
        DestStream.Free;
    end;
end;

procedure UnCompressIt(const CompressedStream: TMemoryStream; var UnCompressedStream: TMemoryStream);
//���� ѹ������������ѹ�����
var
    SourceStream: TDecompressionStream;
    DestStream: TMemoryStream;
    Buffer: PChar;
    Count: int64;
begin
    //�ӱ�ѹ�������ж���ԭʼ�ĳߴ�
    CompressedStream.ReadBuffer(Count, SizeOf(Count));
    //���ݳߴ��СΪ��Ҫ�����ԭʼ�������ڴ��
    GetMem(Buffer, Count);
    DestStream := TMemoryStream.Create;
    SourceStream := TDecompressionStream.Create(CompressedStream);
    try
        //����ѹ��������ѹ����Ȼ����� Buffer�ڴ����
        SourceStream.ReadBuffer(Buffer^, Count);
        //��ԭʼ�������� DestStream����
        DestStream.WriteBuffer(Buffer^, Count);
        DestStream.Position := 0; //��λ��ָ��
        //��DestStream��������������
        UnCompressedStream.LoadFromStream(DestStream);
    finally
        FreeMem(Buffer);
        DestStream.Free;
    end;
end;}

{procedure DecompressGzip(const src: string; const dst: string);
var
  LInput, LOutput: TFileStream;
  LUnZip: TZDecompressionStream;

begin
  LInput := TFileStream.Create(src, fmOpenRead);
  ForceDirectories(dst);
  LOutput := TFileStream.Create(dst, fmCreate);
  LUnZip := TZDecompressionStream.Create(LInput, 15);
  try
    LOutput.CopyFrom(LUnZip, 0);
  finally
    LUnZip.Free;
    LInput.Free;
    LOutput.Free;
  end;
end;}

//���ļ�����ѹ��

{procedure TForm1.Button1Click(Sender: TObject);
var
    SM: TMemoryStream;
begin
    if OpenDialog1.Execute then
    begin
        if SaveDialog1.Execute then
        begin
            SM := TMemoryStream.Create;
            try
                Sm.LoadFromFile(OpenDialog1.FileName);
                SM.Position := 0;
                Compressit(sm, clDefault);
                SM.SaveToFile(SaveDialog1.FileName);
            finally
                SM.Free;
            end;
        end;
    end;
end;}

{procedure zip(const inFile: string; const outFile: string);
var
  SM: TMemoryStream;
begin
  SM := TMemoryStream.Create;
  try
    Sm.LoadFromFile(inFile);
    SM.Position := 0;
    Compressit(sm, clDefault);
    SM.SaveToFile(outFile);
  finally
    SM.Free;
  end;
end;}

 //���ļ����н�ѹ

{procedure unzip(const inFile: string; const outFile: string);
var
    SM, DM: TMemoryStream;
begin
  SM := TMemoryStream.Create;
  DM := TMemoryStream.Create;
  try
    Sm.LoadFromFile(inFile);
    SM.Position := 0;
    UnCompressit(sm, dm);
    dm.Position := 0;
    dm.SaveToFile(outFile);
  finally
    SM.Free;
    DM.Free;
  end;
end;}

procedure unzipDir(const zipFile: string; const path: string);
var
  zip: TZipFile;
begin
  zip := TZipFile.Create;
  try
    zip.ExtractAll(path);
    zip.Close;
  finally
    zip.Free;
  end;
end;

{procedure TForm1.Button2Click(Sender: TObject);
var
    SM, DM: TMemoryStream;
begin
    if OpenDialog1.Execute then
    begin
        if SaveDialog1.Execute then
        begin
            SM := TMemoryStream.Create;
            DM := TMemoryStream.Create;
            try
                Sm.LoadFromFile(OpenDialog1.FileName);
                SM.Position := 0;
                UnCompressit(sm, dm);
                dm.Position := 0;
                dm.SaveToFile(SaveDialog1.FileName);
            finally
                SM.Free;
                DM.Free;
            end;
        end;
    end;
end;}

end.
