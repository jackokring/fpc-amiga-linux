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
    InsertEnterMenuItem: TMenuItem;
    ExecuteButton: TButton;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    EditMenu: TMenuItem;
    CutMenuItem: TMenuItem;
    CopyMenuItem: TMenuItem;
    ExportMenuItem: TMenuItem;
    InputText: TMemo;
    InsertReprintLineMenuItem: TMenuItem;
    InsertReprintPageMenuItem: TMenuItem;
    InsertColumnAlignMenuItem: TMenuItem;
    InsertBackspaceMenuItem: TMenuItem;
    ArchiveMenuItem: TMenuItem;
    MakeNoteMenuItem: TMenuItem;
    MarkMenuItem: TMenuItem;
    EscapeMenu: TMenuItem;
    TasksMenuItem: TMenuItem;
    ObserverMenuItem: TMenuItem;
    RefreshMenuItem: TMenuItem;
    QueryMenuItem: TMenuItem;
    NotifyMenuItem: TMenuItem;
    RecallMenuItem: TMenuItem;
    SignVerifyMenuItem: TMenuItem;
    ToolsMenu: TMenuItem;
    TrayMenuItem: TMenuItem;
    ViewMenu: TMenuItem;
    QuitMenuItem: TMenuItem;
    OutputText: TMemo;
    SelectAllMenuItem: TMenuItem;
    PasteMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    NewMenuItem: TMenuItem;
    procedure ArchiveMenuItemClick(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure CutMenuItemClick(Sender: TObject);
    procedure ExecuteActionItemExecute(Sender: TObject);
    procedure ExecuteButtonClick(Sender: TObject);
    procedure ExportMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InsertBackspaceMenuItemClick(Sender: TObject);
    procedure InsertEnterMenuItemClick(Sender: TObject);
    procedure InsertReprintLineMenuItemClick(Sender: TObject);
    procedure InsertReprintPageMenuItemClick(Sender: TObject);
    procedure InsertTabMenuItemClick(Sender: TObject);
    procedure InsertColumnAlignMenuItemClick(Sender: TObject);
    procedure MakeNoteMenuItemClick(Sender: TObject);
    procedure MarkMenuItemClick(Sender: TObject);
    procedure QueryMenuItemClick(Sender: TObject);
    procedure NotifyMenuItemClick(Sender: TObject);
    procedure OpenMenuItemClick(Sender: TObject);
    procedure NewMenuItemClick(Sender: TObject);
    procedure PasteMenuItemClick(Sender: TObject);
    procedure QuitMenuItemClick(Sender: TObject);
    procedure RecallMenuItemClick(Sender: TObject);
    procedure RedoActionItemExecute(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
    procedure SelectAllMenuItemClick(Sender: TObject);
    procedure SignVerifyMenuItemClick(Sender: TObject);
    procedure TaskMenuItemClick(Sender: TObject);
    procedure TasksMenuItemClick(Sender: TObject);
    procedure TrayMenuItemClick(Sender: TObject);
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

procedure TMainForm.InsertBackspaceMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.InsertEnterMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.InsertReprintLineMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.InsertReprintPageMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.InsertTabMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.InsertColumnAlignMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.MakeNoteMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.MarkMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.QueryMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.NotifyMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.CopyMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.ArchiveMenuItemClick(Sender: TObject);
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

procedure TMainForm.QuitMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.RecallMenuItemClick(Sender: TObject);
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

procedure TMainForm.SignVerifyMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.TaskMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.TasksMenuItemClick(Sender: TObject);
begin

end;

procedure TMainForm.TrayMenuItemClick(Sender: TObject);
begin

end;

end.

