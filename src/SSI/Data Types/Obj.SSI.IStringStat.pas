(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IStringStat                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IStringStat                                              **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : An object that returns some stats and functionality for  **)
(**                 strings                                                  **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**                 terms                                                    **)
(******************************************************************************)

unit Obj.SSI.IStringStat;

interface

type
  TCharSet = set of Char;

  IStringStat = interface(IInvokable)
  ['{31A932DC-C98B-4C9F-B608-111EA84C7BAA}']
    function OccurrenciesOf(const Ch: Char): Word;
    function ciPos(const SubStr: string): Word;
    function Compare(const OtherString: string): Byte;
    function AdvSearch(SearchTerms: string): Boolean;
    function ContainsOnly(const CharList: TCharSet): Boolean;
  end;

implementation

end.
