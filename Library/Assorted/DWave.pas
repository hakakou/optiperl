{

        TWave by Daniel Backström 2002, release 3.1.2
        PSEUDO SOLUTIONS: http://home.bip.net/baxtrom
        Copyright (C) 2002  Daniel Backström

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

}

unit DWave;

interface

uses
  Windows, Messages, SysUtils, Classes, MMSystem;

const
        HeaderSize = 44;

var
        DynamicHeaderSize: Word;
        NewWaveLength: Double;

type TWaveHeader = record
        ChunkID: array[1..4] of char;
        ChunkSize: LongWord;
        Format: array[1..4] of char;

        Subchunk1ID: array[1..4] of char;
        Subchunk1Size: LongWord;
        AudioFormat: Word;
        NumChannels: Word;
        SampleRate: LongWord;
        ByteRate: LongWord;
        BlockAlign: Word;
        BitsPerSample: Word;

        Subchunk2ID: array[1..4] of char;
        Subchunk2Size: LongWord;
end;

type TSelectedChannel = (LeftChannel, RightChannel);
type TProgressEvent = procedure(Sender: TObject; Progress: Shortint) of object;

type
  TWave = class(TComponent)
  private
    { Private declarations }
    FFileName: TFileName;
    FWaveHeader: TWaveHeader;
    FWaveStream: TMemoryStream;
    FTempWaveHeader: TWaveHeader;
    FTempWaveStream: TMemoryStream;
    FProgress: TProgressEvent;
    procedure LoadHeader;
    procedure FSetFileName(FileName: TFileName);
    function FGetBitsPerSample: Word;
    function FGetNumChannels: Word;
    function FGetSampleRate: Longword;
    procedure FSetSampleRate(SampleRate: Longword);
    function FGetSize: Longword;
    function FGetLength: Double;
    procedure FSetLength( NewLength: Double );
  protected
    { Protected declarations }
  public
    function GetValueRAW(Position: Longword;    ///////Xarka
       SelectedChannel: TSelectedChannel): SmallInt;

    { Public declarations }
    property FileName: TFileName read FFileName write FSetFileName;
    function PlayWave: Boolean;
    function StopWave: Boolean;
    property BitsPerSample: Word read FGetBitsPerSample;
    property NumChannels: Word read FGetNumChannels;
    property SampleRate: Longword read FGetSampleRate write FSetSampleRate;
    property Size: Longword read FGetSize;
    property Length: Double read FGetLength write FSetLength;
    function GetValue(Position: Longword; SelectedChannel: TSelectedChannel):
    Double;
    procedure SetValue(Position: Longword; SelectedChannel: TSelectedChannel;
    Value: Double);
    procedure ConvertToMono;
    procedure ConvertToStereo;
    procedure ConvertTo8Bits;
    procedure ConvertTo16Bits;
    procedure DoubleSampleRate;
    procedure HalveSampleRate;
    procedure SaveWave(FileName: TFileName);
  published
    { Published declarations }
    property OnProgress: TProgressEvent read FProgress write FProgress;
  end;

procedure Register;

implementation


function TWave.GetValueRAW(Position: Longword; SelectedChannel: TSelectedChannel): SmallInt;
var
        b: Byte;
        w: Smallint;
begin

if Position + 1 > FGetSize then
begin
        GetValueRaw := 0;
        Exit;
end;

if FWaveHeader.NumChannels = 1 then
        if FWaveHeader.BitsPerSample  = 8 then
        begin
                FWaveStream.Seek(HeaderSize + Position, 0);
                FWaveStream.Read(b, 1);
                GetValueRaw := b;
        end
        else
        begin
                FWaveStream.Seek(HeaderSize + 2*Position, 0);
                FWaveStream.Read(w, 2);
                GetValueRaw := w;
        end
