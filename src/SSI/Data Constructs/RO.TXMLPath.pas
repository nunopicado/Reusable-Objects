(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TXMLPath                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado, based on original code by Tor Helland       **)
(******************************************************************************)
(** Interfaces    : IXMLPath                                                 **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Allows XML node finding using XPath                      **)
(******************************************************************************)
(** Licence       : MPL v1.1 (https://www.mozilla.org/en-US/MPL/1.1/)        **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit RO.TXMLPath;

interface

uses
    RO.IXMLPath
  , XMLIntf
  ;

type
  TXMLPath = class(TInterfacedObject, IXMLPath)
  private
    FRoot: IXMLNode;
  public
    constructor Create(Root: IXMLNode);
    class function New(Root: IXMLNode): IXMLPath; overload;
    class function New(const XMLData: string): IXMLPath; overload;
    function SelectNode(const NodePath: WideString): IXMLNode;
    function SelectNodes(const NodePath: WideString): IXMLNodeList;
  end;

implementation

uses
    XMLDoc
  , XMLDom
  , SysUtils
  , RO.TIf
  ;

{ TXMLPath }

constructor TXMLPath.Create(Root: IXMLNode);
begin
  FRoot := Root;
end;

class function TXMLPath.New(Root: IXMLNode): IXMLPath;
begin
  Result := Create(Root);
end;

class function TXMLPath.New(const XMLData: string): IXMLPath;
begin
  Result := New(
    LoadXMLData(XMLData).DocumentElement
  );
end;

function TXMLPath.SelectNode(const NodePath: WideString): IXmlNode;
var
  intfSelect    : IDomNodeSelect;
  dnResult      : IDomNode;
  intfDocAccess : IXmlDocumentAccess;
begin
  Result := nil;
  if not Assigned(FRoot)
      or not Supports(FRoot.DOMNode, IDomNodeSelect, intfSelect)
    then Exit;

  dnResult := intfSelect.selectNode(nodePath);
  if Assigned(dnResult)
    then begin
      Result := TXMLNode.Create(
        dnResult,
        nil,
        TIf<TXMLDocument>.New(
          Supports(FRoot.OwnerDocument, IXmlDocumentAccess, intfDocAccess),
          intfDocAccess.DocumentObject,
          nil
        ).Eval
      );
    end;
end;

function TXMLPath.SelectNodes(const NodePath: WideString): IXMLNodeList;
resourcestring
  rcErrSelectNodesNoRoot = 'Called SelectNodes without specifying proper root.';
var
  intfSelect    : IDomNodeSelect;
  intfAccess    : IXmlNodeAccess;
  dnlResult     : IDomNodeList;
  intfDocAccess : IXmlDocumentAccess;
  i             : Integer;
begin
  // Always return a node list, even if empty.
  if not Assigned(FRoot)
      or not Supports(FRoot, IXmlNodeAccess, intfAccess)
      or not Supports(FRoot.DOMNode, IDomNodeSelect, intfSelect)
    then XmlDocError(rcErrSelectNodesNoRoot);

  // TXMLNodeList must have an owner (FRoot).
  Result := TXmlNodeList.Create(intfAccess.GetNodeObject, '', nil);

  dnlResult := intfSelect.selectNodes(nodePath);
  if Assigned(dnlResult)
    then
      with TIf<TXMLDocument>.New(
            Supports(FRoot.OwnerDocument, IXmlDocumentAccess, intfDocAccess),
            intfDocAccess.DocumentObject,
            nil
          ) do
        for i := 0 to Pred(dnlResult.length) do
          Result.Add(
            TXmlNode.Create(
              dnlResult.item[i],
              nil,
              Eval
            )
          );
end;

end.
