{$I head}
(* Game object class definitions *)
unit GameObject;

uses FGL;

interface

type
    TThing = class
    public
        X, Y: Integer;
        OX, OY: Single;
        Img: PSDL_Surface;
    end;

    PEnemy = ^TEnemy;
    TEnemy = class(TThing)
    public
        TOX, TOY: Single;
        Direction: Integer;
    end;

    TProjectile = class(TThing)
    public
        FX, FY, DX, DY: Single;
        PHarm, EHarm: Boolean;
        Life: Integer;
    end;

    TThingList = specialize TFPGObjectList<TThing>;
    TEnemyList = specialize TFPGObjectList<TEnemy>;
    TProjectileList = specialize TFPGObjectList<TProjectile>;

var
    Enemies: TEnemyList;
    Projectiles: TProjectileList;
    ToDelete: array of TObject;

procedure DeleteLater(AObject: TObject);
procedure DeleteDeferredObjects;

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

end.
