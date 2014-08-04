unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  Tfrm_Main = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    pnl1: TPanel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Main: Tfrm_Main;

implementation

{$R *.dfm}

uses
  JavaClassFile;


procedure Tfrm_Main.btn1Click(Sender: TObject);
var
  LJavaClass: TJavaClassFile;
begin
  LJavaClass := TJavaClassFile.Create;
  try
    mmo1.lines.text := LJavaClass.Convert(ExtractFilePath(ParamStr(0)) + 'ViewGroup.class');//'Toast.class');
  finally
    LJavaClass.Free;
  end;
end;

end.
