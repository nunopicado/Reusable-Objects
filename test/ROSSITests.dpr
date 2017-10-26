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
  uTMBReferenceTest in 'uTMBReferenceTest.pas',
  uTValueTest in 'uTValueTest.pas',
  uTStringTest in 'uTStringTest.pas',
  uPTVATNumberTest in 'uPTVATNumberTest.pas',
  Obj.SSI.Helpers in '..\src\SSI\Helpers\Obj.SSI.Helpers.pas',
  uTIfTest in 'uTIfTest.pas',
  Obj.SSI.ICertificate in '..\src\SSI\Communication\Obj.SSI.ICertificate.pas',
  Obj.SSI.IMail in '..\src\SSI\Communication\Obj.SSI.IMail.pas',
  Obj.SSI.INetworkNode in '..\src\SSI\Communication\Obj.SSI.INetworkNode.pas',
  Obj.SSI.ISNTPTime in '..\src\SSI\Communication\Obj.SSI.ISNTPTime.pas',
  Obj.SSI.ISoapRequest in '..\src\SSI\Communication\Obj.SSI.ISoapRequest.pas',
  Obj.SSI.IURL in '..\src\SSI\Communication\Obj.SSI.IURL.pas',
  Obj.SSI.TCertificate in '..\src\SSI\Communication\Obj.SSI.TCertificate.pas',
  Obj.SSI.TMail in '..\src\SSI\Communication\Obj.SSI.TMail.pas',
  Obj.SSI.TNetworkNode in '..\src\SSI\Communication\Obj.SSI.TNetworkNode.pas',
  Obj.SSI.TSNTPTime in '..\src\SSI\Communication\Obj.SSI.TSNTPTime.pas',
  Obj.SSI.TSoapRequest in '..\src\SSI\Communication\Obj.SSI.TSoapRequest.pas',
  Obj.SSI.TURL in '..\src\SSI\Communication\Obj.SSI.TURL.pas',
  Obj.SSI.IDataStream in '..\src\SSI\Data Constructs\Obj.SSI.IDataStream.pas',
  Obj.SSI.IFile in '..\src\SSI\Data Constructs\Obj.SSI.IFile.pas',
  Obj.SSI.IMatrix in '..\src\SSI\Data Constructs\Obj.SSI.IMatrix.pas',
  Obj.SSI.IRange in '..\src\SSI\Data Constructs\Obj.SSI.IRange.pas',
  Obj.SSI.TDataStream in '..\src\SSI\Data Constructs\Obj.SSI.TDataStream.pas',
  Obj.SSI.TFile in '..\src\SSI\Data Constructs\Obj.SSI.TFile.pas',
  Obj.SSI.TMatrix in '..\src\SSI\Data Constructs\Obj.SSI.TMatrix.pas',
  Obj.SSI.TRange in '..\src\SSI\Data Constructs\Obj.SSI.TRange.pas',
  Obj.SSI.ICurrency in '..\src\SSI\Data Types\Obj.SSI.ICurrency.pas',
  Obj.SSI.IDate in '..\src\SSI\Data Types\Obj.SSI.IDate.pas',
  Obj.SSI.IEnum in '..\src\SSI\Data Types\Obj.SSI.IEnum.pas',
  Obj.SSI.IFactory in '..\src\SSI\Data Types\Obj.SSI.IFactory.pas',
  Obj.SSI.IStringStat in '..\src\SSI\Data Types\Obj.SSI.IStringStat.pas',
  Obj.SSI.IValue in '..\src\SSI\Data Types\Obj.SSI.IValue.pas',
  Obj.SSI.TCurrency in '..\src\SSI\Data Types\Obj.SSI.TCurrency.pas',
  Obj.SSI.TDate in '..\src\SSI\Data Types\Obj.SSI.TDate.pas',
  Obj.SSI.TEnum in '..\src\SSI\Data Types\Obj.SSI.TEnum.pas',
  Obj.SSI.TFactory in '..\src\SSI\Data Types\Obj.SSI.TFactory.pas',
  Obj.SSI.TString in '..\src\SSI\Data Types\Obj.SSI.TString.pas',
  Obj.SSI.TStringStat in '..\src\SSI\Data Types\Obj.SSI.TStringStat.pas',
  Obj.SSI.TValue in '..\src\SSI\Data Types\Obj.SSI.TValue.pas',
  Obj.SSI.TZipString in '..\src\SSI\Data Types\Obj.SSI.TZipString.pas',
  Obj.SSI.IAES128 in '..\src\SSI\Encryption\Obj.SSI.IAES128.pas',
  Obj.SSI.IBase64 in '..\src\SSI\Encryption\Obj.SSI.IBase64.pas',
  Obj.SSI.ICryptString in '..\src\SSI\Encryption\Obj.SSI.ICryptString.pas',
  Obj.SSI.IRandomKey in '..\src\SSI\Encryption\Obj.SSI.IRandomKey.pas',
  Obj.SSI.IRSASignature in '..\src\SSI\Encryption\Obj.SSI.IRSASignature.pas',
  Obj.SSI.TAES128 in '..\src\SSI\Encryption\Obj.SSI.TAES128.pas',
  Obj.SSI.TBase64 in '..\src\SSI\Encryption\Obj.SSI.TBase64.pas',
  Obj.SSI.TCryptString in '..\src\SSI\Encryption\Obj.SSI.TCryptString.pas',
  Obj.SSI.TRandomKey in '..\src\SSI\Encryption\Obj.SSI.TRandomKey.pas',
  Obj.SSI.TRSASignature in '..\src\SSI\Encryption\Obj.SSI.TRSASignature.pas',
  Obj.SSI.IConstraints in '..\src\SSI\Flow Control\Obj.SSI.IConstraints.pas',
  Obj.SSI.IIf in '..\src\SSI\Flow Control\Obj.SSI.IIf.pas',
  Obj.SSI.TConstraints in '..\src\SSI\Flow Control\Obj.SSI.TConstraints.pas',
  Obj.SSI.TIf in '..\src\SSI\Flow Control\Obj.SSI.TIf.pas',
  Obj.SSI.Using in '..\src\SSI\Flow Control\Obj.SSI.Using.pas',
  Obj.SSI.IEmailAddress in '..\src\SSI\Validation\Obj.SSI.IEmailAddress.pas',
  Obj.SSI.IGeoCoordinate in '..\src\SSI\Validation\Obj.SSI.IGeoCoordinate.pas',
  Obj.SSI.IPostalAddress in '..\src\SSI\Validation\Obj.SSI.IPostalAddress.pas',
  Obj.SSI.IPostalCode in '..\src\SSI\Validation\Obj.SSI.IPostalCode.pas',
  Obj.SSI.IPTVATNumber in '..\src\SSI\Validation\Obj.SSI.IPTVATNumber.pas',
  Obj.SSI.TEmailAddress in '..\src\SSI\Validation\Obj.SSI.TEmailAddress.pas',
  Obj.SSI.TGeoCoordinate in '..\src\SSI\Validation\Obj.SSI.TGeoCoordinate.pas',
  Obj.SSI.TPostalAddress in '..\src\SSI\Validation\Obj.SSI.TPostalAddress.pas',
  Obj.SSI.TPostalAddressOnline in '..\src\SSI\Validation\Obj.SSI.TPostalAddressOnline.pas',
  Obj.SSI.TPTPostalCode in '..\src\SSI\Validation\Obj.SSI.TPTPostalCode.pas',
  Obj.SSI.TPTVATNumber in '..\src\SSI\Validation\Obj.SSI.TPTVATNumber.pas',
  LibEay.Ext in '..\src\SSI\Helpers\LibEay.Ext.pas',
  libeay32 in '..\src\ThirdParty\OpenSSL\libeay32.pas',
  TZDB in '..\src\ThirdParty\TZDB\TZDB.pas',
  Obj.SSI.IZDate in '..\src\SSI\Communication\Obj.SSI.IZDate.pas',
  Obj.SSI.TZDate in '..\src\SSI\Communication\Obj.SSI.TZDate.pas',
  uTDataStreamTest in 'uTDataStreamTest.pas',
  uTZipStringTest in 'uTZipStringTest.pas';

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
