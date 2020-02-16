unit VirtualShellContainers;

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------
//
// Classes to help with storing TNamespaces

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes,
  {$IFDEF COMPILER_5_UP}
  Contnrs,
  {$ENDIF}
  VirtualShellUtilities;

type

  {$IFNDEF COMPILER_5_UP}
    TObjectList = class(TList)
  private
    FOwnsObjects: Boolean;
  protected
    function GetItem(Index: Integer): TObject;
    procedure SetItem(Index: Integer; AObject: TObject);
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;

    function Add(AObject: TObject): Integer;
    function Remove(AObject: TObject): Integer;
    function IndexOf(AObject: TObject): Integer;
    function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer = 0): Integer;
    procedure Insert(Index: Integer; AObject: TObject);
    function First: TObject;
    function Last: TObject;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: TObject read GetItem write SetItem; default;
  end;
  {$ENDIF}

  TVirtualNameSpaceList  = class(TObjectList)
  private
    function GetItems(Index: Integer): TNamespace;
    procedure SetItems(Index: Integer; ANamespace: TNamespace);
  public
    function Add(ANamespace: TNamespace): Integer;
    procedure FillArray(var NamespaceArray: TNamespaceArray);
    function IndexOf(ANamespace: TNamespace): Integer;
    procedure Insert(Index: Integer; ANamespace: TNamespace);
    property Items[Index: Integer]: TNamespace read GetItems write SetItems; default;
  end;

implementation

{$IFNDEF COMPILER_5_UP}
{ TObjectList }

function TObjectList.Add(AObject: TObject): Integer;
begin
  Result := inherited Add(AObject);
end;

constructor TObjectList.Create;
begin
  inherited Create;
  FOwnsObjects := True;
end;

constructor TObjectList.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

function TObjectList.FindInstanceOf(AClass: TClass; AExact: Boolean;
  AStartAt: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := AStartAt to Count - 1 do
    if (AExact and
        (Items[I].ClassType = AClass)) or
       (not AExact and
        Items[I].InheritsFrom(AClass)) then
    begin
      Result := I;
      break;
    end;
end;

function TObjectList.First: TObject;
begin
  Result := TObject(inherited First);
end;

function TObjectList.GetItem(Index: Integer): TObject;
begin
  Result := inherited Items[Index];
end;

function TObjectList.IndexOf(AObject: TObject): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TObjectList.Insert(Index: Integer; AObject: TObject);
begin
  inherited Insert(Index, AObject);
end;

function TObjectList.Last: TObject;
begin
  Result := TObject(inherited Last);
end;

function TObjectList.Remove(AObject: TObject): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TObjectList.SetItem(Index: Integer; AObject: TObject);
begin
  inherited Items[Index] := AObject;
end;
{$ENDIF}

{ TVirtualNamespaceList }

function TVirtualNamespaceList.Add(ANamespace: TNamespace): Integer;
begin
  Result := inherited Add(ANamespace);
end;

procedure TVirtualNamespaceList.FillArray(var NamespaceArray: TNamespaceArray);
var
  I: Integer;
begin
  SetLength(NamespaceArray, Count);
  for I := 0 to Count - 1 do
    NamespaceArray[0] := Items[I];
end;

function TVirtualNamespaceList.GetItems(Index: Integer): TNamespace;
begin
  Result := TNamespace(inherited Items[Index]);
end;

function  TVirtualNamespaceList.IndexOf(ANamespace: TNamespace): Integer;
begin
  Result := inherited IndexOf(ANamespace);
end;

procedure TVirtualNamespaceList.Insert(Index: Integer; ANamespace: TNamespace);
begin
  inherited Insert(Index, ANamespace);
end;

procedure TVirtualNamespaceList.SetItems(Index: Integer; ANamespace: TNamespace);
begin
  inherited Items[Index] := ANamespace;
end;

end.