else
begin
        if FWaveHeader.BitsPerSample  = 8 then
        begin
                if SelectedChannel = LeftChannel then
                begin
                        FWaveStream.Seek(HeaderSize + 2*Position, 0);
                        FWaveStream.Read(b, 1);
                        GetValueRaw := b;
                end
                else
                begin
                        FWaveStream.Seek(HeaderSize + 2*Position + 1, 0);
                        FWaveStream.Read(b, 1);
                        GetValueRaw := b;
                end;
        end
        else
        begin
                if SelectedChannel = LeftChannel then
                begin
                        FWaveStream.Seek(HeaderSize + 4*Position, 0);
                        FWaveStream.Read(w, 2);
                        GetValueRaw := w;
                end
                else
                begin
                        FWaveStream.Seek(HeaderSize + 4*Position + 2, 0);
                        FWaveStream.Read(w, 2);
                        GetValueRaw := w;
                end;
        end;
end;

end;


//------------------------------------------------------------------------------

procedure TWave.LoadHeader;
// Reads the wave header into the FWaveHeader field
var
        F: file of TWaveHeader;
begin

AssignFile(F, FFileName);
Reset(F);
Read(F, FWaveHeader);
Close(F);

end;


procedure TWave.FSetFileName(FileName: TFileName);
{
        Sets the filename, updates the header information and creates a stream
        ( creates a new wave if file doesnt exist )
}
var
        found: boolean;
        b: byte;
        i: Word;
        q: LongWord;
        TempStream: TMemoryStream;
begin

FFileName := FileName;

if FileExists(FileName) then
begin
        LoadHeader;
        FWaveStream.Free;
        FWaveStream := TMemoryStream.Create;
        FWaveStream.LoadFromFile(FFileName);

        i := 0;
        found := false;
        while not found do
        begin
                FWaveStream.Seek(i, soFromBeginning);
                FWaveStream.Read(q, 4);
                i := i + 1;
                if q = 1635017060 then found := true; // if q = 'data'
        end;

        // Transforms to standard wave format
        DynamicHeaderSize := i + 7;
        if DynamicHeaderSize <> HeaderSize then
        begin
                FWaveStream.Seek(DynamicHeaderSize - 4, soFromBeginning);
                FWaveStream.Read(FWaveHeader.SubChunk2Size, 4);
                FWaveHeader.Subchunk2ID := 'data';
                TempStream := TMemoryStream.Create;
                TempStream.SetSize(HeaderSize + FWaveHeader.Subchunk2Size);
                TempStream.Seek(0, soFromBeginning);
                TempStream.Write(FWaveHeader, HeaderSize);
                for q := DynamicHeaderSize to DynamicHeaderSize +
                FWaveHeader.Subchunk2Size do
                begin
                        FWaveStream.Seek(q, soFromBeginning);
                        FWaveStream.Read(b, 1);
                        TempStream.Seek(q - DynamicHeaderSize + HeaderSize,
                        soFromBeginning);
                        TempStream.Write(b, 1);
                end;
                FWaveStream.LoadFromStream(TempStream);
                TempStream.Clear;
                DynamicHeaderSize := HeaderSize;

                FTempWaveHeader.AudioFormat := 1;
                FWaveStream.Seek(20, soFromBeginning);
                FWaveStream.Write(FTempWaveHeader.AudioFormat, 2);

                FWaveHeader.ChunkSize := FWaveStream.Size - 8;//36 + FWaveHeader.Subchunk2Size; //
                FWaveStream.Seek(4, soFromBeginning);
                FWaveStream.Write(FWaveHeader.ChunkSize, 4);

                FWaveHeader.Subchunk1Size := 16;
                FWaveStream.Seek(16, soFromBeginning);
                FWaveStream.Write(FWaveHeader.Subchunk1Size, 4);
        end;
