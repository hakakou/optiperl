unit HKDirectShow;

interface
uses Classes, SysUtils,Windows,Graphics, ActiveX, DirectShow9,Variants,
     DSUtil,MMSystem,WMF9,msACM;

Procedure GetFirstInDeviceCategoryInputFilters(Cat : TGUID; out gottaFilter : IBaseFilter);
Function GetUnconnectedPin(Filter : IBaseFilter; PinDir: PIN_DIRECTION; out Pin : IPin) : Integer;
Function ConnectFilter(Graph: IGraphBuilder; Src,Dest: IBaseFilter) : Integer;
Function AddFilterByCLSID(Graph : IGraphBuilder; CLSID : TGUID; Const Name : string; out Filter : IBaseFilter) : Integer;
Function SmartGetGUIDString(GUID: TGUID): String;

Procedure WMProfileGetString(Profile : IWMProfile; out Name,Desc : WideString);
Procedure WMProfileGetVideoInfo(Profile : IWMProfile; out VideoInfo : WMVideoInfoHeader);

Function GetMediaStreamLength(Const Filename : String) : int64;

procedure GetVideoInfoParameters(pvih : PVIDEOINFOHEADER; pbData : PByte;
    bYuv : boolean; out pdwWidth,pdwHeight : Integer;  out plStrideInBytes : Integer;
    out ppbTop : PBYTE);

ResourceString
 sUncompressedAVI = '(No Compression)';
 sUncompressedPCM = '(No Compression)';

type
 PCodecInfo = ^TCodecInfo;
 TCodecInfo = record
  //FriendlyName : String;
  FccHandler : String;
  Detais : String;
  CodecID : Cardinal;
  CLSID : TGUID;
 end;

 TCodecList = Class(TStringList)
 private
  FTemp : String;
  procedure GetCat(CatGUID: TGUID);
  procedure GetACM;
 public
  Constructor Create(Video : Boolean);
  Destructor Destroy;
  Function IndexOfCodec(CodecID : Cardinal) : Integer;
 end;

implementation

var
 FMediaDet : IMediaDet = nil;

Function SmartGetGUIDString(GUID: TGUID): String;
begin
 result:=GetGUIDString(GUID);
 if result='' then
  result:=GuidToString(Guid);
end;

Procedure WMProfileGetVideoInfo(Profile : IWMProfile; out VideoInfo : WMVideoInfoHeader);
var
 i:integer;
 c:Cardinal;
 MT : PWMMEDIATYPE;
 PMT : Pointer;
 MV : PWMVideoInfoHeader;
 Size : Cardinal;
 Stream : IWMStreamConfig;
 Props : IWMMediaProps;
begin
 Fillchar(VideoInfo,sizeof(VideoInfo),0);
 profile.GetStreamCount(c);
 for i:=1 to c do
 begin
  Profile.GetStreamByNumber(I,Stream);
  if not assigned(stream) then continue;

  stream.QueryInterface(IID_IWMMediaProps,Props);
  Props.GetMediaType(nil,Size);
  GetMem(PMT,size);
  Props.GetMediaType(PMT,size);
  Props:=nil;
  Stream:=nil;
  MT:=PMT;

  if isEqualGuid(mt.formattype,WMFORMAT_VideoInfo) then
  begin
   mv:=pointer(mt.pbFormat);
   VideoInfo:=mv^;
   freemem(PMT);
   break;
  end;
  freemem(PMT);
 end;
end;

Procedure WMProfileGetString(Profile : IWMProfile; out Name,Desc : WideString);
var
 PName : PWideChar;
 ch : Cardinal;
begin
 Profile.GetName(nil,ch);
 PName:=AllocMem(ch*2+2);
 Profile.GetName(PName,ch);
 Name:=PName;
 FreeMem(PName);

 Profile.GetDescription(nil,ch);
 PName:=AllocMem(ch*2+2);
 Profile.GetDescription(Pname,ch);
 Desc:=PName;
 FreeMem(PName);
