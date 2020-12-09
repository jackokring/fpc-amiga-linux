{$I head}

UNIT Help;

INTERFACE

CONST
    directoryPrefix = 'Spaced'; (* could get confusing if different apps used *)

RESOURCESTRING
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

    (* verb help *)
    versionHelp = '';
    testHelp = '';
    testsHelp = '';
    helpHelp = '';
    hasHelp = '';
    isHelp = '';
    olderHelp = '';
    oldestHelp = '';

FUNCTION programDir(): String;
FUNCTION CS(a: String; b: String): Boolean;
FUNCTION escC(input: String): String;
FUNCTION nowUTC(): TDateTime;
FUNCTION getISODate(): String;

IMPLEMENTATION

USES GetText, sysutils;

FUNCTION programDir(): String;
BEGIN
    ExtractFilePath(ParamStr(0));
END;

FUNCTION CS(a: String; b: String): Boolean;
BEGIN
        CS := (CompareStr(a, b) = 0);
END;

FUNCTION getNextWrap(input: String; idx: LongInt): Char;
BEGIN
        IF (idx > length(input)) or (idx < 1) THEN
                getNextWrap := Char(32) (* no find space *)
        ELSE
                getNextWrap := input[idx];
END;

CONST
        finds = 'abfnrtv\''"?e';
        repWith = #$07#$08#$0C#$0A#$0D#$09#$0B#$5C#$27#$22#$3F#$1B;

FUNCTION escC(input: String): String;
VAR
        i, j: LongInt;
        miss: Boolean = False;
BEGIN
        escC := '';
        IF length(input) = 0 THEN
                EXIT;
        FOR i := 1 TO length(input) DO
                BEGIN
                        IF miss THEN
                                BEGIN
                                        miss := False;
                                        CONTINUE;
                                END;
                        IF input[i] = #92 THEN (* backslash *)
                                BEGIN
                                        j := Pos(getNextWrap(input, i), finds);
                                        IF j > 0 THEN
                                                BEGIN
                                                        escC := escC + repWith[j];
                                                        miss := True;
                                                END
                                        ELSE (* missed the what? *)
                                                escC := escC + '[Invalid Backslash]'; (* make easy *)
                                END
                        ELSE
                                escC := escC + input[i];
                END;
END;

FUNCTION nowUTC(): TDateTime;
BEGIN
    nowUTC := now() + GetLocalTimeOffset();
END;

FUNCTION getISODate(): String;
BEGIN
        getISODate := FormatDateTime('yyyy-mm-dd hh:nn:ss', nowUTC());
END;

INITIALIZATION
    TranslateResourceStrings(programDir() + directoryPrefix + '-langs/%s.mo');

END.
