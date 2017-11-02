unit uTDataStreamTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TDataStreamTest = class(TObject) 
  public
    [Test]
    [TestCase('FromStringAsString 1','ABCD')]
    [TestCase('FromStringAsString 2','1234')]
    procedure FromStringAsStringTest(const AString: string);
    [Test]
    [TestCase('FromStreamAsString 1','ABCD')]
    [TestCase('FromStreamAsString 2','1234')]
    procedure FromStreamAsStringTest(const AString: string);
    [Test]
    [TestCase('FromIStringAsString 1','ABCD')]
    [TestCase('FromIStringAsString 2','1234')]
    procedure FromIStringAsStringTest(const AString: string);
    [Test]
    [TestCase('FromStringsAsString 1','ABCD')]
    [TestCase('FromStringsAsString 2','1234')]
    procedure FromStringsAsStringTest(const AString: string);
    [Test]
    procedure FromNothingAsStringTest;
    [Test]
    [TestCase('FromStringAsStream 1','ABCD')]
    [TestCase('FromStringAsStream 2','1234')]
    procedure FromStringAsStreamTest(const AString: string);
    [Test]
    [TestCase('FromStringAsStrings 1','ABCD')]
    [TestCase('FromStringAsStrings 2','1234')]
    procedure FromStringAsStringsTest(const AString: string);
    [Test]
    [TestCase('SizeTest 1','ABCD')]
    [TestCase('SizeTest 2','')]
    procedure SizeTest(const AString: string);
  end;

implementation

uses
    RO.TDataStream
  , RO.TValue
  , Classes
  ;

{ TDataStreamTest }

procedure TDataStreamTest.FromIStringAsStringTest(const AString: string);
begin
  Assert.AreEqual<string>(
    AString,
    TDataStream.New(
      TString.New(AString)
    ).AsString
  );
end;

procedure TDataStreamTest.FromNothingAsStringTest;
begin
  Assert.AreEqual<string>(
    '',
    TDataStream.New.AsString
  );
end;

procedure TDataStreamTest.FromStreamAsStringTest(const AString: string);
var
  SS: TStringStream;
begin
  SS := TStringStream.Create(AString);
  try
    Assert.AreEqual<string>(
      AString,
      TDataStream.New(SS).AsString
    );
  finally
    SS.Free;
  end;
end;

procedure TDataStreamTest.FromStringAsStreamTest(const AString: string);
var
  SS: TStringStream;
begin
  SS := TStringStream.Create;
  try
    TDataStream.New(AString).Save(SS);
    Assert.AreEqual<string>(
      AString,
      SS.DataString
    );
  finally
    SS.Free;
  end;
end;

procedure TDataStreamTest.FromStringAsStringsTest(const AString: string);
var
  Lst: TStringList;
begin
  Lst := TStringList.Create;
  try
    TDataStream.New(AString).Save(Lst);
    Assert.AreEqual<string>(
      AString + sLineBreak,
      Lst.Text
    );
  finally
    Lst.Free;
  end;
end;

procedure TDataStreamTest.FromStringAsStringTest(const AString: string);
begin
  Assert.AreEqual<string>(
    AString,
    TDataStream.New(AString).AsString
  );
end;

procedure TDataStreamTest.FromStringsAsStringTest(const AString: string);
var
  Lst: TStringList;
begin
  Lst := TStringList.Create;
  try
    Lst.Text := AString;
    Assert.AreEqual<string>(
      AString + sLineBreak,
      TDataStream.New(Lst).AsString
    );
  finally
    Lst.Free;
  end;
end;

procedure TDataStreamTest.SizeTest(const AString: string);
begin
  Assert.AreEqual<Int64>(
    Length(AString),
    TDataStream.New(AString).Size
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TDataStreamTest);
end.