end;

Function AddFilterByCLSID(Graph : IGraphBuilder; CLSID : TGUID; Const Name : string; out Filter : IBaseFilter) : Integer;
var
 wc : WideString;
begin
 filter:=nil;
 wc:=Name;
 result:=CoCreateInstance(CLSID,nil,CLSCTX_INPROC_SERVER,IID_IBaseFilter,filter);
 if succeeded(result) then
  result:=Graph.AddFilter(filter,PWideChar(Wc));
end;


Procedure GetFirstInDeviceCategoryInputFilters(Cat : TGUID; out gottaFilter : IBaseFilter);
var
 Moniker : IMoniker;
 SysDevEnum : TSysDevEnum;
begin
 SysDevEnum:=TSysDevEnum.Create(Cat);
 Moniker:=SysDevEnum.GetMoniker(0);
 Moniker.BindToObject(nil,nil,IID_IBaseFilter,gottaFilter);
 SysDevEnum.Free;
end;

Function GetUnconnectedPin(Filter : IBaseFilter; PinDir: PIN_DIRECTION; out Pin : IPin) : Integer;
var
 Enum : IenumPins;
 ppin,pTmp : IPin;
 ThisPinDir : PIN_DIRECTION;
begin
 result:=S_FALSE;
 Filter.EnumPins(Enum);
 while (Enum.Next(1, pPin, nil) = S_OK) do
 begin
   pPin.QueryDirection(ThisPinDir);
   if (ThisPinDir = PinDir) then
   begin
     result:=pPin.ConnectedTo(pTmp);
     if (SUCCEEDED(result)) then
      ptmp:=nil
     else  // Unconnected--this is the pin we want
      begin
       Enum:=nil;
       Pin := pPin;
       result:=S_OK;
       exit;
      end;
      pPin:=nil;
   end;
 end;
 enum:=nil;
end;

Function ConnectFilter(Graph: IGraphBuilder; Src,Dest: IBaseFilter) : Integer;
var
 pout : IPin;
 pin : IPin;
begin
 GetUnconnectedPin(Src, PINDIR_OUTPUT, pOut);
 GetUnconnectedPin(Dest, PINDIR_INPUT, pIn);
 result:= Graph.Connect(pOut, pIn);
 pOut:=nil;
 pIn:=nil;
end;

Function GetMediaStreamLength(Const Filename : String) : int64;
var
 sl : Double;
begin
 try
  if not assigned(FMediaDet) then
   CocreateInstance(CLSID_MediaDet,nil,CLSCTX_INPROC_SERVER,IID_IMediaDet,FMediaDet);
  FMediaDet.put_Filename(Filename);
  FMediaDet.get_StreamLength(sl);
  result:=round(sl*10000000);
 except
  result:=0;
 end;
end;

procedure GetVideoInfoParameters(pvih : PVIDEOINFOHEADER;
    pbData : PByte;
    bYuv : boolean; // Is this a YUV format? (true = YUV, false = RGB)
    out pdwWidth,pdwHeight : Integer;      // Returns the height in pixels.
    out plStrideInBytes : Integer; // Add this to a row to get the new row down.
    out ppbTop : PBYTE);           // Returns a pointer to the first byte in the
                                 // top row of pixels.
var
 lStride : Integer;
