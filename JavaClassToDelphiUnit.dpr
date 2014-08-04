program JavaClassToDelphiUnit;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frm_Main},
  JavaClassFile in 'JavaClassFile.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown  := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Main, frm_Main);
  Application.Run;
end.
