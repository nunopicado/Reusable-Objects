unit uTDateTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TFullDateTimeTest = class(TObject)
  public
    [Test]
    [TestCase('FullDateTimeAsString 1', '2018-01-02 12:10:15')]
    [TestCase('FullDateTimeAsString 2', '2018-01-02 12:23:48')]
    procedure FullDateTimeAsStringTest(const FullDate: string);
  end;

implementation

uses
    RO.TDate
  ;

{ TFullDateTimeTest }

procedure TFullDateTimeTest.FullDateTimeAsStringTest(const FullDate: string);
begin
  Assert.AreEqual<string>(
    FullDate,
    TFullDateTime.New(
      TDate.New(FullDate)
    ).AsString
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TFullDateTimeTest);
end.