begin
 //  For 'normal' formats, biWidth is in pixels.
 //  Expand to bytes and round up to a multiple of 4.
 if ((pvih.bmiHeader.biBitCount <> 0) and
        (0 = (7 and pvih.bmiHeader.biBitCount)))
    then
      lStride := (pvih.bmiHeader.biWidth * (pvih.bmiHeader.biBitCount div 8) + 3) and not 3
    else   // Otherwise, biWidth is in bytes.
      lStride := pvih.bmiHeader.biWidth;

    //  If rcTarget is empty, use the whole image.
 if (IsRectEmpty(pvih.rcTarget)) then
  begin
   pdwWidth := pvih.bmiHeader.biWidth;
   pdwHeight := (abs(pvih.bmiHeader.biHeight));

   if (pvih.bmiHeader.biHeight < 0) or (bYuv) then
     //check  if (pvih->bmiHeader.biHeight < 0 || bYuv)
    begin
     plStrideInBytes := lStride; // Stride goes "down".
     ppbTop := pbData; // Top row is first.
    end
   else        // Bottom-up bitmap.
    begin
     plStrideInBytes := -lStride;    // Stride goes "up".
     // Bottom row is first.
     ppbTop := ptr( integer(pbData) + lStride * (pdwHeight - 1));
    end
  end

 else   // rcTarget is NOT empty. Use a sub-rectangle in the image.
   begin
     pdwWidth := pvih.rcTarget.right - pvih.rcTarget.left;
     pdwHeight := pvih.rcTarget.bottom - pvih.rcTarget.top;

     if (pvih.bmiHeader.biHeight < 0) or bYuv then
     //check
      begin
       // Same stride as above, but first pixel is modified down
       // and over by the target rectangle.
       plStrideInBytes := lStride;
       ppbTop := ptr (integer(pbData) + lStride * pvih.rcTarget.top +
                    (pvih.bmiHeader.biBitCount * pvih.rcTarget.left) div 8);
      end
     else  // Bottom-up bitmap.
      begin
       plStrideInBytes := -lStride;
       ppbTop := Ptr( integer(pbData) +  lStride * (pvih.bmiHeader.biHeight - pvih.rcTarget.top - 1) +
                     (pvih.bmiHeader.biBitCount * pvih.rcTarget.left) div 8);
      end;
    end;
end;

{ TCodecList }

constructor TCodecList.Create(Video : Boolean);
var
 info : ^TCodecInfo;
begin
 inherited Create;
 new(info);
 fillchar(info^,sizeof(info^),0);

 if Video then
  begin
   GetCat(CLSID_VideoCompressorCategory);
   info^.CodecID:=$20424944; //AVI_DIB;
   info^.Detais:='No compression.';
   InsertObject(0,sUncompressedAVI,TObject(info));
  end
 else
  begin
   GetACM;
   info^.CodecID:=1;
   info^.Detais:='No compression.';
   InsertObject(0,sUncompressedPCM,TObject(info));
  end;

end;

destructor TCodecList.Destroy;
var
 i:integer;
begin
 for i:=0 to count-1 do
  Dispose(pointer(self.GetObject(i)));
end;

function acmFormatTagEnumCallback(hadid : HACMDRIVERID;
  paftd : PACMFORMATTAGDETAILS; dwInstance: cardinal; fdwSupport : DWORD) : Boolean; stdcall;
var
 info : ^TCodecInfo;
 List : ^TCodecList;
begin
 List:=ptr(dwInstance);
 result:=true;
 if paftd.dwFormatTag=1 then exit;

 new(info);
 fillchar(info^,sizeof(info^),0);
 info.CodecID:=paftd.dwFormatTag;
 info.Detais:=list.FTemp;

 list.AddObject(paftd.szFormatTag,TObject(info));
end;

function acmDriverEnumCallback (hadid : HACMDRIVERID;
  dwInstance: cardinal; fdwSupport : DWORD) : boolean; stdcall;
var
 dt : TACMDRIVERDETAILS ;
 handle: HACMDRIVER;
 td : TACMFORMATTAGDETAILS;
 List : ^TCodecList;
begin
 List:=ptr(dwInstance);

 Fillchar(dt,sizeof(dt),0);
 dt.cbStruct:=sizeof(dt);
 acmDriverDetails(hadid,dt,0);

 List.FTemp:=dt.szFeatures;

 acmDriverOpen(handle,hadid,0);
 Fillchar(td,sizeof(td),0);
 td.cbStruct:=sizeof(dt);
 acmFormatTagEnum(handle,td,@acmFormatTagEnumCallback,dwInstance,0);

 acmDriverClose(handle,0);
 result:=true;
