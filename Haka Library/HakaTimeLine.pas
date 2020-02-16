unit HakaTimeLine;

interface

uses Sysutils,classes,activeX,DirectShow9,windows,Graphics, MMSystem,variants,HKGraphics;


type
 TTransition = class
 private
  TransObj : IAMTimeLineObj;
  Transable : IAMTimeLineTransable;
  Trans : IAMTimeLineTrans;
  PropSet:IPropertySetter;
  Param : DEXTER_PARAM;
  Value : PDexterValue;
  Procedure SetProp(Const Name : String; AVal : Variant);
  procedure SetSwapInputs(value : Boolean);
 public
  constructor Create(TL : IAMTimeLine; Track : IUnknown;
      TransName : TGUID; Start,Stop : Int64);
  Destructor Destroy; override;
  property SwapInputs : Boolean write SetSwapInputs;
  property prop[const Name : string]: Variant write SetProp;
 end;

 TCustomTimeLine = Class
 public
  TL : IAMTimeLine;
  RenderEngine : IRenderEngine;

  Width, Height : Integer; ///GClipInfo.
  FPS : Double;
  constructor Create;
  Destructor Destroy; override;
  Procedure AddGroup(MediaType : TGUID; out Group : IAMTimeLineGroup);
  procedure AddTrack(Comp: IAMTimelineComp; out Track: IAMTimeLineTrack);
  procedure AddSource(const Filename: String; Track: IAMTimeLineTrack;
      Start, Stop, MediaStart, MediaStop: Int64);
  procedure AddDIB(const Filename: String; Track: IAMTimeLineTrack;
      Start, Stop: Int64);
  procedure AddCustomSource(const Filename: String;
      Track: IAMTimeLineTrack; out Source: IAMTimeLineSrc; out SourceObj : IAMTimeLineObj);
  procedure AddSubObjectSource(SubObject: TGuid;
      Track: IAMTimeLineTrack; Start, Stop, MediaStart, MediaStop: Int64);
  procedure AddComp(Group : IAMTimeLineGroup; out Comp: IAMTimelineComp);
 end;


implementation

constructor TCustomTimeLine.Create;
begin
 CocreateInstance(CLSID_AMTIMELine,nil,CLSCTX_INPROC_SERVER,IID_IAMTimeline,TL);
end;

destructor TCustomTimeLine.Destroy;
begin
 TL:=nil;
 if assigned(RenderEngine) then
  RenderEngine.ScrapIt;
 RenderEngine:=nil;
end;

Procedure TCustomTimeLine.AddComp(Group : IAMTimeLineGroup; out Comp : IAMTimelineComp);
var
 CompObj: IAMTimelineObj;
 TempComp : IAMTimelineComp;
begin
 TL.CreateEmptyNode(CompObj, TIMELINE_MAJOR_TYPE_COMPOSITE);
 Group.QueryInterface(IID_IAMTimelineComp,TempComp);
 TempComp.VTrackInsBefore(CompObj,0);
 CompObj.QueryInterface(IID_IAMTimelineComp,Comp);
 CompObj:=nil;
 TempComp:=nil;
end;

Procedure TCustomTimeLine.AddCustomSource(Const Filename : String;
    Track : IAMTimeLineTrack; out Source : IAMTimeLineSrc; out SourceObj : IAMTimeLineObj);
begin
 TL.CreateEmptyNode(SourceObj, TIMELINE_MAJOR_TYPE_SOURCE);
 SourceObj.QueryInterface(IID_IAMTimelineSrc, Source);
 Source.SetMediaName(WideString(Filename));
 Track.SrcAdd(SourceObj);
end;

Procedure TCustomTimeLine.AddSubObjectSource(SubObject : TGUID; Track : IAMTimeLineTrack;
    Start,Stop,MediaStart,MediaStop : Int64);
var
 Source : IAMTimeLineSrc;
 SourceObj : IAMTimeLineObj;
begin
 TL.CreateEmptyNode(SourceObj, TIMELINE_MAJOR_TYPE_SOURCE);
 sourceObj.SetSubObjectGUID(SubObject);
 SourceObj.SetStartStop(Start,Stop);
 Track.SrcAdd(SourceObj);
 Source:=nil;
 SourceObj:=nil;
end;

Procedure TCustomTimeLine.AddDIB(Const Filename : String; Track : IAMTimeLineTrack;
    Start,Stop : Int64);
var
 Source : IAMTimeLineSrc;
 SourceObj : IAMTimeLineObj;
begin
 AddCustomSource(filename,Track,Source,SourceObj);
 SourceObj.SetStartStop(Start,Stop);
 Source.SetDefaultFPS(FPS);
 Source:=nil;
 SourceObj:=nil;
