program ROSSITests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Obj.SSI.IBMReference in '..\src\SSI\Business\Obj.SSI.IBMReference.pas',
  Obj.SSI.TMBReference in '..\src\SSI\Business\Obj.SSI.TMBReference.pas',
  Obj.SSI.IValue in '..\src\SSI\Data Types\Obj.SSI.IValue.pas',
  Obj.SSI.TValue in '..\src\SSI\Data Types\Obj.SSI.TValue.pas',
  Obj.SSI.TString in '..\src\SSI\Data Types\Obj.SSI.TString.pas',
  Obj.SSI.IIf in '..\src\SSI\Flow Control\Obj.SSI.IIf.pas',
  Obj.SSI.TIf in '..\src\SSI\Flow Control\Obj.SSI.TIf.pas',
  uTMBReferenceTest in 'uTMBReferenceTest.pas',
  uTValueTest in 'uTValueTest.pas',
  uTStringTest in 'uTStringTest.pas',
  Obj.SSI.TPTVATNumber in '..\src\SSI\Validation\Obj.SSI.TPTVATNumber.pas',
  Obj.SSI.IPTVATNumber in '..\src\SSI\Validation\Obj.SSI.IPTVATNumber.pas',
  uPTVATNumberTest in 'uPTVATNumberTest.pas',
  Obj.SSI.Helpers in '..\src\SSI\Helpers\Obj.SSI.Helpers.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
