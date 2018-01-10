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
(** Classes       : TLibrary                                                 **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : An IString implementation that returns the name of the   **)
(**                 DLL module currently running                             **)
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

unit RO.TLibrary;

interface

uses
    RO.IValue
  ;

type
  TLibrary = class(TInterfacedObject, IString)
  private
    FLib: IString;
    function GetLib: IString;
  public
    constructor Create; reintroduce;
    class function New: IString;
    function Value: string;
    function Refresh: IString;
  end;

implementation

uses
    RO.TValue
  , Windows
  ;

{ TLibrary }

constructor TLibrary.Create;
begin
  FLib := TString.New(
    function : string
    var
      Path: array [0..MAX_PATH] of Char;
    begin
      SetString(
        Result,
        Path,
        GetModuleFileName(
          HInstance,
          Path,
          SizeOf(Path)
        )
      );
    end
  );
end;

function TLibrary.GetLib: IString;
begin
  Result := FLib;
end;

class function TLibrary.New: IString;
begin
  Result := Create;
end;

function TLibrary.Refresh: IString;
begin
  Result := Self;
  FLib.Refresh;
end;

function TLibrary.Value: string;
begin
  Result := FLib.Value;
end;

end.
