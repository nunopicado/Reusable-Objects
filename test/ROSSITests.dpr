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
  RO.IBMReference in '..\src\SSI\Business\RO.IBMReference.pas',
  RO.TMBReference in '..\src\SSI\Business\RO.TMBReference.pas',
  uTMBReferenceTest in 'uTMBReferenceTest.pas',
  uTValueTest in 'uTValueTest.pas',
  uTStringTest in 'uTStringTest.pas',
  uPTVATNumberTest in 'uPTVATNumberTest.pas',
  RO.Helpers in '..\src\SSI\Helpers\RO.Helpers.pas',
  uTIfTest in 'uTIfTest.pas',
  RO.ICertificate in '..\src\SSI\Communication\RO.ICertificate.pas',
  RO.IMail in '..\src\SSI\Communication\RO.IMail.pas',
  RO.INetworkNode in '..\src\SSI\Communication\RO.INetworkNode.pas',
  RO.ISNTPTime in '..\src\SSI\Communication\RO.ISNTPTime.pas',
  RO.ISoapRequest in '..\src\SSI\Communication\RO.ISoapRequest.pas',
  RO.IURL in '..\src\SSI\Communication\RO.IURL.pas',
  RO.TCertificate in '..\src\SSI\Communication\RO.TCertificate.pas',
  RO.TMail in '..\src\SSI\Communication\RO.TMail.pas',
  RO.TNetworkNode in '..\src\SSI\Communication\RO.TNetworkNode.pas',
  RO.TSNTPTime in '..\src\SSI\Communication\RO.TSNTPTime.pas',
  RO.TSoapRequest in '..\src\SSI\Communication\RO.TSoapRequest.pas',
  RO.TURL in '..\src\SSI\Communication\RO.TURL.pas',
  RO.IDataStream in '..\src\SSI\Data Constructs\RO.IDataStream.pas',
  RO.IFile in '..\src\SSI\Data Constructs\RO.IFile.pas',
  RO.IMatrix in '..\src\SSI\Data Constructs\RO.IMatrix.pas',
  RO.IRange in '..\src\SSI\Data Constructs\RO.IRange.pas',
  RO.TDataStream in '..\src\SSI\Data Constructs\RO.TDataStream.pas',
  RO.TFile in '..\src\SSI\Data Constructs\RO.TFile.pas',
  RO.TMatrix in '..\src\SSI\Data Constructs\RO.TMatrix.pas',
  RO.TRange in '..\src\SSI\Data Constructs\RO.TRange.pas',
  RO.ICurrency in '..\src\SSI\Data Types\RO.ICurrency.pas',
  RO.IDate in '..\src\SSI\Data Types\RO.IDate.pas',
  RO.IEnum in '..\src\SSI\Data Types\RO.IEnum.pas',
  RO.IFactory in '..\src\SSI\Data Types\RO.IFactory.pas',
  RO.IStringStat in '..\src\SSI\Data Types\RO.IStringStat.pas',
  RO.IValue in '..\src\SSI\Data Types\RO.IValue.pas',
  RO.TCurrency in '..\src\SSI\Data Types\RO.TCurrency.pas',
  RO.TDate in '..\src\SSI\Data Types\RO.TDate.pas',
  RO.TEnum in '..\src\SSI\Data Types\RO.TEnum.pas',
  RO.TFactory in '..\src\SSI\Data Types\RO.TFactory.pas',
  RO.TString in '..\src\SSI\Data Types\RO.TString.pas',
  RO.TStringStat in '..\src\SSI\Data Types\RO.TStringStat.pas',
  RO.TValue in '..\src\SSI\Data Types\RO.TValue.pas',
  RO.TZipString in '..\src\SSI\Data Types\RO.TZipString.pas',
  RO.ICryptString in '..\src\SSI\Encryption\RO.ICryptString.pas',
  RO.IRandomKey in '..\src\SSI\Encryption\RO.IRandomKey.pas',
  RO.IRSASignature in '..\src\SSI\Encryption\RO.IRSASignature.pas',
  RO.TAES128 in '..\src\SSI\Encryption\RO.TAES128.pas',
  RO.TBase64 in '..\src\SSI\Encryption\RO.TBase64.pas',
  RO.TCryptString in '..\src\SSI\Encryption\RO.TCryptString.pas',
  RO.TRandomKey in '..\src\SSI\Encryption\RO.TRandomKey.pas',
  RO.TRSASignature in '..\src\SSI\Encryption\RO.TRSASignature.pas',
  RO.IConstraints in '..\src\SSI\Flow Control\RO.IConstraints.pas',
  RO.IIf in '..\src\SSI\Flow Control\RO.IIf.pas',
  RO.TConstraints in '..\src\SSI\Flow Control\RO.TConstraints.pas',
  RO.TIf in '..\src\SSI\Flow Control\RO.TIf.pas',
  RO.Using in '..\src\SSI\Flow Control\RO.Using.pas',
  RO.IEmailAddress in '..\src\SSI\Validation\RO.IEmailAddress.pas',
  RO.IGeoCoordinate in '..\src\SSI\Validation\RO.IGeoCoordinate.pas',
  RO.IPostalAddress in '..\src\SSI\Validation\RO.IPostalAddress.pas',
  RO.IPostalCode in '..\src\SSI\Validation\RO.IPostalCode.pas',
  RO.IPTVATNumber in '..\src\SSI\Validation\RO.IPTVATNumber.pas',
  RO.TEmailAddress in '..\src\SSI\Validation\RO.TEmailAddress.pas',
  RO.TGeoCoordinate in '..\src\SSI\Validation\RO.TGeoCoordinate.pas',
  RO.TPostalAddress in '..\src\SSI\Validation\RO.TPostalAddress.pas',
  RO.TPostalAddressOnline in '..\src\SSI\Validation\RO.TPostalAddressOnline.pas',
  RO.TPTPostalCode in '..\src\SSI\Validation\RO.TPTPostalCode.pas',
  RO.TPTVATNumber in '..\src\SSI\Validation\RO.TPTVATNumber.pas',
  LibEay.Ext in '..\src\SSI\Helpers\LibEay.Ext.pas',
  libeay32 in '..\src\ThirdParty\OpenSSL\libeay32.pas',
  RO.IZDate in '..\src\SSI\Communication\RO.IZDate.pas',
  RO.TZDate in '..\src\SSI\Communication\RO.TZDate.pas',
  uTDataStreamTest in 'uTDataStreamTest.pas',
  uTZipStringTest in 'uTZipStringTest.pas',
  uTAES128Test in 'uTAES128Test.pas',
  uTBase64Test in 'uTBase64Test.pas',
  uTCryptStringTest in 'uTCryptStringTest.pas',
  uTRandomKeyTest in 'uTRandomKeyTest.pas',
  TZDB in '..\src\ThirdParty\tzdb\src\TZDBPK\TZDB.pas',
  uTEmailAddressTest in 'uTEmailAddressTest.pas',
  uTGeoCoordinateTest in 'uTGeoCoordinateTest.pas',
  uPTPostalCodeTest in 'uPTPostalCodeTest.pas';

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
