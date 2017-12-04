(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IByteSequence                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IByteSequence                                            **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring                                                   **)
(******************************************************************************)
(** Description   : Creates a list of bytes from a string or decimal sequence**)
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

unit RO.IByteSequence;

interface

uses
    Spring.Collections
  ;

type
  IByteSequence = interface
  ['{96AAB705-984B-420A-AAAE-186CC1F45633}']
    function AsEnumerable: IEnumerable<Byte>;
    function AsString: AnsiString;
  end;

implementation

end.
