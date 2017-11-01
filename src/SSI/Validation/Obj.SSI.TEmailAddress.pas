(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IEmailAddress                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TEmailAddress, implements IEmailAddress                  **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles email address string values                      **)
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

unit Obj.SSI.TEmailAddress;

interface

uses
    Obj.SSI.IEmailAddress
  , Obj.SSI.IValue
  ;

type
  TEmailAddress = class(TInterfacedObject, IEmailAddress)
  private
    FEmailAddress: string;
    FIsValid: IBoolean;
    function CheckIfValid: Boolean;
  public
    constructor Create(EmailAddress: string);
    class function New(EmailAddress: string): IEMailAddress; overload;
    class function New(EmailAddress: IString): IEmailAddress; overload;
    function Value: string;
    function IsValid: Boolean;
  end;

implementation

uses
    SysUtils
  , Obj.SSI.IStringStat
  , Obj.SSI.TStringStat
  , Obj.SSI.TValue
  ;

{ TMailAddress }

constructor TEmailAddress.Create(EmailAddress: string);
begin
  inherited Create;
  FEmailAddress := EmailAddress;
  FIsValid := TBoolean.NewDelayed(CheckIfValid);
end;

function TEmailAddress.IsValid: Boolean;
begin
  Result := FIsValid.Value;
end;

function TEmailAddress.Value: string;
begin
  if not IsValid
    then raise Exception.Create(Format('Invalid Email Address (%s)', [FEmailAddress]));
  Result := FEmailAddress;
end;

function TEmailAddress.CheckIfValid: Boolean;
const
  Allowed: TCharSet = ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.'];
var
  i          : Integer;
  NamePart   : string;
  ServerPart : string;
begin
  Result := False;
  i      := Pos('@', FEmailAddress);
  if i = 0
    then Exit;
  NamePart   := Copy(FEmailAddress, 1, i - 1);
  ServerPart := Copy(FEmailAddress, i + 1, FEmailAddress.Length);
  if (NamePart.Length = 0) or
     (ServerPart.Length < 5)
    then Exit;
  i := Pos('.', ServerPart);
  if (i = 0) or
     (i > (ServerPart.Length - 2))
    then Exit;
  Result := TStringStat.New(NamePart).ContainsOnly(Allowed) and
            TStringStat.New(ServerPart).ContainsOnly(Allowed);
end;

class function TEmailAddress.New(EmailAddress: IString): IEmailAddress;
begin
  Result := Create(EmailAddress.Value);
end;

class function TEmailAddress.New(EmailAddress: string): IEMailAddress;
begin
  Result := Create(EmailAddress);
end;

end.