end
else
begin
        // Creates a new wave
        
        // DataSize := NewWaveLength*FS*BytePerSample = NewWaveLength*11025*1
        FWaveHeader.ChunkID := 'RIFF';
        FWaveHeader.ChunkSize := Round( 36 + 11025*NewWaveLength );
        FWaveHeader.Format := 'WAVE';
        FWaveHeader.Subchunk1ID := 'fmt ';
        FWaveHeader.Subchunk1Size := 16;
        FWaveHeader.AudioFormat := 1;
        FWaveHeader.NumChannels := 1;
        FWaveHeader.SampleRate := 11025;
        FWaveHeader.ByteRate := 11025;
        FWaveHeader.BlockAlign := 1;
        FWaveHeader.BitsPerSample := 8;
        FWaveHeader.Subchunk2ID := 'data';
        FWaveHeader.Subchunk2Size := Round( 11025*NewWaveLength );

        FWaveStream.Free;
        FWaveStream := TMemoryStream.Create;
        FWaveStream.SetSize(FWaveHeader.ChunkSize + 8);

        FWaveStream.Seek(0, soFromBeginning);
        FWaveStream.Write(FWaveHeader, HeaderSize);

        // Sets wave to zero
        b := round( 255 / 2 );
        for q := HeaderSize to FWaveStream.Size do
        begin
                FWaveStream.Seek(q, soFromBeginning);
                FWaveStream.Write(b, 1);
        end;
end;

end;


function TWave.PlayWave: Boolean;
// Plays the wave stream
begin

PlayWave := PlaySound(FWaveStream.Memory, 0, SND_MEMORY + SND_ASYNC);

end;


function TWave.StopWave: Boolean;
// Stops playing the wave stream
begin

StopWave := PlaySound(nil, 0, SND_MEMORY);

end;


procedure TWave.SaveWave(FileName: TFileName);
// Saves the wave stream to file
begin

FWaveStream.SaveToFile(FileName);

end;


function TWave.FGetBitsPerSample: Word;
// Returns the bits per sample resolution (supported: 8 and 16)
begin

FGetBitsPerSample := FWaveHeader.BitsPerSample;

end;


function TWave.FGetNumChannels: Word;
// Returns the number of channels (supported: 1 and 2)
begin

FGetNumChannels := FWaveHeader.NumChannels;

end;


function TWave.FGetSampleRate: Longword;
// Returns the sample rate
begin

FGetSampleRate := FWaveHeader.SampleRate;

end;


procedure Twave.FSetSampleRate(SampleRate: Longword);
// Sets samplerate
begin

FwaveHeader.ByteRate := round( SampleRate/FWaveHeader.SampleRate*
FwaveHeader.ByteRate );

FWaveHeader.SampleRate := SampleRate;

FWaveStream.Seek(0, 0);
FWaveStream.Write(FWaveHeader, HeaderSize);

end;


function TWave.FGetSize: Longword;
// Returns the total number of samples in the channels
begin

FGetSize := FWaveHeader.Subchunk2Size * 8 div FWaveHeader.BitsPerSample div
FWaveHeader.NumChannels;

end;


function TWave.FGetLength: Double;
// Returns the total length in seconds of the wave
begin

FGetLength := FGetSize / FGetSampleRate;

end;

procedure TWave.FSetLength( NewLength: Double );
begin

NewWaveLength := NewLength;

end;


function TWave.GetValue(Position: Longword; SelectedChannel: TSelectedChannel):
Double;
{ Reads the wave at the given position and channel and returns a value between
 -1 and 1 }
var
        b: Byte;
        w: Smallint;
begin

if Position + 1 > FGetSize then
begin
        GetValue := 0;
        Exit;
end;

if FWaveHeader.NumChannels = 1 then
        if FWaveHeader.BitsPerSample  = 8 then
        begin
                FWaveStream.Seek(HeaderSize + Position, 0);
                FWaveStream.Read(b, 1);
                GetValue := 2/255*b - 1;
        end
        else
        begin
                FWaveStream.Seek(HeaderSize + 2*Position, 0);
                FWaveStream.Read(w, 2);
                GetValue := 2/65535*w + 1 - 65534/65535;
        end
