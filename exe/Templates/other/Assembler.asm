; *******************************************************
; *                                                     *
; *                                                     *
; *                                                     *
; *                                                     *
; *                                                     *
; *******************************************************

    INCLUDE SE.ASM

    .386
    .MODEL  FLAT

    EXTRN   _Pow10:NEAR

    PUBLIC  _ValExt, @_ValExt

    .CODE

;   FUNCTION _ValExt( s: AnsiString; VAR code: Integer ) : Extended;

_ValExt PROC
@_ValExt:


_ValExt ENDP

    END
