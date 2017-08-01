(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : String                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Adds a record helper to the string type, to be used in   **)
(**                 versions where a native helper is not yet available      **)
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

unit Obj.SSI.Helpers;

interface

type
  TStringHelper = record Helper for string
    function ToInteger: Integer;
    function Length: Integer;
  end;

implementation

uses
    SysUtils
  ;

{ THString }

function TStringHelper.Length: Integer;
begin
  Result := System.Length(Self);
end;

function TStringHelper.ToInteger: Integer;
begin
  Result := StrToInt(Self);
end;

end.
