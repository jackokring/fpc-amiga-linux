{$I head}
program Spaced;

uses
  SDL, Math, GameObject, Help;

var
  Surface, RealSurface: PSDL_Surface;
  Running: Boolean = True;
  KeyState: array [0..1024] of Boolean;
  Background, LifeImg, PlayerImg, PlayerHitImg, PlayerDeadImg, PlayerShootImg,
    RetryImg, Nums, PBulletImg, EBulletImg, P1Img, P2Img: PSDL_Surface;
  PlayerX, PlayerY: Integer;
  Level, Life, Score, RetryY: Integer;
  PlayerShootTime, ShootTime, HitTime: Cardinal;
  ScaleMode: Integer = 2; (* best scaling *)
  PercentFire: Integer;
  CurrentTime: Cardinal; (* Animation counter *)

(* Generic movable processing and memory management *)
function SDL_SoftStretch(Src: PSDL_Surface; SrcRect: PSDL_Rect; Dst: PSDL_Surface; DstRect: PSDL_Rect): Integer; cdecl; external 'SDL';

procedure LaunchProjectile(X, Y, DX, DY: Single; Img: PSDL_Surface; PHarm, EHarm: Boolean; Life: Integer=-1);
var
  P: TProjectile;
begin
  P:=TProjectile.Create;
  Projectiles.Add(P);
  P.FX:=X;
  P.FY:=Y;
  P.X:=Round(X);
  P.Y:=Round(Y);
  P.DX:=DX;
  P.DY:=DY;
  P.Img:=Img;
  P.PHarm:=PHarm;
  P.EHarm:=EHarm;
  P.Life:=Life;
end;

function Key(K: Integer): Boolean; inline;
begin
  if (K >= Low(KeyState)) and (K <= High(KeyState)) then Result:=KeyState[K] else Result:=False;
end;

(* Video low level init *)
function InitVideo: Boolean;
var
  Flags: Cardinal = SDL_DOUBLEBUF or SDL_SWSURFACE;
  I: Integer;
  Bits: Integer = 16;
begin
  for I:=1 to ParamCount do begin
    if ParamStr(I)='-fullscreen' then begin
      Flags:=Flags + SDL_FULLSCREEN;
      SDL_ShowCursor(0);
    end;
    if ParamStr(I)='-single' then ScaleMode:=1;
    if ParamStr(I)='-double' then ScaleMode:=2;
    if ParamStr(I)='-triple' then ScaleMode:=3;
    if ParamStr(I)='-8bit' then Bits:=8;
  end;
  if ScaleMode > 1 then begin
    RealSurface:=SDL_SetVideoMode(320*ScaleMode, 240*ScaleMode, 16, Flags);
    with RealSurface^.format^ do
      Surface:=SDL_CreateRGBSurface(SDL_SWSURFACE, 320, 240, 16, Rmask, Gmask, Bmask, Amask);
  end else begin
    Surface:=SDL_SetVideoMode(320, 240, Bits, Flags);
    RealSurface:=Surface;
  end;
  Result:=Assigned(Surface);
end;

procedure ShowSurface;
var
  S, D: TSDL_Rect;
begin
  if ScaleMode > 1 then begin
    S.x:=0;
    S.y:=0;
    S.w:=320;
    S.h:=240;
    D.x:=0;
    D.y:=0;
    D.w:=320*ScaleMode;
    D.h:=240*ScaleMode;
    SDL_SoftStretch(Surface, @S, RealSurface, @D);
  end;
  SDL_Flip(RealSurface);
end;

(* Titles and full screen draw *)
procedure LoadImages;
begin
  Background:=Load('bgnd.bmp'); (* 1 *)
  Nums:=Load('nums.bmp'); (* 2 *)
  PlayerImg:=Load('player.bmp'); (* 3 *)
  PlayerHitImg:=Load('plrhit.bmp'); (* 4 *)
  PlayerDeadImg:=Load('plrdead.bmp'); (* 5 *)
  PlayerShootImg:=Load('plrshoot.bmp'); (* 6 *)
  RetryImg:=Load('retry.bmp'); (* 7 *)
  LifeImg:=Load('life.bmp'); (* 8 *)
  PBulletImg:=Load('pbullet.bmp'); (* 9 *)
  EBulletImg:=Load('ebullet.bmp'); (* 10 *)
  Load('enemy1.bmp'); (* 11 *)
  Load('enemy2.bmp'); (* 12 *)
  P1Img:=Load('part1.bmp'); (* 13 *)
  P2Img:=Load('part2.bmp'); (* 14 *)
end;

procedure WaveScreen;
begin

end;

procedure TitleScreen;
var
  Title: PSDL_Surface;
  Ev: TSDL_Event;
  ShowTitle: Boolean = True;
