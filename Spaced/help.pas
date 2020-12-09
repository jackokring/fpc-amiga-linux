{$I head}

unit Help;

interface

const
    DirectoryPrefix = 'spaced'; (* could get confusing if different apps used *)

resourcestring
    (* here goes the constant strings to be extracted for using the linguistic interface *)

    (* exception help *)
    (* for all bad input values *)
    FormatExHelp = 'Some input was in a bad or malicious format.';
    (* for all cases where the input is not available *)
    ConsumerExHelp = 'There is nothing to consume as input.';
    (* for all cases where the output has nowhere to go *)
    ProducerExHelp = 'The output production has nowhere to go.';
    (* for all cases where a keyed index can not be found *)
    NameExHelp = 'That is not found, or creation was impossible.';
    (* for all cases where there is more than one way of progressing *)
    AmbiguityExHelp = 'There is no way to determine a best course of action.';
    (* for when something else failed to provide the service *)
    ProxyExHelp = 'Some other external application had problems.';
    (* this is related to zero being special *)
    OriginExHelp = 'Zero is strange. Emptiness everywhere but nowhere.';
    (* this is related to consumer/producer exceptions, but where no input/output would even make sense *)
    LimitExHelp = 'There is no past the current limits. Finite things.';
    (* this is the terminal exception which creates all other exceptions, an easy raise *)
    FinalExHelp = 'It was impossible to complete processing something.';
    (* this is for correct format, but incorrect credential (public) keys *)
    IdentityExHelp = 'Your credentials did not verify.';
    (* this is for correct format, but incorrect decoding (private) keys *)
    DecoderExHelp = 'It was not possible to decode using that key.';
    (* sometimes the ETA is beyond acceptable *)
    CoachExHelp = 'The time required exceeds the alloted amount.';

function ProgramDir(): String;
function CS(a: String; b: String): Boolean;
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
                                        J := Pos(GetNextWrap(Input, I), Finds);
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
    TranslateResourceStrings(ProgramDir() + DirectoryPrefix + '-langs/%s.mo');

end.
