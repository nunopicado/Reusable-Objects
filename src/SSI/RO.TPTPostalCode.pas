(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPTPostalCode                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TPTPostalCode                                            **)
(**                 TDecorablePostalCode                                     **)
(******************************************************************************)
(** Decorators    : TPTCP7, TPTCP4, TPTCP3                                   **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
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

unit RO.TPTPostalCode;

interface

uses
    RO.IPostalCode
  , RO.IValue
  ;

type
  TPTPostalCode = class(TInterfacedObject, IPostalCode)
  private
    FPostalCode: string;
    FValid: IBoolean;
  public
    constructor Create(const PostalCode: string); overload;
    class function New(const PostalCode: string): IPostalCode; overload;
    class function New(const PostalCode: IString): IPostalCode; overload;
    function AsString: string;
    function IsValid: Boolean;
  end;

  TNullPostalCode = class(TInterfacedObject, IPostalCode)
  public
    class function New: IPostalCode;
    function AsString: string;
    function IsValid: Boolean;
  end;

  TDecorablePostalCode = class(TInterfacedObject, IPostalCode)
  protected
    FOrigin: IPostalCode;
  public
    constructor Create(const PostalCode: IPostalCode);
    class function New(const PostalCode: IPostalCode): IPostalCode;
    function AsString: string; virtual;
    function IsValid: Boolean; virtual;
  end;

  TPTCP7 = class(TDecorablePostalCode, IPostalCode)
  public
    function AsString: string; override;
  end;

  TPTCP4 = class(TDecorablePostalCode, IPostalCode)
  public
    function AsString: string; override;
  end;

  TPTCP3 = class(TDecorablePostalCode, IPostalCode)
  public
    function AsString: string; override;
  end;

implementation

uses
    SysUtils
  , RO.TValue
  , RegularExpressions
  ;

{ TPTPostalCode }

constructor TPTPostalCode.Create(const PostalCode: string);
begin
  FPostalCode := PostalCode;
  FValid := TBoolean.New(
    function : Boolean
    begin
      Result := TRegEx.IsMatch(FPostalCode, '[1-9]\d{3}[\-]\d{3}$');
    end
  );
end;

function TPTPostalCode.IsValid: Boolean;
begin
  Result := FValid.Value;
end;

class function TPTPostalCode.New(const PostalCode: string): IPostalCode;
begin
  Result := Create(PostalCode);
end;

function TPTPostalCode.AsString: string;
begin
  Result := FPostalCode;
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

function TDecorablePostalCode.IsValid: Boolean;
begin
  Result := FOrigin.IsValid;
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

{ TNullPostalCode }

function TNullPostalCode.AsString: string;
begin
  Result := '';
end;

function TNullPostalCode.IsValid: Boolean;
begin
  Result := False;
end;

class function TNullPostalCode.New: IPostalCode;
begin
  Result := Create;
end;

end.