else
begin
        if FWaveHeader.BitsPerSample  = 8 then
        begin
                if SelectedChannel = LeftChannel then
                begin
                        FWaveStream.Seek(HeaderSize + 2*Position, 0);
                        FWaveStream.Read(b, 1);
                        GetValue := 2/255*b - 1;
                end
                else
                begin
                        FWaveStream.Seek(HeaderSize + 2*Position + 1, 0);
                        FWaveStream.Read(b, 1);
                        GetValue := 2/255*b - 1;
                end;
        end
        else
        begin
                if SelectedChannel = LeftChannel then
                begin
                        FWaveStream.Seek(HeaderSize + 4*Position, 0);
                        FWaveStream.Read(w, 2);
                        GetValue := 2/65535*w + 1 - 65534/65535;
                end
                else
                begin
                        FWaveStream.Seek(HeaderSize + 4*Position + 2, 0);
                        FWaveStream.Read(w, 2);
                        GetValue := 2/65535*w + 1 - 65534/65535;
                end;
        end;
end;

end;


procedure TWave.SetValue(Position: Longword; SelectedChannel: TSelectedChannel;
Value: Double);
// Sets the value (-1..1) at the given sample position and channel
var
        b: Byte;
        w: Smallint;
begin

if Position + 1 > FGetSize then
        Exit;

if FWaveHeader.NumChannels = 1 then
        if FWaveHeader.BitsPerSample  = 8 then
        begin
                b := round( (Value + 1)*255/2 );
                FWaveStream.Seek(HeaderSize + Position, 0);
                FWaveStream.Write(b, 1);
        end
        else
        begin
                w := round( (Value - 1 + 65534/65535)*65535/2 );
                FWaveStream.Seek(HeaderSize + 2*Position, 0);
                FWaveStream.Write(w, 2);
        end
else
begin
        if FWaveHeader.BitsPerSample  = 8 then
        begin
                if SelectedChannel = LeftChannel then
                begin
                        b := round( (Value + 1)*255/2 );
                        FWaveStream.Seek(HeaderSize + 2*Position, 0);
                        FWaveStream.Write(b, 1);
                end
                else
                begin
                        b := round( (Value + 1)*255/2 );
                        FWaveStream.Seek(HeaderSize + 2*Position + 1, 0);
                        FWaveStream.Write(b, 1);
                end;
        end
        else
        begin
                if SelectedChannel = LeftChannel then
                begin
                        w := round( (Value - 1 + 65534/65535)*65535/2 );
                        FWaveStream.Seek(HeaderSize + 4*Position, 0);
                        FWaveStream.Write(w, 2);
                end
                else
                begin
                        w := round( (Value - 1 + 65534/65535)*65535/2 );
                        FWaveStream.Seek(HeaderSize + 4*Position + 2, 0);
                        FWaveStream.Write(w, 2);
                end;
        end;
end;

end;


procedure TWave.ConvertToMono;
// Converts a stereo recording to mono recording
var
        i: Longword;
        b1, b2: Byte;
        w1, w2: Smallint;
begin

if FWaveHeader.NumChannels = 1 then Exit;

FTempWaveHeader := FWaveHeader;
FTempWaveHeader.NumChannels := 1;
FTempWaveHeader.ByteRate := FWaveHeader.ByteRate div 2;
FTempWaveHeader.Subchunk2Size := FWaveheader.Subchunk2Size div 2;
FTempWaveHeader.ChunkSize := 36 + FWaveheader.Subchunk2Size;
FTempWaveHeader.BlockAlign := FTempWaveHeader.NumChannels *
FTempWaveHeader.BitsPerSample div 8;

FTempWaveStream := TMemoryStream.Create;
FTempWaveStream.SetSize( HeaderSize + FTempWaveHeader.Subchunk2Size );

FTempWaveStream.Seek(0, 0);
FTempWaveStream.Write(FTempWaveHeader, HeaderSize);

for i := 0 to Size - 1 do
begin
        // For the OnProgress event
        if ( (Assigned(FProgress) ) and (i mod 100 = 0) ) then
                FProgress(Self, round( 100*i/(Size - 1) ) );

        if FWaveHeader.BitsPerSample  = 8 then
        begin
                FWaveStream.Seek(HeaderSize + 2*i, 0);
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + 2*i + 1, 0);
                FWaveStream.Read(b2, 1);

                // Computing channel average
                b1 := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + i, 0);
                FTempWaveStream.Write(b1, 1);
        end
        else
        begin
                FWaveStream.Seek(HeaderSize + 4*i, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FWaveStream.Read(w2, 2);

                // Computing channel average
                w1 := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 2*i, 0);
                FTempWaveStream.Write(w1, 2);
        end;