begin
  Title:=SDL_LoadBMP('title.bmp');
  while ShowTitle do begin
    while SDL_PollEvent(@Ev) <> 0 do begin
      case Ev.Type_ of
        SDL_QUITEV: begin
          Running:=False;
          ShowTitle:=False;
        end;
        SDL_KEYDOWN: case Ev.Key.KeySym.Sym of
          SDLK_ESCAPE: begin
            Running:=False;
            ShowTitle:=False;
          end;
          SDLK_Space: ShowTitle:=False;
        end;
      end;
    end;
    SDL_BlitSurface(Title, nil, Surface, nil);
    ShowSurface;
  end;
end;

procedure DrawScreen;

  procedure Draw(X, Y: Integer; Surf: PSDL_Surface);
  var
    R: TSDL_Rect;
  begin
    R.x:=X;
    R.y:=Y;
    R.w:=Surf^.w;
    R.h:=Surf^.h;
    SDL_BlitSurface(Surf, nil, Surface, @R);
  end;

  procedure DrawNum(X, Y, N: Integer);
  var
    R, S: TSDL_Rect;
  begin
    R.x:=X;
    R.y:=Y;
    R.w:=8;
    R.h:=10;
    S.x:=N*8;
    S.y:=0;
    S.w:=8;
    S.h:=10;
    SDL_BlitSurface(Nums, @S, Surface, @R);
  end;

  procedure DrawAnim(T: TThing);
  var
    R, S: TSDL_Rect;
  begin
    with T do
      R.x:=Round(X + OX);
      R.y:=Round(Y + OY);
      R.w:=WX;
      R.h:=WY;
      S.x:=WX*((CurrentTime shl LeftBits) and Frames);
      S.y:=0;
      S.w:=WX;
      S.h:=WH;
      SDL_BlitSurface(Img, @S, Surface, @R);
    end;
  end;

  procedure DrawNumber(X, Y, N: Integer);
  var
    V: Integer = 10000000;
  begin
    repeat
      if (N div V > 0) or (N=0) then begin
        DrawNum(X, Y, (N div V) mod 10);
        Inc(X, 8);
      end;
      V:=V div 10;
    until (V=0) or (N=0);
  end;

  procedure DrawThings(ThingList: TThingList);
  var
    I: Integer;
  begin
    for I:=0 to ThingList.Count - 1 do
      DrawAnim(ThingList[I]);
  end;

  procedure DrawHUD;
  var
    I: Integer;
  begin
    for I:=0 to Life - 1 do Draw(I*6 + 1, 14, LifeImg);
    DrawNumber(1, 1, Score);
    if Life=0 then Draw(40, RetryY, RetryImg);
  end;

begin
  Draw(0, 0, Background);
  if Life > 0 then begin
    if HitTime=0 then
      if ShootTime=0 then
        Draw(PlayerX, PlayerY, PlayerImg)
      else
        Draw(PlayerX, PlayerY, PlayerShootImg)
    else
      Draw(PlayerX, PlayerY, PlayerHitImg);
  end else
    Draw(PlayerX, PlayerY, PlayerDeadImg);
  DrawThings(TThingList(Enemies));
  DrawThings(TThingList(Projectiles));
  DrawHUD;

  ShowSurface;
end;

(* Game loop and initializers *)
procedure SetLevel(At: Integer);
begin
  Level:=At;
  PercentFire:=4*((Level div 3)+1);
end;

procedure NewGame(Reset: Boolean);

  procedure InitEnemies;
  var
    GX, GY: Integer;
  begin
    for GY:=0 to 3 do
      for GX:=0 to 7 do begin
        Enemies.Add(TEnemy.Create);
        with Enemies[GY*8 + GX] do begin
          SetValues(GX*32 + 32, GY*32, 1, Level, 11);
          (* X:=GX*32 + 32;
          Y:=GY*32;
          Direction:=1;
          if (Level*17 + GX*311 + GY*3787) mod 2=0 then
            Img:=Enemy1Img
          else
            Img:=Enemy2Img; *)
        end;
      end;
    if Level < 19 then
      for GX:=1 to 19-Level do Enemies.Remove(Enemies[Random(Enemies.Count)]);
  end;

begin
  PlayerX:=160 - 16;
  PlayerY:=206;
  if Reset then begin
    Life:=4;
    SetLevel(1);
    Score:=0;
  end;
  FreeAndNil(Enemies);
  FreeAndNil(Projectiles);
  Enemies:=TEnemyList.Create;
  Projectiles:=TProjectileList.Create;
  InitEnemies;
end;

