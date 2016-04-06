program ReusableObjectsTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestObj.ICurrency in 'TestObj.ICurrency.pas',
  TestObj.ITax in 'TestObj.ITax.pas',
  TestObj.IDiscount in 'TestObj.IDiscount.pas',
  Obj.SSI.Currency in '..\Obj.SSI.Currency.pas',
  Obj.SSI.Discount in '..\Obj.SSI.Discount.pas',
  Obj.SSI.Tax in '..\Obj.SSI.Tax.pas',
  Obj.SSI.IBase64 in '..\Obj.SSI.IBase64.pas',
  Obj.SSI.ICryptString in '..\Obj.SSI.ICryptString.pas',
  TestObj.SSI.IBase64 in 'TestObj.SSI.IBase64.pas',
  TestObj.SSI.ICryptString in 'TestObj.SSI.ICryptString.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

