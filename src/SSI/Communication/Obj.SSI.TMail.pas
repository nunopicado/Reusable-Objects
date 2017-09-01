(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Framework     : Indy                                                     **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TMailServer, implements IMailServer                      **)
(**               : TMailMessage, implements IMailMessage                    **)
(******************************************************************************)
(** Dependencies  : RTL, Indy                                                **)
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

unit Obj.SSI.TMail;

interface

uses
    SysUtils
  , idSMTP
  , Classes
  , idSSLOpenSSL
  , idMessage
  , Obj.SSI.IEmailAddress
  , Obj.SSI.IValue
  , Obj.SSI.IMail
  ;

type
  TMailServer = class(TInterfacedObject, IMailServer)
  private
    FAfterConnect    : TAfterConnect;
    FAfterDisconnect : TAfterDisconnect;
    FAfterSend       : TAfterSend;
    mail             : TIdSMTP;
    mailSSL          : TIdSSLIOHandlerSocketOpenSSL;
  public
    constructor Create(const HostName: IString; const HostPort: IWord); overload;
    destructor Destroy; override;
    class function New(const HostName: IString; const HostPort: IWord): IMailServer;
    function UseAuthentication(const UserName, Password: IString): IMailServer;
    function UseSSL: IMailServer;
    function Connect: IMailServer;
    function OnAfterConnect(const Action: TAfterConnect): IMailServer;
    function OnAfterDisconnect(const Action: TAfterDisconnect): IMailServer;
    function OnAfterSend(const Action: TAfterSend): IMailServer;
    function Send(const MailMessage: IMailMessage): IMailServer;
  end;

  TMailMessage = class(TInterfacedObject, IMailmessage)
  private
    FMsg: TIdMessage;
  public
    constructor Create(const FromName: IString; const FromAddr, ToAddr: IEmailAddress); overload;
    destructor Destroy; override;
    class function New(const FromName: IString; const FromAddr, ToAddr: IEmailAddress): IMailMessage;
    function Subject(const Subject: IString): IMailMessage;
    function Attach(const FileName: IString): IMailMessage;
    function Body(const MsgBody: IString): IMailMessage;
    function AddToAddr(const ToAddr: IEmailAddress): IMailMessage;
    function AddCcAddr(const CcAddr: IEmailAddress): IMailMessage;
    function AddBccAddr(const BccAddr: IEmailAddress): IMailMessage;
    function Msg: TidMessage;
  end;

implementation

uses
    IdExplicitTLSClientServerBase
  , IdAttachmentFile
  , Obj.SSI.TValue
  ;

{ TMailServer }

function TMailServer.Connect: IMailServer;
begin
  Result := Self;
  mail.Connect;
  if not Mail.Connected
    then raise Exception.Create(Format('Could not connect to SMTP server (%s:%d)', [mail.Host, mail.Port]));
  if Assigned(FAfterConnect)
    then FAfterConnect(mail.Connected);
end;

constructor TMailServer.Create(const HostName: IString; const HostPort: IWord);
begin
  inherited Create;

  mail           := TidSMTP.Create(nil);
  mail.Host      := HostName.Value;
  mail.Port      := HostPort.Value;
  mail.AuthType  := satNone;
  mail.IoHandler := nil;
end;

destructor TMailServer.Destroy;
begin
  if mail.Connected
    then begin
           mail.Disconnect;
           if Assigned(FAfterDisconnect)
             then FAfterDisconnect(mail.Connected);
         end;
  mail.Free;
  if Assigned(mailSSL)
    then mailSSL.Free;
  inherited;
end;

class function TMailServer.New(const HostName: IString; const HostPort: IWord): IMailServer;
begin
  Result := Create(Hostname, HostPort);
end;

function TMailServer.OnAfterConnect(const Action: TAfterConnect): IMailServer;
begin
  Result        := Self;
  FAfterConnect := Action;
end;

