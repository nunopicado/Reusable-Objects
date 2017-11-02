(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICryptString                                             **)
(** Framework     : JEDI JWA WinAPI                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICryptString                                             **)
(******************************************************************************)
(** Dependencies  : RTL, Jedi JWA WinAPI                                     **)
(******************************************************************************)
(** Description   : Handles Currency values and calculations                 **)
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

unit RO.ICryptString;

interface

uses
    RO.IValue
  ;

type
  ICryptString = interface(IInvokable)
  ['{98C9E3C7-230A-4718-9BB8-0E0B1B40BBE5}']
    function Crypt: AnsiString;
    function Decrypt: AnsiString;
  end;

  ICryptStringFactory = interface(IInvokable)
  ['{7700A319-F560-42CC-B10F-E703BB791E89}']
    function New(const Text: IValue<AnsiString>): ICryptString; overload;
    function New(const Text, Password: IValue<AnsiString>): ICryptString; overload;
  end;

implementation

end.
