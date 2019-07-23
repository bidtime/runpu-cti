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
// 参数是传递的流和压缩方式
var
    SourceStream: TCompressionStream;
    DestStream: TMemoryStream;
    Count: int64; //注意，此处修改了,原来是int
begin
    //获得流的原始尺寸
    Count := CompressedStream.Size;
    DestStream := TMemoryStream.Create;
    SourceStream := TCompressionStream.Create(CompressionLevel, DestStream);
    try
        //SourceStream中保存着原始的流
        CompressedStream.SaveToStream(SourceStream);
        //将原始流进行压缩， DestStream中保存着压缩后的流
        SourceStream.Free;
        CompressedStream.Clear;
        //写入原始流的尺寸
        CompressedStream.WriteBuffer(Count, SizeOf(Count));
        //写入经过压缩的流
        CompressedStream.CopyFrom(DestStream, 0);
    finally
        DestStream.Free;
    end;
end;

procedure UnCompressIt(const CompressedStream: TMemoryStream; var UnCompressedStream: TMemoryStream);
//参数 压缩过的流，解压后的流
var
    SourceStream: TDecompressionStream;
    DestStream: TMemoryStream;
    Buffer: PChar;
    Count: int64;
begin
    //从被压缩的流中读出原始的尺寸
    CompressedStream.ReadBuffer(Count, SizeOf(Count));
    //根据尺寸大小为将要读入的原始流分配内存块
    GetMem(Buffer, Count);
    DestStream := TMemoryStream.Create;
    SourceStream := TDecompressionStream.Create(CompressedStream);
    try
        //将被压缩的流解压缩，然后存入 Buffer内存块中
        SourceStream.ReadBuffer(Buffer^, Count);
        //将原始流保存至 DestStream流中
        DestStream.WriteBuffer(Buffer^, Count);
        DestStream.Position := 0; //复位流指针
        //从DestStream流中载入数据流
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

//对文件进行压缩

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

 //对文件进行解压

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
