(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPostalCode                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPostalCode                                              **)
(** Classes       : TPostalCodePT, implements IPostalCode                    **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles portuguese postal codes                          **)
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

unit Obj.SSI.IPostalCode;

interface

type
    IPostalCode = interface ['{5FB0FFE6-E457-4865-92CB-5AB2793C325F}']
      function ToString: String;
    end;

    TPostalCode = class(TInterfacedObject, IPostalCode)
    private
      FPostalCode: String;
      constructor Create(PostalCode: String); Overload;
      procedure Validate;
    public
      class function New(PostalCode: String): IPostalCode;
      function ToString: String;
    end;

implementation

uses
    SysUtils;

{ TMailAddress }

constructor TPostalCode.Create(PostalCode: String);
begin
     inherited Create;
     FPostalCode := PostalCode;
     Validate;
end;

function TPostalCode.ToString: String;
begin
     Result := FPostalCode;
end;

procedure TPostalCode.Validate;
var
   Valid: Boolean;
   Value: Integer;
   Parts: TArray<String>;
begin
     Valid := (FPostalCode.Length = 8) and (FPostalCode[5] = '-');
     if Valid
        then begin
                  Parts := FPostalCode.Split(['-']);
                  Valid := Length(Parts) = 2;
                  if Valid
                     then begin
                               Valid := TryStrToInt(Parts[0], Value) and (Value >= 1000) and (Value <= 9999);
                               if Valid
                                  then Valid := TryStrToInt(Parts[1], Value) and (Value >= 0) and (Value <= 999);
                          end;
             end;

     if not Valid
        then raise exception.Create(Format('"%s" is not a valid portuguese postal code.', [FPostalCode]));
end;

class function TPostalCode.New(PostalCode: String): IPostalCode;
begin
     Result := Create(PostalCode);
end;

end.
