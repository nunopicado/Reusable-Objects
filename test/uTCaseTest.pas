unit uTCaseTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCaseTest = class(TObject)
  public
    [Test]
    [TestCase('Case String 1', 'AAA,AAA,BBB,CCC,1')]
    [TestCase('Case String 2', 'BBB,AAA,BBB,CCC,2')]
    [TestCase('Case String 3', 'CCC,AAA,BBB,CCC,3')]
    procedure TestCaseString(const ARefValue, Action1, Action2, Action3: string; const ReturnValue: Integer);
    [Test]
    [TestCase('Else String 1', 'ELSE,AAA,0')]
    procedure TestElseString(const ARefValue, Action: string; const ElseValue: Integer);
    [Test]
    procedure TestDuplicate;
  end;

implementation

uses
    RO.TCase
  ;

procedure TCaseTest.TestCaseString(const ARefValue, Action1, Action2, Action3: string; const ReturnValue: Integer);
var
  RValue: Integer;
begin
  TCase<string>
    .New(ARefValue)
    .AddCase(
      Action1,
      procedure (Value: string)
      begin
        RValue := ReturnValue;
      end
    )
    .AddCase(
      Action2,
      procedure (Value: string)
      begin
        RValue := ReturnValue;
      end
    )
    .AddCase(
      Action3,
      procedure (Value: string)
      begin
        RValue := ReturnValue;
      end
    )
    .Perform;
  Assert.AreEqual<Integer>(
    ReturnValue,
    RValue
  );
end;

procedure TCaseTest.TestDuplicate;
begin
  Assert.WillRaise(
    procedure
    begin
      TCase<string>
        .New('Ref')
        .AddCase(
          'V1',
          procedure (Value: string)
          begin
          end
        )
        .AddCase(
          'V1',
          procedure (Value: string)
          begin

          end
        )
    end
  );
end;

procedure TCaseTest.TestElseString(const ARefValue, Action: string; const ElseValue: Integer);
var
  RValue: Integer;
begin
  TCase<string>
    .New(ARefValue)
    .AddCase(
      Action,
      procedure (Value: string)
      begin
      end
    )
    .AddElse(
      procedure (Value: string)
      begin
        RValue := ElseValue;
      end
    )
    .Perform;
  Assert.AreEqual<Integer>(
    ElseValue,
    RValue
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TCaseTest);
end.
