(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMatrix                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMatrix                                                  **)
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
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Generic Bidimensional List of items                      **)
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

unit RO.IMatrix;

interface

type
  IMatrix<T> = interface(IInvokable)
  ['{3769B3FE-376D-4430-9652-48E6BF85A9CA}']
    function Cell(const Col, Row: LongInt): T;
    function Edit(const Col, Row: LongInt; const Value: T): IMatrix<T>;
    function ColCount: Integer;
    function RowCount: Integer;
    function Resize(const ColCount, RowCount: LongInt): IMatrix<T>;
  end;

implementation

end.
