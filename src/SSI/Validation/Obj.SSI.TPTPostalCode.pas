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
    Obj.SSI.IPostalCode
  , Obj.SSI.IValue
  ;

type
  TPTPostalCode = class(TInterfacedObject, IPostalCode)
  private
    FPostalCode: string;
    procedure Validate;
  public
    constructor Create(const PostalCode: string); overload;
    class function New(const PostalCode: string): IPostalCode; overload;
    class function New(const PostalCode: IString): IPostalCode; overload;
    function AsString: string;
  end;

  TDecorablePostalCode = class(TInterfacedObject, IPostalCode)
  protected
    FOrigin: IPostalCode;
  public
    constructor Create(const PostalCode: IPostalCode);
    class function New(const PostalCode: IPostalCode): IPostalCode;
    function AsString: string; virtual;
  end;

  TPTCP7 = class(TDecorablePostalCode, IPostalCode)
  public
    function AsString: string;
  end;

  TPTCP4 = class(TDecorablePostalCode, IPostalCode)
  public
    function AsString: string;
  end;

  TPTCP3 = class(TDecorablePostalCode, IPostalCode)
  public
    function AsString: string;
  end;

implementation

uses
    SysUtils
  , Obj.SSI.TValue
  ;

{ TPTPostalCode }

constructor TPTPostalCode.Create(const PostalCode: string);
begin
  FPostalCode := PostalCode;
  Validate;
end;

class function TPTPostalCode.New(const PostalCode: string): IPostalCode;
begin
  Result := Create(PostalCode);
end;

function TPTPostalCode.AsString: string;
begin
  Result := FPostalCode;
end;

procedure TPTPostalCode.Validate;
var
  Valid: Boolean;
  Value: Integer;
  Parts: TArray<string>;
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

class function TPTPostalCode.New(const PostalCode: IString): IPostalCode;
begin
  Result := New(PostalCode.Value);
end;

{ TPTCP7 }

function TPTCP7.AsString: string;
begin
  Result := FOrigin.AsString;
  Delete(Result, 5, 1);
end;

{ TDecorablePostalCode }

function TDecorablePostalCode.AsString: string;
begin
  Result := FOrigin.AsString;
end;

constructor TDecorablePostalCode.Create(const PostalCode: IPostalCode);
begin
  FOrigin := PostalCode;
end;

class function TDecorablePostalCode.New(
  const PostalCode: IPostalCode): IPostalCode;
begin
  Result := Create(PostalCode);
end;

{ TPTCP4 }

function TPTCP4.AsString: string;
begin
  Result := FOrigin.AsString;
  Delete(Result, 5, 4);
end;

{ TPTCP3 }

function TPTCP3.AsString: string;
begin
  Result := FOrigin.AsString;
  Delete(Result, 1, 5);
end;

end.
