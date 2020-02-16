IMPLEMENTATION MODULE Ticker;
(*
*)

FROM SYSTEM     IMPORT ASSEMBLER, ADDRESS;
FROM System     IMPORT TermProcedure, GetVector, SetVector, ResetVector;

(* $S- *)

VAR
    ClockTick       :ADDRESS;

PROCEDURE StopClock;
BEGIN
    (* restore the original clock ISR *)
    ResetVector( 8, ClockTick );
END StopClock;

PROCEDURE Tick;
BEGIN
    ASM
        STI
        PUSH    DS
        MOV     DS, CS:[0]
        INC     Ticks
        PUSHF                       (* Chain interrupt *)
        CALL    FAR ClockTick       (* Invoke the system's clock ISR *)
        POP     DS
        IRET
    END;
END Tick;

BEGIN
    Ticks := 0;
    GetVector( 8, ClockTick );      (* save system's clock ISR *)
    TermProcedure( StopClock );     (* set procedure to restore system's ISR *)
                                    (* on program termination *)
    SetVector( 8, Tick );           (* install our own clock ISR *)

END Ticker.

IMPLEMENTATION MODULE People;
  FROM Strings IMPORT CompareStr, Assign;

  CLASS Person;    (* a class implementation *)
    PROCEDURE isMale() :BOOLEAN;
      BEGIN
        RETURN sex = male;
      END isMale;
    INIT
      name := "";
      sex := unknown;
 END Person;

  CLASS Programmer;  (* a class implementation *)
    PROCEDURE isSmart() :BOOLEAN;
      BEGIN
        RETURN CompareStr(favoriteLanguage,"Modula-2") = 0;
      END isSmart;
    INIT
      favoriteLanguage := "?";
  END Programmer;

  CLASS Vendor;      (* a local class declaration *)
    INHERIT Programmer;
    BusinessAddress : ARRAY [0..40] OF CHAR;
    PROCEDURE GetAddress (VAR Address : ARRAY OF CHAR);
      BEGIN
        Assign(BusinessAddress, Address)
      END GetAddress;
    INIT
      BusinessAddress := ""
  END Vendor;
END People.