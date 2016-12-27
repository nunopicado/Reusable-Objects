(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        :                                                          **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : I<T>                                                     **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Generic interface to be used by interfaced version of    **)
(**                 objects                                                  **)
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

unit Obj.SSI.GenericIntf;

interface

uses
    SysUtils;

type
    ESSIError = Class(Exception);

    I<T> = Interface                  ['{D6A7F28C-56D5-4D59-8C58-41489D9A3098}']
      function Obj: T;
    End;
	
implementation

end.