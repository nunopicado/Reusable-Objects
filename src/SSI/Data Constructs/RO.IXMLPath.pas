(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IXMLPath                                                 **)
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

unit RO.IXMLPath;

interface

uses
    XMLIntf
  ;

type
  IXMLPath = interface
  ['{22B6E31E-869C-478A-9325-E6365EFC6B53}']
    function SelectNode(const NodePath: WideString): IXMLNode;
    function SelectNodes(const NodePath: WideString): IXMLNodeList;
  end;

implementation

end.