function TMailServer.OnAfterDisconnect(const Action: TAfterDisconnect): IMailServer;
begin
  Result           := Self;
  FAfterDisconnect := Action;
end;

function TMailServer.OnAfterSend(const Action: TAfterSend): IMailServer;
begin
  Result     := Self;
  FAfterSend := Action;
end;

function TMailServer.Send(const MailMessage: IMailMessage): IMailServer;
begin
  Result := Self;
  mail.Send(MailMessage.Msg);
  if Assigned(FAfterSend)
    then FAfterSend(
           TString.New(
             MailMessage.Msg.Subject
           )
         );
end;

function TMailServer.UseSSL: IMailServer;
begin
  Result              := Self;
  mailSSL             := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  mailSSL.Destination := Format('%s:%d', [mail.Host, mail.Port]);
  mailSSL.Host        := mail.Host;
  mailSSL.Port        := mail.Port;
  mail.IOHandler      := mailSSL;
  if mail.Port = 465
    then mail.UseTLS  := utUseImplicitTLS
    else mail.UseTLS  := utUseExplicitTLS;
end;

function TMailServer.UseAuthentication(const UserName, Password: IString): IMailServer;
begin
  Result        := Self;
  mail.AuthType := satDefault;
  mail.Username := UserName.Value;
  mail.Password := Password.Value;
end;

{ TMailMessage }

function TMailMessage.AddBccAddr(const BccAddr: IEmailAddress): IMailMessage;
begin
  if FMsg.BCCList.EMailAddresses <> ''
    then FMsg.BCCList.EMailAddresses := FMsg.BCCList.EMailAddresses + ';';
  FMsg.BCCList.EMailAddresses := FMsg.BCCList.EMailAddresses + BccAddr.Value;
end;

function TMailMessage.AddCcAddr(const CcAddr: IEmailAddress): IMailMessage;
begin
  if FMsg.CCList.EMailAddresses <> ''
    then FMsg.CCList.EMailAddresses := FMsg.CCList.EMailAddresses + ';';
  FMsg.CCList.EMailAddresses := FMsg.CCList.EMailAddresses + CcAddr.Value;
end;

function TMailMessage.AddToAddr(const ToAddr: IEmailAddress): IMailMessage;
begin
  if FMsg.Recipients.EMailAddresses <> ''
    then FMsg.Recipients.EMailAddresses := FMsg.Recipients.EMailAddresses + ';';
  FMsg.Recipients.EMailAddresses := FMsg.Recipients.EMailAddresses + ToAddr.Value;
end;

function TMailMessage.Attach(const FileName: IString): IMailMessage;
begin
  Result := Self;
  if FileExists(FileName.Value)
    then TIdAttachmentFile.Create(FMsg.MessageParts, FileName.Value);
end;

function TMailMessage.Body(const MsgBody: IString): IMailMessage;
begin
  Result         := Self;
  FMsg.Body.Text := MsgBody.Value;
end;

constructor TMailMessage.Create(const FromName: IString; const FromAddr, ToAddr: IEmailAddress);
begin
  inherited Create;
  FMsg                           := TidMessage.Create(nil);
  FMsg.MessageParts.Clear;
  FMsg.From.Name                 := FromName.Value;
  FMsg.From.Address              := FromAddr.Value;
  FMsg.Recipients.EMailAddresses := ToAddr.Value;
end;

destructor TMailMessage.Destroy;
begin
  FMsg.Free;
  inherited;
end;

function TMailMessage.Msg: TidMessage;
begin
  Result := FMsg;
end;

class function TMailMessage.New(const FromName: IString; const FromAddr, ToAddr: IEmailAddress): IMailMessage;
begin
  Result := Create(FromName, FromAddr, ToAddr);
end;

function TMailMessage.Subject(const Subject: IString): IMailMessage;
begin
  Result       := Self;
  FMsg.Subject := Subject.Value;
end;

end.
