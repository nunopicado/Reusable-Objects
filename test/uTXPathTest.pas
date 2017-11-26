unit uTXPathTest;

interface

uses
  DUnitX.TestFramework;

const
  XML =
    '   <bookstore> ' +
    '     <book> ' +
    '       <title lang="eng">Harry Potter</title> ' +
    '     </book> ' +
    '     <book> ' +
    '       <title lang="eng">Learning XML</title> ' +
    '       <title lang="por">Aprendendo XML</title> ' +
    '     </book> ' +
    '     <book> ' +
    '       <title lang="slo">Z OmniXML v lepso prihodnost</title> ' +
    '       <year>2006</year> ' +
    '     </book> ' +
    '     <book> ' +
    '       <title>Kwe sona standwa sam</title> ' +
    '     </book> ' +
    '   </bookstore>';

type
  [TestFixture]
  TXPathTest = class(TObject)
  public
    [Test]
    [TestCase('XPath SelectNode 1','/bookstore/book[2]/title[1],Learning XML')]
    [TestCase('XPath SelectNode 2','/bookstore/book[3]/year,2006')]
    procedure SelectNodeTest(const NodePath, Expected: string);
    [Test]
    [TestCase('XPath SelectNode Attr 1','/bookstore/book[2]/title[1],lang,eng')]
    [TestCase('XPath SelectNode Attr 2','/bookstore/book[2]/title[2],lang,por')]
    procedure SelectNodeAttrTest(const NodePath, Attr, Expected: string);
    [Test]
    [TestCase('XPath SelectNodes 1','/bookstore,1')]
    [TestCase('XPath SelectNodes 2','/bookstore/book,4')]
    [TestCase('XPath SelectNodes 2','/bookstore/book[2]/title,2')]
    procedure SelectNodesTest(const NodePath: string; const Count: Integer);
  end;

implementation

uses
    RO.TXPath
  ;

{ TXPathTest }

procedure TXPathTest.SelectNodeAttrTest(const NodePath, Attr, Expected: string);
begin
  Assert.AreEqual<string>(
    Expected,
    TXPath.New(XML)
      .SelectNode(NodePath)
        .Attributes[Attr]
  );
end;

procedure TXPathTest.SelectNodesTest(const NodePath: string; const Count: Integer);
begin
  Assert.AreEqual<Integer>(
    Count,
    TXPath.New(XML)
      .SelectNodes(NodePath)
        .Count
  );
end;

procedure TXPathTest.SelectNodeTest(const NodePath, Expected: string);
begin
  Assert.AreEqual<string>(
    Expected,
    TXPath.New(XML)
      .SelectNode(NodePath)
        .Text
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TXPathTest);
end.