end;

procedure TCodecList.GetACM;
begin
 acmDriverEnum(@acmDriverEnumCallback,cardinal(@self),0);
end;

procedure TCodecList.GetCat(CatGUID: TGUID);
var
 CodecInfo : ^TCodecInfo;
 SysDevEnum : ICreateDevEnum;
 EnumCat    : IEnumMoniker;
 Moniker    : IMoniker;
 Fetched    : ULONG;
 PropBag    : IPropertyBag;
 FriendlyName,FccHandler : String;
 AcmID : Cardinal;
 v : olevariant;
 hr         : HRESULT;
 i          : integer;
begin
 CocreateInstance(CLSID_SystemDeviceEnum, nil, CLSCTX_INPROC, IID_ICreateDevEnum, SysDevEnum);
 hr := SysDevEnum.CreateClassEnumerator(CatGUID, EnumCat, 0);
    if (hr = S_OK) then
    begin
      while(EnumCat.Next(1, Moniker, @Fetched) = S_OK) do
        begin
          Moniker.BindToStorage(nil, nil, IID_IPropertyBag, PropBag);

          PropBag.Read('FriendlyName', v, nil);
          FriendlyName:=v;

          if PropBag.Read('FccHandler', v, nil) = S_OK
           then FccHandler:=v
           else FccHandler:='';

          if (FccHandler<>'') then
          begin
           new(CodecInfo);
           fillchar(CodecInfo^,sizeof(CodecInfo^),0);
           CodecInfo^.FccHandler:=FccHandler;

           if FccHandler<>'' then
            CodecInfo^.CodecID:=dsutil.FCC(CodecInfo^.FccHandler);

           if (PropBag.Read('CLSID',V,nil) = S_OK) then
            CodecInfo^.CLSID := StringToGUID(V);

           self.AddObject(FriendlyName,TObject(CodecInfo));
          end;

          PropBag := nil;
          Moniker := nil;
        end;
    end;
    EnumCat :=nil;
    SysDevEnum :=nil;
end;

function TCodecList.IndexOfCodec(CodecID : Cardinal) : Integer;
var i:integer;
begin
 result:=-1;
 for i:=0 to count-1 do
  if PCodecInfo(GetObject(i)).CodecID=CodecID then
  begin
   result:=i;
   break;
  end;
end;

initialization
finalization
 if assigned(FMediaDet) then FMediaDet:=nil;
end.

