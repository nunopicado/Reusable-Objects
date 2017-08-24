(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IRSASignature                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IRSASignature                                            **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Signs a string with RSA protocol                         **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit Obj.SSI.IRSASignature;

interface

type
  TPubKeySource = (pksFile, pksString);

  IRSASignature = interface
  ['{39ABD6BE-F243-48AC-9793-A2599F9C9307}']
    function AsString: string;
  end;

implementation

end.
