unit HKDebugMem;

interface

implementation
var
 m,m2: TMemoryManager;

function CGetMem(Size: Integer): Pointer;
begin
 result:=m.GetMem(size);
end;

function CFreeMem(P: Pointer): Integer;
begin
 result:=m.FreeMem(p);
 if result<>0 then
  inc(result);
end;

function CReallocMem(P: Pointer; Size: Integer): Pointer;
begin
 result:=m.ReallocMem(p,size);
end;

initialization
 GetMemoryManager(m);
 m2.GetMem:=CGetmem;
 m2.FreeMem:=cfreemem;
 m2.ReallocMem:=creallocmem;
 SetMemorymanager(m2);
end.
