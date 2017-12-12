(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TSafeNodeText                                            **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : MSXML                                                    **)
(******************************************************************************)
(** Description   : Returns a XML Node Text, or a default value if Node is   **)
(**                 not valid                                                **)
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

unit RO.TSafeNodeText;

interface

uses
    RO.IValue
  , XmlIntf
  ;

type
  TSafeNodeText = class(TInterfacedObject, IString)
  private
    FNodeText: IString;
  public
    constructor Create(const Node: IXMLNode; const DefaultText: string = '');
    class function New(const Node: IXMLNode; const DefaultText: string = ''): IString;
    function Value: string;
    function Refresh: IString;
  end;

implementation

uses
    RO.TValue
  ;

{ TNodeText }

constructor TSafeNodeText.Create(const Node: IXMLNode; const DefaultText: string = '');
begin
  FNodeText := TString.New(
    function : string
    begin
      if Assigned(Node)
        then Result := Node.Text
        else Result := DefaultText;
    end
  );
end;

class function TSafeNodeText.New(const Node: IXMLNode; const DefaultText: string = ''): IString;
begin
  Result := Create(Node, DefaultText);
end;

function TSafeNodeText.Refresh: IString;
begin
  Result := Self;
  FNodeText.Refresh;
end;

function TSafeNodeText.Value: string;
begin
  Result := FNodeText.Value;
end;

end.