(*

/////////////////////////////////////////////////////////////
//Source Examples


Procedure WMProfileTest(Profile : IWMProfile);
var
 MT : PWMMEDIATYPE;
 PMT : Pointer;
 MV : PWMVideoInfoHeader;
 Size : Cardinal;
 Stream : IWMStreamConfig;
 Props : IWMMediaProps;
 hr:integer;
begin
  Profile.GetStreamByNumber(2,Stream);
  stream.QueryInterface(IID_IWMMediaProps,Props);
  Props.GetMediaType(nil,Size);
  GetMem(PMT,size);
  Props.GetMediaType(PMT,size);
  MT:=PMT;
  if isEqualGuid(mt.formattype,WMFORMAT_VideoInfo) then
  begin
   mv:=pointer(mt.pbFormat);
   mv.AvgTimePerFrame:=1000000;
   hr:=props.SetMediaType(PMT);
   inttostr(hr);
  end;
  Props:=nil;
  Stream:=nil;
end;


Function EnumerateAudioCompressorFilters(out Compt : IBaseFilter; matchName:string ) : Integer;
var
 i:integer;
 sysdevenum : TSysDevEnum;
begin
 sysdevenum:=Tsysdevenum.Create(CLSID_AudioCompressorCategory);
 for i:=0 to sysDevEnum.CountFilters-1 do
 begin
  if sysDevEnum.Filters[i].FriendlyName =  matchName then
   Compt:=sysDevEnum.GetBaseFilter(i);
   // Do Something
 end;
end;

Function EnumerateAudioInputPins(p : IBaseFilter) : Integer;
var
 PinList : TPinList;
 i,hr:integer;
 aMain : IAMAudioInputMixer;
 enable : longbool;
begin
 PinList:=TPinList.Create(p);
 for i:=0 to PinList.Count-1 do
 begin
//  Form1.ListBox1.Items.add(PinList.PinInfo[i].achName);
  hr:=PinList[i].QueryInterface(IID_IAMAudioInputMixer,amain);
  if succeeded(hr) then
  begin
   hr:=amain.get_Enable(enable);
   if succeeded(hr) and enable then
   begin
//    Form1.ListBox1.Items.add(PinList.PinInfo[i].achName+' enabed');
   end;
  end;

 end;
end;

Function EnumerateEffects(SearchType : TGUID) : INteger;
var
 i : Integer;
 Moniker : IMoniker;
 SysDevEnum : TSysDevEnum;
 propBag : IPropertyBag;
 v : olevariant;
begin
 SysDevEnum:=TSysDevEnum.Create(SearchType);
 for i:=0 to SysDevEnum.CountFilters-1 do
 begin
  Moniker:=SysDevEnum.GetMoniker(i);
  Moniker.BindToStorage(nil,nil,IID_IPropertyBag,propbag);
  PropBag.Read('FriendlyName',v,nil);
//  Form1.ListBox1.Items.add(v);
 end;
 SysDevEnum.Free;
end;


Function GetMediaFrame(Const Filename : String; Time : Int64) : TBitmap;
var
 FMD : IMediaDet;
 FMediaType : AM_MEDIA_TYPE;
 FVideoInfoHeader : PVideoInfoHeader;
 FFPS : Double;
 FBufferSize : LongInt;
 FBuffer : Pointer;
 FWidth,FHeight : Integer;
 d: double;
 n,i:integer;
 FData: Pointer;
 h : HDC;
 hbmp : HBitmap;
 InitInfo : BitmapInfo;
begin
 result:=nil;
 CocreateInstance(CLSID_MediaDet,nil,CLSCTX_INPROC_SERVER,IID_IMediaDet,FMD);
 try
  i:=FMD.put_Filename(Filename);
  if i=S_OK then
   i:=FMD.get_OutputStreams(n);
  if i<>S_OK then
   exit;

  i:=0;
  while (i<n) do
  begin
   FMD.put_CurrentStream(i);
   FMD.get_StreamMediaType(FMediaType);
   if IsEqualGuid(FMediaType.majortype,MEDIATYPE_Video) then
    break;
   inc(i);
  end;

  if not IsEqualGuid(FMediaType.majortype,MEDIATYPE_Video) then
   Exit;

  FMD.get_StreamLength(d);
  FMD.get_FrameRate(FFPS);
  FVideoInfoHeader:=FMediaType.pbFormat;
  FWidth:=FVideoInfoHeader.bmiHeader.biWidth;
  FHeight:=FVideoInfoHeader.bmiHeader.biHeight;

  i:=FMD.GetBitmapBits(0,@FbufferSize,nil,FWidth,FHeight);
  if i<>S_OK then
   Exit;

  GetMem(Fbuffer,FBufferSize);
  FMD.GetBitmapBits(time,nil,FBuffer,FWidth,FHeight);
  h:=GetDC(0);
  FData:=ptr(integer(FBuffer)+Sizeof(BitmapInfoHeader));
  Move(BitmapInfoHeader(FBuffer^),InitInfo,sizeof(BitmapInfo));
  hbmp:=CreateDIBitmap(h,BitmapInfoHeader(FBuffer^),CBM_INIT,FData,InitInfo,DIB_RGB_COLORS);
  result:=TBitmap.create;
  result.Handle:=hbmp;
  deleteObject(hbmp);
  deleteobject(h);

  FreeMem(FBuffer,FBufferSize);
 finally
  FMD:=nil;
 end;
end;


