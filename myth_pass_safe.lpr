program myth_pass_safe;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uniqueinstance_package, runtimetypeinfocontrols, mainUnit,
  functionsUnit, questionsUnit, editingUnit, addSiteUnit, deleteSiteUnit,
  changesiteUnit, addloginUnit, deleteLoginUnit, changeLoginUnit,
  appSettingsUnit;

{$R *.res}

begin
  Application.Title:='MythPassSafe 0.9';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TappSettingsForm, appSettingsForm);
  Application.CreateForm(TquestionsForm, questionsForm);
  Application.CreateForm(TeditingForm, editingForm);
  Application.CreateForm(TaddSiteForm, addSiteForm);
  Application.CreateForm(TchangeSiteForm, changeSiteForm);
  Application.CreateForm(TdeleteSiteForm, deleteSiteForm);
  Application.CreateForm(TaddLoginForm, addLoginForm);
  Application.CreateForm(TchangeLoginForm, changeLoginForm);
  Application.CreateForm(TdeleteLoginForm, deleteLoginForm);
  Application.Run;
end.

