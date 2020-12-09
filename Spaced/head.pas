(* $I done when done with debugging *)
{$IFDEF DONE_ALL}
    (* there is no need to debug *)
{$ELSE}
    {$DEFINE DEBUG} (* set debug mode *)
{$ENDIF}

{$MODE OBJFPC} (* object free pascal standard *)
{$CODEPAGE UTF8}
{$H+} (* boost to AnsiString, long style *)
(* 
    NOTES:
        ShortInt is signed 8 bit.
        SmallInt is signed 16 bit.
        Integer is signed 32 bit. (<===)
        LongInt is signed 32 bit..
        Int64 is signed 64 bit.
        =============================================
        Byte is unsigned 8 bit.
        Word is unsigned 16 bit.
        LongWord is unsigned 32 bit.
        DWord is unsigned 32 bit.
        Cardinal is unsigned 32 bit.
        QWord is unsigned 64 bit.
        =============================================
        String is AnsiString, after boost.
        UString is UnicodeString, after uses U437.
*)

{$IFDEF DEBUG}
    {$IFNDEF LINUX}
        {$CHECKPOINTER ON}
    {$ENDIF}
    {$R+}
    {$ASSERTIONS ON}
    {$T+} (* pointer type checking *)
    {$V+} (* string size checks, but not that ANSI relevant *)
{$ELSE}
    {$OPTIMIZATION ON}
    {$ASSERTIONS OFF}
    {$BITPACKING ON} (* this may lose some pointers, but such structures are usually not packed *)
    {$INLINE ON}
{$ENDIF}