end;
if Assigned(FProgress) then FProgress(Self, -1);

// Updates the wave
FWaveStream.LoadFromStream(FTempWaveStream);
FWaveHeader := FTempWaveHeader;
FTempWaveStream.Free;

end;


procedure TWave.ConvertToStereo;
// Converts a mono recording to a stereo recording
var
        i: Longword;
        b: Byte;
        w: Smallint;
begin

if FWaveHeader.NumChannels = 2 then Exit;

FTempWaveHeader := FWaveHeader;
FTempWaveHeader.NumChannels := 2;
FTempWaveHeader.ByteRate := 2*FWaveHeader.ByteRate;
FTempWaveHeader.Subchunk2Size := 2*FWaveheader.Subchunk2Size;
FTempWaveHeader.ChunkSize := 36 + FTempWaveHeader.Subchunk2Size;
FTempWaveHeader.BlockAlign := FTempWaveHeader.NumChannels *
FTempWaveHeader.BitsPerSample div 8;

FTempWaveStream := TMemoryStream.Create;
FTempWaveStream.SetSize( HeaderSize +  FTempWaveHeader.Subchunk2Size);

FTempWaveStream.Seek(0, 0);
FTempWaveStream.Write(FTempWaveHeader, HeaderSize);

for i := 0 to Size - 1 do
begin
        // For the OnProgress event
        if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                FProgress(Self, round( 100*i/(Size - 1) ) );

        if FWaveHeader.BitsPerSample  = 8 then
        begin
                FWaveStream.Seek(HeaderSize + i, 0);
                FTempWaveStream.Seek(HeaderSize + 2*i, 0);
                FWaveStream.Read(b, 1);
                FTempWaveStream.Write(b, 1);

                // Writes to right channel 
                FTempWaveStream.Seek(HeaderSize + 2*i + 1, 0);
                FTempWaveStream.Write(b, 1);
        end
        else
        begin
                FWaveStream.Seek(HeaderSize + 2*i, 0);
                FTempWaveStream.Seek(HeaderSize + 4*i, 0);
                FWaveStream.Read(w, 2);
                FTempWaveStream.Write(w, 2);

                // Writes to right channel
                FTempWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FTempWaveStream.Write(w, 2);
        end
end;
if Assigned(FProgress) then FProgress(Self, -1);

// Updates the wave
FWaveStream.LoadFromStream(FTempWaveStream);
FWaveHeader := FTempWaveHeader;
FTempWaveStream.Free;

end;


procedure TWave.ConvertTo8Bits;
// converts the wave to 8 bit resolution
var
        i: Longword;
        k, b: byte;
        w: Smallint;
        c1, c2: Double;
begin

if FWaveHeader.BitsPerSample = 8 then Exit;

FTempWaveHeader := FWaveHeader;
FTempWaveHeader.BitsPerSample := 8;
FTempWaveHeader.ByteRate := FWaveHeader.ByteRate div 2;
FTempWaveHeader.Subchunk2Size := FWaveheader.Subchunk2Size div 2;
FTempWaveHeader.ChunkSize := 36 + FTempWaveHeader.Subchunk2Size;
FTempWaveHeader.BlockAlign := FTempWaveHeader.NumChannels *
FTempWaveHeader.BitsPerSample div 8;

FTempWaveStream := TMemoryStream.Create;
FTempWaveStream.SetSize( HeaderSize +  FTempWaveHeader.Subchunk2Size);

FTempWaveStream.Seek(0, 0);
FTempWaveStream.Write(FTempWaveHeader, HeaderSize);

if FWaveHeader.NumChannels = 1 then
        k := 1