end;

Procedure TCustomTimeLine.AddSource(Const Filename : String; Track : IAMTimeLineTrack;
    Start,Stop,MediaStart,MediaStop : Int64);
var
 Source : IAMTimeLineSrc;
 SourceObj : IAMTimeLineObj;
begin
 AddCustomSource(filename,Track,Source,SourceObj);
 if (MediaStart<>0) or (MediaStop<>0) then
  Source.SetMediaTimes(MediaStart, MediaStop);
 SourceObj.SetStartStop(Start,Stop);

 Source:=nil;
 SourceObj:=nil;
end;

Procedure TCustomTimeLine.AddTrack(Comp : IAMTimelineComp; out Track: IAMTimeLineTrack);
var
 TrackObj: IAMTimelineObj;
begin
 TL.CreateEmptyNode(TrackObj, TIMELINE_MAJOR_TYPE_TRACK);
 TrackObj.QueryInterface(IID_IAMTimelineTrack,Track);
 Comp.VTrackInsBefore(TrackObj, 0);
 TrackObj:=nil;
 Comp:=nil;
end;

Procedure TCustomTimeLine.AddGroup(MediaType : TGUID; out Group : IAMTimeLineGroup);
var
 mtGroup : _AMMediaType;
 GroupObj : IAMTimeLineObj;
 VH : VideoInfoHeader;
begin
 TL.CreateEmptyNode(GroupObj,TIMELINE_MAJOR_TYPE_GROUP);
 GroupOBJ.QueryInterface(IID_IAMTimeLineGroup,Group);
 ZeroMemory(@mtGroup,sizeof(AM_MEDIA_TYPE));
 mtGroup.majortype:=MediaType;
 if  GUIDToString(mtGroup.majortype)= GUIDToString(MEDIATYPE_VIDEO) then
 begin
  mtGroup.pbFormat:=@VH;
  mtGroup.subtype:=MEDIASUBTYPE_ARGB32;

  ZeroMemory(@VH, sizeof(VIDEOINFOHEADER));
  vh.bmiHeader.biBitCount := 32;
  vh.bmiHeader.biWidth := Width;
  vh.bmiHeader.biHeight := Height;
  vh.bmiHeader.biPlanes := 1;
  vh.bmiHeader.biSize := sizeof(BITMAPINFOHEADER);
  vh.bmiHeader.biSizeImage := GetDIBSizeFromInfoHeader(@VH.bmiHeader);

  // Set the format type and size.
  mtGroup.formattype := FORMAT_VideoInfo;
  mtGroup.cbFormat := sizeof(VIDEOINFOHEADER);

  // Set the sample size.
  mtGroup.bFixedSizeSamples := TRUE;
  mtGroup.lSampleSize := GetDIBSizeFromInfoHeader(@VH.bmiHeader);
 end;
 Group.SetMediaType(@mtGroup);
 Group.SetOutputFPS(FPS);
 TL.AddGroup(GroupObj);
 GroupObj:=nil;
end;



constructor TTransition.Create(TL : IAMTimeLine; Track: IUnknown;
    TransName : TGUID; Start, Stop: Int64);
begin
 TL.CreateEmptyNode(TransOBJ,TIMELINE_MAJOR_TYPE_TRANSITION);
 TransOBJ.SetSubObjectGUID(TransName);
 TransOBJ.SetStartStop(Start,Stop);
 Track.QueryInterface(IID_IAMTimeLineTransable,Transable);
 Transable.TransAdd(TransObj);
 TransObj.QueryInterface(IID_IAMTimeLineTrans,Trans);
 CoCreateInstance(CLSID_PropertySetter, nil, CLSCTX_INPROC_SERVER, IID_IPropertySetter, PropSet);
 Value:=CoTaskMemAlloc(sizeof(DEXTER_VALUE));
 TransObj.SetPropertySetter(PropSet);
end;

procedure TTransition.SetSwapInputs(value: Boolean);
begin
 Trans.SetSwapInputs(value);
end;

destructor TTransition.Destroy;
begin
 CoTaskMemFree(Value);
 PropSet:=nil;
 Trans:=nil;
 TransObj:=nil;
 Transable:=nil;
end;

procedure TTransition.SetProp(const Name: String; AVal: Variant);
var
 AStyle : WideString;
begin
 param.Name:=Name;
 param.dispID := 0;
 param.nValues := 1;
 TVarData(Value.v).VType:=VT_BSTR;
 AStyle:=VarToStr(Aval);
 TVarData(Value.v).VOleStr:=PWideChar(AStyle);
 Value.rt := 0;
 Value.dwInterp:=ord(DEXTERF_JUMP);
 PropSet.AddProp(param, Value^);
end;


end.
 