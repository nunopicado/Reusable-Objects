(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPTPostalCode                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TPTPostalCode, implements IPTPostalCode                  **)
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

unit Obj.SSI.TPTPostalCode;

interface

uses
    Obj.SSI.IPTPostalCode
  , Obj.SSI.IValue
  ;

type
    TPTPostalCode = class(TInterfacedObject, IPTPostalCode)
    private
      FPostalCode: IString;
      procedure Validate;
    public
      constructor Create(const PostalCode: IString); overload;
      class function New(const PostalCode: IString): IPTPostalCode; overload;
      class function New(const PostalCode: string): IPTPostalCode; overload;
      function ToIString: IString;
    end;

implementation

uses
    SysUtils
  , Obj.SSI.TValue
  ;

{ TMailAddress }

constructor TPTPostalCode.Create(const PostalCode: IString);
begin
     inherited Create;
     FPostalCode := PostalCode;
     Validate;
end;

class function TPTPostalCode.New(const PostalCode: string): IPTPostalCode;
begin
  Result := New(
    TString.New(
      PostalCode
    )
  );
end;

function TPTPostalCode.ToIString: IString;
begin
     Result := FPostalCode;
end;

procedure TPTPostalCode.Validate;
var
   Valid: Boolean;
   Value: Integer;
   Parts: TArray<String>;
begin
     Valid := (FPostalCode.Value.Length = 8) and (FPostalCode.Value[5] = '-');
     if Valid
        then begin
                  Parts := FPostalCode.Value.Split(['-']);
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

class function TPTPostalCode.New(const PostalCode: IString): IPTPostalCode;
begin
     Result := Create(PostalCode);
end;

end.