else
        k := 2;

// Linear mapping: 8bit = c1*16bit + c2
c1 := 255/65535;
c2 := 32768*c1;
for i := 0 to k*(Size - 1) + 1 do // "+ 1" to remove click sound
begin
        // For the OnProgress event
        if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                FProgress(Self, round( 100*i/(k*(Size - 1)) ) );

        FWaveStream.Seek(HeaderSize + 2*i, 0);
        FWaveStream.Read(w, 2);
        b := round( c1*w + c2 );

        FTempWaveStream.Seek(HeaderSize + i, 0);
        FTempWaveStream.Write(b, 1);
end;
if Assigned(FProgress) then FProgress(Self, -1);

// Updates the wave
FWaveStream.LoadFromStream(FTempWaveStream);
FWaveHeader := FTempWaveHeader;
FTempWaveStream.Free;

end;


procedure TWave.ConvertTo16Bits;
// converts the wave to 16 bit resolution
var
        i: Longword;
        b, k: byte;
        w: Smallint;
        c1, c2: Double;
begin

if FWaveHeader.BitsPerSample = 16 then Exit;

FTempWaveHeader := FWaveHeader;
FTempWaveHeader.BitsPerSample := 16;
FTempWaveHeader.ByteRate := 2*FWaveHeader.ByteRate;
FTempWaveHeader.Subchunk2Size := 2*FWaveheader.Subchunk2Size;
FTempWaveHeader.ChunkSize := 36 + FTempWaveHeader.Subchunk2Size;
FTempWaveHeader.BlockAlign := FTempWaveHeader.NumChannels *
FTempWaveHeader.BitsPerSample div 8;

FTempWaveStream := TMemoryStream.Create;
FTempWaveStream.SetSize( HeaderSize +  FTempWaveHeader.Subchunk2Size );

FTempWaveStream.Seek(0, 0);
FTempWaveStream.Write(FTempWaveHeader, HeaderSize);

if FWaveHeader.NumChannels = 1 then
        k := 1
else
        k := 2;

// Linear mapping: 16bit = c1*8bit + c2
c1 := 65535/255;
c2 := -32768;
for i := 0 to k*(Size - 1) + 1 do // "+ 1" to remove click sound
begin
        // For the OnProgress event
        if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                FProgress(Self, round( 100*i/(k*(Size - 1)) ) );

        FWaveStream.Seek(HeaderSize + i, 0);
        FWaveStream.Read(b, 1);
        w := round( c1*b + c2 );

        FTempWaveStream.Seek(HeaderSize + 2*i, 0);
        FTempWaveStream.Write(w, 2);
end;
if Assigned(FProgress) then FProgress(Self, -1);

// Updates the wave
FWaveStream.LoadFromStream(FTempWaveStream);
FWaveHeader := FTempWaveHeader;
FTempWaveStream.Free;

end;


procedure TWave.DoubleSampleRate;
// Doubles the sample rate without changing the pitch of the wave
var
        i: Longword;
        b, b1, b2: byte;
        w, w1, w2: Smallint;
begin

FTempWaveHeader := FWaveHeader;
FTempWaveHeader.SampleRate := 2*FWaveHeader.SampleRate;
FTempWaveHeader.ByteRate := 2*FWaveHeader.ByteRate;

// To remove click sound
if ((FWaveHeader.NumChannels = 1) and (FWaveHeader.BitsPerSample  = 8)) then
        FTempWaveHeader.Subchunk2Size := 2*FWaveheader.Subchunk2Size - 2
else if ((FWaveHeader.NumChannels = 2) and (FWaveHeader.BitsPerSample  = 8)) then
        FTempWaveHeader.Subchunk2Size := 2*FWaveheader.Subchunk2Size - 6
else if ((FWaveHeader.NumChannels = 1) and (FWaveHeader.BitsPerSample  = 16)) then
        FTempWaveHeader.Subchunk2Size := 2*FWaveheader.Subchunk2Size - 6
else FTempWaveHeader.Subchunk2Size := 2*FWaveheader.Subchunk2Size - 10;

