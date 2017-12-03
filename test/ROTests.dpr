program ROTests;

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
  uTMBReferenceTest in 'uTMBReferenceTest.pas',
  uTValueTest in 'uTValueTest.pas',
  uTStringTest in 'uTStringTest.pas',
  uPTVATNumberTest in 'uPTVATNumberTest.pas',
  uTIfTest in 'uTIfTest.pas',
  uTDataStreamTest in 'uTDataStreamTest.pas',
  uTZipStringTest in 'uTZipStringTest.pas',
  uTAES128Test in 'uTAES128Test.pas',
  uTBase64Test in 'uTBase64Test.pas',
  uTCryptStringTest in 'uTCryptStringTest.pas',
  uTRandomKeyTest in 'uTRandomKeyTest.pas',
  TZDB,
  uTEmailAddressTest in 'uTEmailAddressTest.pas',
  uTGeoCoordinateTest in 'uTGeoCoordinateTest.pas',
  uPTPostalCodeTest in 'uPTPostalCodeTest.pas',
  libeay32,
  uTXPathTest in 'uTXPathTest.pas',
  RO.TMBReference in '..\src\SSI\RO.TMBReference.pas',
  RO.IMBReference in '..\src\Intf\RO.IMBReference.pas',
  RO.IValue in '..\src\Intf\RO.IValue.pas',
  RO.TValue in '..\src\SSI\RO.TValue.pas',
  RO.ICurrency in '..\src\Intf\RO.ICurrency.pas',
  RO.TCurrency in '..\src\SSI\RO.TCurrency.pas',
  RO.TString in '..\src\SSI\RO.TString.pas',
  RO.TIf in '..\src\SSI\RO.TIf.pas',
  RO.IIf in '..\src\Intf\RO.IIf.pas',
  RO.IPTVATNumber in '..\src\Intf\RO.IPTVATNumber.pas',
  RO.TPTVATNumber in '..\src\SSI\RO.TPTVATNumber.pas',
  RO.TDataStream in '..\src\SSI\RO.TDataStream.pas',
  RO.IDataStream in '..\src\Intf\RO.IDataStream.pas',
  RO.TZipString in '..\src\SSI\RO.TZipString.pas',
  RO.TAES128 in '..\src\SSI\RO.TAES128.pas',
  RO.TBase64 in '..\src\SSI\RO.TBase64.pas',
  RO.ICryptString in '..\src\Intf\RO.ICryptString.pas',
  RO.TCryptString in '..\src\SSI\RO.TCryptString.pas',
  RO.IRandomKey in '..\src\Intf\RO.IRandomKey.pas',
  RO.TRandomKey in '..\src\SSI\RO.TRandomKey.pas',
  RO.IEmailAddress in '..\src\Intf\RO.IEmailAddress.pas',
  RO.TEmailAddress in '..\src\SSI\RO.TEmailAddress.pas',
  RO.IStringStat in '..\src\Intf\RO.IStringStat.pas',
  RO.TStringStat in '..\src\SSI\RO.TStringStat.pas',
  RO.IGeoCoordinate in '..\src\Intf\RO.IGeoCoordinate.pas',
  RO.TGeoCoordinate in '..\src\SSI\RO.TGeoCoordinate.pas',
  RO.IPostalCode in '..\src\Intf\RO.IPostalCode.pas',
  RO.TPTPostalCode in '..\src\SSI\RO.TPTPostalCode.pas',
  RO.IXPath in '..\src\Intf\RO.IXPath.pas',
  RO.TXPath in '..\src\SSI\RO.TXPath.pas';

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
