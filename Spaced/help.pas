{$I head}
(* All the literal texts for i18n translation plus some helper routines *)
unit Help;

interface

const
        DirectoryPrefix = 'spaced'; (* could get confusing if different apps used *)

resourcestring
        (* here goes the constant strings to be extracted for using the linguistic interface *)
        GameName = 'Spaced';

function ProgramDir(): String;
function CS(a: String; b: String): Boolean; (* Compare String *)
function EscC(input: String): String;
function NowUTC(): TDateTime;
function GetISODate(): String;

implementation

uses GetText, SysUtils;

function ProgramDir(): String;
begin
        ExtractFilePath(ParamStr(0));
end;

function CS(a: String; b: String): Boolean; (* Compare String *)
begin
        CS := (CompareStr(a, b) = 0);
end;

function GetNextWrap(Input: String; Idx: LongInt): Char;
BEGIN
        IF (Idx > Length(Input)) or (Idx < 1) THEN
                GetNextWrap := Char(32) (* no find space *)
        ELSE
                GetNextWrap := Input[Idx];
END;

function EscC(Input: String): String;
const
        Finds = 'abfnrtv\''"?e';
        RepWith = #$07#$08#$0C#$0A#$0D#$09#$0B#$5C#$27#$22#$3F#$1B;
var
        I, J: LongInt;
        Miss: Boolean = False;
begin
        EscC := '';
        if Length(Input) = 0 then
                EXIT;
        for I := 1 to Length(Input) do
                begin
                        if Miss then
                                begin
                                        Miss := False;
                                        continue;
                                end;
                        if Input[I] = #92 then (* backslash *)
                                begin
                                        J := Pos(GetNextWrap(Input, I + 1), Finds);
                                        if J > 0 then
                                                begin
                                                        EscC := EscC + RepWith[J];
                                                        Miss := True;
                                                end
                                        else (* missed the what? *)
                                                EscC := EscC + '[Invalid Backslash]'; (* make easy *)
                                end
                        else
                                EscC := EscC + Input[I];
                end;
end;

function NowUTC(): TDateTime;
begin
        NowUTC := Now() + GetLocalTimeOffset();
end;

function GetISODate(): String;
begin
        GetISODate := FormatDateTime('yyyy-mm-dd hh:nn:ss', NowUTC());
end;

initialization
        TranslateResourceStrings(ProgramDir() + '/' + DirectoryPrefix + '-langs/%s.mo');
end.