FTempWaveHeader.ChunkSize := 36 + FTempWaveHeader.Subchunk2Size;
FTempWaveHeader.BlockAlign := FTempWaveHeader.NumChannels *
FTempWaveHeader.BitsPerSample div 8;

FTempWaveStream := TMemoryStream.Create;
FTempWaveStream.SetSize( HeaderSize +  FTempWaveHeader.Subchunk2Size );

FTempWaveStream.Seek(0, 0);
FTempWaveStream.Write(FTempWaveHeader, HeaderSize);

if FWaveHeader.NumChannels = 1 then
begin   // mono
        if FWaveHeader.BitsPerSample  = 8 then
        for i := 0 to FWaveHeader.Subchunk2Size - 2  do //OK
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(100*i/(FWaveHeader.Subchunk2Size -
                        2)) );

                FWaveStream.Seek(HeaderSize + i, 0);
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + i + 1, 0);
                FWaveStream.Read(b2, 1);

                b := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + 2*i, 0);
                FTempWaveStream.Write(b1, 1);
                FTempWaveStream.Seek(HeaderSize + 2*i + 1, 0);
                FTempWaveStream.Write(b, 1);
        end
        else
        for i := 0 to (FWaveHeader.Subchunk2Size - 4) div 2 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(200*i/(FWaveHeader.Subchunk2Size -
                        4)) );

                FWaveStream.Seek(HeaderSize + 2*i, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 2*i + 2, 0);
                FWaveStream.Read(w2, 2);

                w := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 4*i, 0);
                FTempWaveStream.Write(w1, 2);
                FTempWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FTempWaveStream.Write(w, 2);
        end;
end
else    // stereo
begin
        if FWaveHeader.BitsPerSample  = 8 then
        for i := 0 to (FWaveHeader.Subchunk2Size - 4) div 2 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(200*i/(FWaveHeader.Subchunk2Size -
                        4)) );

                // Left channel
                FWaveStream.Seek(HeaderSize + 2*i, 0);          //0,2,4
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + 2*i + 2, 0);      //2,4,8
                FWaveStream.Read(b2, 1);

                b := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + 4*i, 0);
                FTempWaveStream.Write(b1, 1);
                FTempWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FTempWaveStream.Write(b, 1);

                // Right channel
                FWaveStream.Seek(HeaderSize + 2*i + 1, 0);      //1,3,5
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + 2*i + 3, 0);      //3,5,9
                FWaveStream.Read(b2, 1);

                b := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + 4*i + 1, 0);
                FTempWaveStream.Write(b1, 1);
                FTempWaveStream.Seek(HeaderSize + 4*i + 3, 0);
                FTempWaveStream.Write(b, 1);
        end
        else
        for i := 0 to (FWaveHeader.Subchunk2Size - 8) div 4 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(400*i/(FWaveHeader.Subchunk2Size -
                        8)) );

                // Left channel
                FWaveStream.Seek(HeaderSize + 4*i, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 4*i + 4, 0);
                FWaveStream.Read(w2, 2);

                w := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 8*i, 0);
                FTempWaveStream.Write(w1, 2);
                FTempWaveStream.Seek(HeaderSize + 8*i + 4, 0);
                FTempWaveStream.Write(w, 2);

                // Right channel
                FWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 4*i + 6, 0);
                FWaveStream.Read(w2, 2);

                w := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 8*i + 2, 0);
                FTempWaveStream.Write(w1, 2);
                FTempWaveStream.Seek(HeaderSize + 8*i + 6, 0);
                FTempWaveStream.Write(w, 2);
        end;
end;
if Assigned(FProgress) then FProgress(Self, -1);

// Updates the wave
FWaveStream.LoadFromStream(FTempWaveStream);
FWaveHeader := FTempWaveHeader;
FTempWaveStream.Free;

end;


procedure TWave.HalveSampleRate;
// Halves the sample rate without changing the pitch of the wave
var
        i: Longword;
        b, b1, b2: byte;
        w, w1, w2: Smallint;
