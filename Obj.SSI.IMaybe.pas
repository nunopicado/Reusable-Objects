(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMaybe                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMaybe                                                   **)
(** Classes       : TMaybe, Implements IMaybe                                **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Represents a value than may or may not be defined        **)
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

unit Obj.SSI.IMaybe;

interface

type
    IMaybe<T> = Interface
      function Define(Value: T) : IMaybe<T>;
      function IsDefined        : Boolean;
      function Value            : T;
      function Silent           : IMaybe<T>;
    End;

    TMaybe<T> = Class(TInterfacedObject, IMaybe<T>)
    private
      FValue   : T;
      FDefined : Boolean;
      FSilent  : Boolean;
    public
      class function New        : IMaybe<T>;
      function Define(Value: T) : IMaybe<T>;
      function Silent           : IMaybe<T>;
      function IsDefined        : Boolean;
      function Value            : T;
    End;

implementation

uses
    SysUtils
  ;

{ TMaybe<T> }

function TMaybe<T>.Define(Value: T): IMaybe<T>;
begin
     Result   := Self;
     FValue   := Value;
     FDefined := True;
end;

function TMaybe<T>.IsDefined: Boolean;
begin
     Result := FDefined;
end;

class function TMaybe<T>.New: IMaybe<T>;
begin
     Result := Create;
end;

function TMaybe<T>.Silent: IMaybe<T>;
begin
     Result  := Self;
     FSilent := True;
end;

function TMaybe<T>.Value: T;
begin
     if (not FSilent) and (not FDefined)
        then raise Exception.Create('Value not defined.');
     Result := FValue;
end;

end.
