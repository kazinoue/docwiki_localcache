program docwikiproxy_vcl;

uses
  Vcl.Forms,
  uDocwikiProxy_VCL in 'uDocwikiProxy_VCL.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