begin

FTempWaveHeader := FWaveHeader;
FTempWaveHeader.SampleRate := FWaveHeader.SampleRate div 2;
FTempWaveHeader.ByteRate := FWaveHeader.ByteRate div 2;
FTempWaveHeader.Subchunk2Size := FWaveheader.Subchunk2Size div 2;
FTempWaveHeader.ChunkSize := 36 + FTempWaveHeader.Subchunk2Size;
FTempWaveHeader.BlockAlign := FTempWaveHeader.NumChannels *
FTempWaveHeader.BitsPerSample div 8;

FTempWaveStream := TMemoryStream.Create;
FTempWaveStream.SetSize( HeaderSize +  FTempWaveHeader.Subchunk2Size );

FTempWaveStream.Seek(0, 0);
FTempWaveStream.Write(FTempWaveHeader, HeaderSize);

if FWaveHeader.NumChannels = 1 then
begin   // mono
        if FWaveHeader.BitsPerSample  = 8 then
        for i := 0 to (FWaveHeader.Subchunk2Size - 2) div 2 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(200*i/(FWaveHeader.Subchunk2Size -
                        2)) );

                FWaveStream.Seek(HeaderSize + 2*i, 0);
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + 2*i + 1, 0);
                FWaveStream.Read(b2, 1);

                b := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + i, 0);
                FTempWaveStream.Write(b, 1);
        end
        else
        for i := 0 to (FWaveHeader.Subchunk2Size - 4) div 4 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(400*i/(FWaveHeader.Subchunk2Size -
                        4)) );

                FWaveStream.Seek(HeaderSize + 4*i, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FWaveStream.Read(w2, 2);

                w := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 2*i, 0);
                FTempWaveStream.Write(w, 2);
        end;
end
else    // stereo
begin
        if FWaveHeader.BitsPerSample  = 8 then
        for i := 0 to (FWaveHeader.Subchunk2Size - 4) div 2 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(200*i/(FWaveHeader.Subchunk2Size -
                        4)) );

                // Left channel
                FWaveStream.Seek(HeaderSize + 4*i, 0);
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FWaveStream.Read(b2, 1);

                b := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + 2*i, 0);
                FTempWaveStream.Write(b, 1);

                // Right channel
                FWaveStream.Seek(HeaderSize + 4*i + 1, 0);
                FWaveStream.Read(b1, 1);
                FWaveStream.Seek(HeaderSize + 4*i + 3, 0);
                FWaveStream.Read(b2, 1);

                b := (b1 + b2) div 2;
                FTempWaveStream.Seek(HeaderSize + 2*i + 1, 0);
                FTempWaveStream.Write(b, 1);
        end
        else
        for i := 0 to (FWaveHeader.Subchunk2Size - 8) div 4 do  //OK!
        begin
                // For the OnProgress event
                if ( (Assigned(FProgress)) and (i mod 100 = 0) ) then
                        FProgress(Self, round(400*i/(FWaveHeader.Subchunk2Size -
                        8)) );

                // Left channel
                FWaveStream.Seek(HeaderSize + 8*i, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 8*i + 4, 0);
                FWaveStream.Read(w2, 2);

                w := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 4*i, 0);
                FTempWaveStream.Write(w, 2);

                // Right channel
                FWaveStream.Seek(HeaderSize + 8*i + 2, 0);
                FWaveStream.Read(w1, 2);
                FWaveStream.Seek(HeaderSize + 8*i + 6, 0);
                FWaveStream.Read(w2, 2);

                w := (w1 + w2) div 2;
                FTempWaveStream.Seek(HeaderSize + 4*i + 2, 0);
                FTempWaveStream.Write(w, 2);
        end;
end;
if Assigned(FProgress) then FProgress(Self, -1);

// Updates the wave
FWaveStream.LoadFromStream(FTempWaveStream);
FWaveHeader := FTempWaveHeader;
FTempWaveStream.Free;

end;

//------------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('Wave', [TWave]);
end;

end.