procedure UpdateGame;

  procedure LaunchPoof(X, Y: Integer; Img: PSDL_Surface; Life: Integer);
  begin
    LaunchProjectile(X, Y, -1, -0.4, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, -0.2, -0.7, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, 0.3, -0.6, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, 0.96, -0.3, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, -0.8, 0.5, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, -0.3, 0.65, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, 0.34, 0.67, Img, False, False, Life+Random(10));
    LaunchProjectile(X, Y, 0.93, 0.31, Img, False, False, Life+Random(10));
  end;

  procedure MovePlayer(D: Integer);
  begin
    if (PlayerX + D < 0) or (PlayerX + D > 320-32) then Exit;
    PlayerX:=PlayerX + D;
  end;

  procedure MoveEnemies;
  var
    I, J: Integer;
    Collisions, CollisionsBetween: Boolean;
    Collider: PEnemy;
  begin
    for I:=0 to Enemies.Count - 1 do with Enemies[I] do begin
      Inc(X, Direction);
      ExtraMotion(PlayerX, PlayerY);
      (* filter splash *)
      OX:=OX + (TOX - OX)*0.9;
      OY:=OY + (TOY - OY)*0.9;
      TOX:=TOX*0.9;
      TOY:=TOY*0.9;
      if (Spaced.Life <> 0) and RectOverRect(X, Y, X + WX - 1, Y + WY - 1,
          PlayerX, PlayerY, PlayerX + 31, PlayerY + 31) then begin
        DeleteLater(Enemies[I]);
        LaunchPoof(X, Y, P2Img, 10);
        LaunchPoof((X + PlayerX) div 2, (Y + PlayerY) div 2, P2Img, 30);
        LaunchPoof(PlayerX + 13, PlayerY - 2, P1Img, 70);
        LaunchPoof(PlayerX + 17, PlayerY + 1, P1Img, 96);
        Spaced.Life:=0;
        RetryY:=-32;
      end;
    end;
    Collisions:=False;
    for I:=0 to Enemies.Count - 1 do with Enemies[I] do begin
      if (X <= 0) or (X >= 320-WX) then begin
        Collisions:=True;
        if X < 0 then X:=0;
        if X > 320-WX then X:=320-WX;
      end;   
      if Y < 0 then Inc(Y, 1);
      if Y > 240 then begin
        Y:=-WY;
        X:=Random(320-WX);
      end;
    end;
    repeat
      CollisionsBetween:=False;
      for I:=0 to Enemies.Count - 1 do with Enemies[I] do begin   
        if CollisionWithEnemy(X, Y, WX, WY, I, Collider) then begin
          CollisionsBetween:=True;
          BounceMotionLimited(Collider); (* Must exit if called many times!! *)
        end
      end;
    until not CollisionsBetween;
    if Collisions then
      for I:=0 to Enemies.Count - 1 do with Enemies[I] do
      begin
        Direction:=-Direction;
        Inc(Y, 1);
      end;
  end;

  procedure Splash(CX, CY: Integer); (* Enemy died splash hole *)
  const
    Radius = 100;
  var
    I: Integer;
    Len, TX, TY: Single;
  begin
    for I:=0 to Enemies.Count - 1 do with Enemies[I] do begin
      TX:=X - CX + (WX shl 2);
      TY:=Y - CY + (WY shl 2);
      Len:=Sqrt(Sqr(TX) + Sqr(TY));
      if Len=0 then TX:=0 else TX:=TX/Len * 10;
      if Len=0 then TY:=0 else TY:=TY/Len * 10;
      TOX:=TOX + Max(0, Radius - Len)/Radius * TX;
      TOY:=TOY + Max(0, Radius - Len)/Radius * TY;
    end;
  end;

  procedure MoveProjectiles;
  var
    I: Integer;
    Enemy: TEnemy;
  begin
    for I:=0 to Projectiles.Count - 1 do with Projectiles[I] do begin
      FX:=FX + DX;
      FY:=FY + DY;
      X:=Round(FX);
      Y:=Round(FY);
      if Life <> -1 then Dec(Life);
      if (X < -9) or (Y < -9) or (X > 320) or (Y > 230) or (Life=0) then begin
        if PHarm and (Y > 230) then begin
          LaunchProjectile(X, Y - 4, 0.3, -0.6, P1Img, False, False, 10+Random(10));
          LaunchProjectile(X, Y - 4, -0.5, -0.5, P1Img, False, False, 12+Random(10));
        end;
        DeleteLater(Projectiles[I]);
        Continue;
      end;
      if EHarm and CollisionWithEnemy(X, Y, 9, 9, -1, @Enemy) then begin
        DeleteLater(Projectiles[I]);
        DeleteLater(Enemy);
        with Enemy do
          LaunchPoof(X + (WX shl 1), Y + (WY shl 1), P1Img, 20);
          Splash(X + (WX shl 1), Y + (WY shl 1));
          Inc(Score, Y*ScoresByY+30);
        end;
        Continue;
      end;
      if PHarm and (Spaced.Life > 0) and RectOverRect(X, Y, X + 8, Y + 8,
          PlayerX + 4, PlayerY + 4, PlayerX + 28, PlayerY + 28) then begin
        DeleteLater(Projectiles[I]);
        HitTime:=4;
        LaunchPoof(X, Y, P2Img, 10);
        Dec(Spaced.Life);
        if Spaced.Life=0 then begin
          LaunchPoof((X + PlayerX) div 2, (Y + PlayerY) div 2, P2Img, 30);
          LaunchPoof(PlayerX + 13, PlayerY - 2, P1Img, 70);
          LaunchPoof(PlayerX + 17, PlayerY + 1, P1Img, 96);
          RetryY:=-32;
        end;
        Continue;
      end;
    end;
  end;

  procedure ShootPlayerBullet;
  begin
    if SDL_GetTicks - PlayerShootTime < (200 - Min(100, Max(0, Level*4))) then Exit;
    PlayerShootTime:=SDL_GetTicks;
    ShootTime:=4;
    LaunchProjectile(PlayerX + 11, PlayerY - 2, 0, -4, PBulletImg, False, True);
  end;

  procedure ShootEnemyBullet;
  var
    TX, TY, Len: Single;
  begin
    if Enemies.Count=0 then Exit;
    with Enemies[Random(Enemies.Count)] do begin
      if (Random(10000) > PercentFire*FireScale) or (Y > PlayerY) then Exit;
      TOY:=TOY-2;
      if StraightFire then begin
        TX:=0;
        TY:=2;
      end else begin
        TX:=PlayerX - X;
        TY:=PlayerY - Y;
        Len:=Sqrt(TX*TX + TY*TY);
        TX:=TX/Len;
        TY:=TY/Len;
      end;
      LaunchProjectile(X + (WX shr 2)- 4, Y + WY - 2, TX, TY, EBulletImg, True, False);
    end;
  end;

