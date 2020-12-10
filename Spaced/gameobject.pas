{$I head}
(* Game object class definitions *)
unit GameObject;

interface

uses SDL, FGL;

type
    TThing = class
    public
        X, Y: Integer;
        OX, OY: Single; (* splash *)
        WX, WY: Integer; (* width, height *)
        Img: PSDL_Surface;
    end;

    PEnemy = ^TEnemy;
    TEnemy = class(TThing)
    public
        TOX, TOY: Single; (* splash control *)
        Direction: Integer;
        FireScale: Integer;
        procedure SetValues(IX, IY: Integer; IDirection: Integer; ILevel: Integer;
            Image: Integer); virtual;
        procedure ExtraMotion(PX, PY: Integer); virtual;
        procedure BounceMotionLimited(Collider: PEnemy); virtual;
    end;

    TProjectile = class(TThing)
    public
        FX, FY: Single; (* centroid *)
        DX, DY: Single; (* delta *)
        PHarm, EHarm: Boolean; (* player and enemy harm flags *)
        Life: Integer; (* life time of existance *)
    end;

    TThingList = specialize TFPGObjectList<TThing>;
    TEnemyList = specialize TFPGObjectList<TEnemy>;
    TProjectileList = specialize TFPGObjectList<TProjectile>;

var
    Enemies: TEnemyList;
    Projectiles: TProjectileList;
    ToDelete: array of TObject;
    ImagesLoaded: array of PSDL_Surface;

procedure DeleteLater(AObject: TObject);
procedure DeleteDeferredObjects;
function RectOverRect(AX1, AY1, AX2, AY2, BX1, BY1, BX2, BY2: Integer): Boolean; inline;
function CollisionWithEnemy(CX, CY: Integer; CW: Integer=32; CH: Integer=32;
    Ignore: Integer=-1; Enemy: PEnemy=nil): Boolean;
function Load(Name: AnsiString): PSDL_Surface;

implementation

procedure DeleteLater(AObject: TObject);
var
    I: Integer;
begin
    for I:=0 to High(ToDelete) do if ToDelete[I]=AObject then Exit;
    SetLength(ToDelete, Length(ToDelete) + 1);
    ToDelete[High(ToDelete)]:=AObject;
end;

procedure DeleteDeferredObjects;
var
    I: Integer;
begin
    for I:=0 to High(ToDelete) do begin
        if ToDelete[I] is TProjectile then Projectiles.Remove(TProjectile(ToDelete[I]))
        else if ToDelete[I] is TEnemy then Enemies.Remove(TEnemy(ToDelete[I]))
        else ToDelete[I].Free;
    end;
    SetLength(ToDelete, 0);
end;

function RectOverRect(AX1, AY1, AX2, AY2, BX1, BY1, BX2, BY2: Integer): Boolean; inline;
begin
    Result:=not ((BX1 > AX2) or (BX2 < AX1) or (BY1 > AY2) or (BY2 < AY1));
end;

function CollisionWithEnemy(CX, CY: Integer; CW: Integer=32; CH: Integer=32;
    Ignore: Integer=-1; Enemy: PEnemy=nil): Boolean;
var
    I: Integer;
begin
    for I:=0 to Enemies.Count - 1 do with Enemies[I] do
        if (I <> Ignore) and RectOverRect(X, Y, X + WX - 1, Y + WY - 1,
            CX, CY, CX + CW - 1, CY + CH - 1) then
            begin
                if Assigned(Enemy) then Enemy^:=Enemies[I];
                Exit(True);
            end;
    Result:=False;
end;

function Load(Name: AnsiString): PSDL_Surface;
begin
    Result:=SDL_LoadBMP(PChar(Name));
    if Length(ImagesLoaded) <> 0 then
        SDL_SetColorKey(Result, SDL_SRCCOLORKEY, SDL_MapRGB(Result^.format, 255, 0, 255));
    SetLength(ImagesLoaded, Length(ImagesLoaded) + 1);
    ImagesLoaded[High(ImagesLoaded)]:=Result;
end;

procedure TEnemy.SetValues(IX, IY: Integer; IDirection: Integer; ILevel: Integer;
    Image: Integer);
begin
    X:=IX;
    Y:=IY;
    Wx:=32;
    WY:=32;
    Direction:=IDirection;
    FireScale:=100;
    Image:=Image - 1; (* dynamic array starts at zero as dynamic !! *)
    if (ILevel*17 + X*311 + Y*3787) mod 2=0 then
        Img:=ImagesLoaded[Image]
    else
        Img:=ImagesLoaded[Image + 1];
end;

procedure TEnemy.ExtraMotion(PX, PY: Integer);
begin

end;

procedure TEnemy.BounceMotionLimited(Collider: PEnemy);
begin

end;

end.
