(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : IEmailAddress                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IEmailAddress                                            **)
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
(**					terms													 **)
(******************************************************************************)

unit Obj.SSI.IEmailAddress;

interface

type
    IEmailAddress = interface ['{C3F80B3B-D3F0-47B7-BE90-B6EBD0505E8C}']
      function ToString: String;
    end;

    TEmailAddress = class(TInterfacedObject, IEmailAddress)
    private
      FEmailAddress: String;
      function IsValid: Boolean;
    public
      constructor Create(EmailAddress: String); Overload;
      class function New(EmailAddress: String): IEMailAddress;
      function ToString: String;
    end;

implementation

uses
    SysUtils;

{ TMailAddress }

constructor TEmailAddress.Create(EmailAddress: String);
begin
     inherited Create;
     FEmailAddress := EmailAddress;
end;

function TEmailAddress.ToString: String;
begin
     if not IsValid
        then raise Exception.Create(Format('Invalid Email Address (%s)', [FEmailAddress]));
     Result := FEmailAddress;
end;

function TEmailAddress.IsValid: Boolean;
  function CheckAllowed(const s: string): Boolean;
  var
     i: Integer;
  begin
       Result := false;
       for i:= 1 to Length(s) do
           if not (s[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_', '-', '.'])
              then Exit;
       Result := true;
  end;

var
  i : Integer;
  NamePart, ServerPart: String;
begin
     Result := False;
     i      := Pos('@', FEmailAddress);
     if i=0
        then Exit;
     NamePart   := Copy(FEmailAddress, 1, i-1);
     ServerPart := Copy(FEmailAddress, i+1, Length(FEmailAddress));
     if (Length(NamePart)=0) or
        ((Length(ServerPart)<5))
        then Exit;
     i := Pos('.', ServerPart);
     if (i=0) or
        (i>(Length(serverPart)-2))
        then Exit;
     Result := CheckAllowed(NamePart) and CheckAllowed(ServerPart);
end;

class function TEmailAddress.New(EmailAddress: String): IEMailAddress;
begin
     Result := Create(EmailAddress);
end;

end.
