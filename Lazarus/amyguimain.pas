unit AMyGUIMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ActnList;

type

  { TMainForm }

  TMainForm = class(TForm)
    InsertTabMenuItem: TMenuItem;
    RedoActionItem: TAction;
    RedoButton: TButton;
    ExecuteActionItem: TAction;
    ActionList: TActionList;
    ExecuteButton: TButton;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    EditMenu: TMenuItem;
    CutMenuItem: TMenuItem;
    CopyMenuItem: TMenuItem;
    ExportMenuItem: TMenuItem;
    InputText: TMemo;
    OutputText: TMemo;
    SelectAllMenuItem: TMenuItem;
    PasteMenuItem: TMenuItem;
    ViewMenu: TMenuItem;
    OpenMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    NewMenuItem: TMenuItem;
    procedure CopyMenuItemClick(Sender: TObject);
    procedure CutMenuItemClick(Sender: TObject);
    procedure ExecuteActionItemExecute(Sender: TObject);
    procedure ExecuteButtonClick(Sender: TObject);
    procedure ExportMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InsertTabMenuItemClick(Sender: TObject);
    procedure OpenMenuItemClick(Sender: TObject);
    procedure NewMenuItemClick(Sender: TObject);
    procedure PasteMenuItemClick(Sender: TObject);
    procedure RedoActionItemExecute(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
    procedure SelectAllMenuItemClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin

end;

procedure TMainForm.InsertTabMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.CopyMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.CutMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.ExecuteActionItemExecute(Sender: TObject);
begin

end;

procedure TMainForm.ExecuteButtonClick(Sender: TObject);
begin

end;

procedure TMainForm.ExportMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.OpenMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.NewMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.PasteMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.RedoActionItemExecute(Sender: TObject);
begin

end;

procedure TMainForm.SaveMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.SelectAllMenuItemClick(Sender: TObject);
begin

end;

end.