begin
  if Life > 0 then begin
    if Key(SDLK_LEFT) then MovePlayer(-4)
    else if Key(SDLK_RIGHT) then MovePlayer(4);
    if Key(SDLK_LCTRL) then ShootPlayerBullet;

    if Enemies.Count=0 then begin
      WaveScreen; (* wave end *)
      SDL_Delay(1000);
      Inc(Life);
      Inc(Score, 1000);
      SetLevel(Level + 1);
      NewGame(False);
    end;
  end else begin
    if RetryY < 100 then Inc(RetryY, 6);
    if Key(SDLK_Space) then begin (* better for the loop halt missing wait on over *)
      NewGame(True);
      SDL_Delay(500);
      Exit;
    end;
  end;
  MoveEnemies;
  MoveProjectiles;
  ShootEnemyBullet;
  if HitTime > 0 then Dec(HitTime);
  if ShootTime > 0 then Dec(ShootTime);
end;

procedure MainLoop;
var
  LastTime: Cardinal;

  procedure HandleEvents;
  var
    Ev: TSDL_Event;

    procedure HandleKey(Sym: Integer; Down: Boolean);
    begin
      if (Sym >= Low(KeyState)) and (Sym <= High(KeyState)) then KeyState[Sym]:=Down;
      case Sym of
        SDLK_ESCAPE: Running:=False;
      end;
    end;

  begin
    while SDL_PollEvent(@Ev) <> 0 do begin
      case Ev.Type_ of
        SDL_QUITEV: Running:=False;
        SDL_KEYDOWN: HandleKey(Ev.Key.KeySym.Sym, True);
        SDL_KEYUP: HandleKey(Ev.Key.KeySym.Sym, False);
      end;
    end;
  end;

begin
  LastTime:=SDL_GetTicks();
  while Running do begin
    CurrentTime:=SDL_GetTicks();
    (* stall processing *)
    if CurrentTime - LastTime > 1000 then LastTime:=CurrentTime - 60;
    while CurrentTime - LastTime > 50 do begin (* action frame *)
      UpdateGame;
      Inc(LastTime, 20); (* speed 20=>50 frames per second *)
    end;
    HandleEvents;
    DrawScreen;
    DeleteDeferredObjects;
  end;
end;

begin
  Randomize;
  SDL_Init(SDL_INIT_VIDEO);
  if not InitVideo then Exit;
  SDL_WM_SetCaption(PChar(GameName), PChar(GameName));
  LoadImages;
  TitleScreen;
  NewGame(True);
  MainLoop;
  SDL_Quit;
end.
