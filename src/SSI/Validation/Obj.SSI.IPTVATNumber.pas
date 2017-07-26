(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPTVATNumber                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPTVATNumber                                             **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Validates a string to be a valid Portuguese VAT Number   **)
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

unit Obj.SSI.IPTVATNumber;

interface

uses
    Obj.SSI.IValue
  ;

type
  IPTVATNumber = interface(IInvokable)
  ['{60BEF117-FF0B-4F36-A69E-A8CB147EF87C}']
    function IsValid: Boolean;
    function AsIString: IString;
    function AsIInteger: IInteger;
  end;

implementation

end.
