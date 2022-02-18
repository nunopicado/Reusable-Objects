(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMailServer                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TMailServer                                              **)
(**                 TMailMessage                                             **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Indy                                                     **)
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

unit RO.TMail;

interface

uses
    SysUtils
  , idSMTP
  , Classes
  , idSSLOpenSSL
  , idMessage
  , IdMessageBuilder
  , RO.IEmailAddress
  , RO.IValue
  , RO.IMail
  ;

type
  TMailServer = class(TInterfacedObject, IMailServer)
  private
    FAfterConnect    : TProc<Boolean>;
    FAfterDisconnect : TProc<Boolean>;
    FAfterSend       : TProc<Boolean, string>;
    mail             : TIdSMTP;
    mailSSL          : TIdSSLIOHandlerSocketOpenSSL;
  public
    constructor Create(const HostName: string; const HostPort: Word);
    destructor Destroy; override;
    class function New(const HostName: string; const HostPort: Word): IMailServer; overload;
    class function New(const HostName: IString; const HostPort: IWord): IMailServer; overload;
    function UseAuthentication(const UserName, Password: string): IMailServer; overload;
    function UseAuthentication(const UserName, Password: IString): IMailServer; overload;
    function UseSSL: IMailServer; overload;
    function UseSSL(const SSL: Boolean): IMailServer; overload;
    function Connect: IMailServer;
    function OnAfterConnect(const Action: TProc<Boolean>): IMailServer;
    function OnAfterDisconnect(const Action: TProc<Boolean>): IMailServer;
    function OnAfterSend(const Action: TProc<Boolean, string>): IMailServer;
    function Send(const MailMessage: IMailMessage): IMailServer;
  end;

  TMailMessage = class(TInterfacedObject, IMailmessage)
  private
    FMsg  : TIdMessage;
    FMB   : TIdMessageBuilderHtml;
    FHTML : Boolean;
  public
    constructor Create(const idMessage: TidMessage; const FromName: string; const FromAddr, ToAddr: IEmailAddress); overload;
    constructor Create(const FromName: string; const FromAddr, ToAddr: IEmailAddress); overload;
    destructor Destroy; override;
    class function New(const FromName: string; const FromAddr, ToAddr: IEmailAddress): IMailMessage; overload;
    class function New(const FromName: IString; const FromAddr, ToAddr: IEmailAddress): IMailMessage; overload;
    class function New(const idMessage: TidMessage; const FromName: string; const FromAddr, ToAddr: IEmailAddress): IMailMessage; overload;
    class function New(const idMessage: TidMessage; const FromName: IString; const FromAddr, ToAddr: IEmailAddress): IMailMessage; overload;
    function Subject(const MsgSubject: string): IMailMessage; overload;
    function Subject(const MsgSubject: IString): IMailMessage; overload;
    function Attach(const FileName: string): IMailMessage; overload;
    function Attach(const FileName: IString): IMailMessage; overload;
    function AsHTML: IMailMessage;
    function ASPlainText: IMailMessage;
    function Mime: IMailMessage;
    function Body(const MsgBody: string): IMailMessage; overload;
    function Body(const MsgBody: IString): IMailMessage; overload;
    function AddToAddr(const ToAddr: IEmailAddress): IMailMessage;
    function AddCcAddr(const CcAddr: IEmailAddress): IMailMessage;
    function AddBccAddr(const BccAddr: IEmailAddress): IMailMessage;
    function Msg: TidMessage;
  end;

implementation

uses
    IdExplicitTLSClientServerBase
  , IdAttachmentFile
  , IdText
  , RO.TValue
  , RO.TIf
  ;

{ TMailServer }

function TMailServer.Connect: IMailServer;
begin
  Result := Self;
  if not Mail.Connected
    then mail.Connect;
  if not Mail.Connected
    then raise Exception.Create(Format('Could not connect to SMTP server (%s:%d)', [mail.Host, mail.Port]));
  if Assigned(FAfterConnect)
    then FAfterConnect(mail.Connected);
end;

constructor TMailServer.Create(const HostName: string; const HostPort: Word);
begin
  inherited Create;

  mail           := TidSMTP.Create(nil);
  mail.Host      := HostName;
  mail.Port      := HostPort;
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

class function TMailServer.New(const HostName: string;
  const HostPort: Word): IMailServer;
begin
  Result := Create(HostName, HostPort);
end;

class function TMailServer.New(const HostName: IString; const HostPort: IWord): IMailServer;
begin
  Result := New(Hostname.Value, HostPort.Value);
end;

function TMailServer.OnAfterConnect(const Action: TProc<Boolean>): IMailServer;
begin
  Result        := Self;
  FAfterConnect := Action;
end;

function TMailServer.OnAfterDisconnect(const Action: TProc<Boolean>): IMailServer;
begin
  Result           := Self;
  FAfterDisconnect := Action;
end;

function TMailServer.OnAfterSend(const Action: TProc<Boolean, string>): IMailServer;
begin
  Result     := Self;
  FAfterSend := Action;
end;

function TMailServer.Send(const MailMessage: IMailMessage): IMailServer;
var
  Success: Boolean;
begin
  Result := Self;
  try
    Success := True;
    mail.Send(MailMessage.Msg);
  except
    Success := False;
  end;
  if Assigned(FAfterSend)
    then
      FAfterSend(
        Success,
        MailMessage.Msg.Subject
      );
end;

function TMailServer.UseAuthentication(const UserName,
  Password: IString): IMailServer;
begin
  Result := UseAuthentication(Username.Value, Password.Value);
end;

function TMailServer.UseSSL(const SSL: Boolean): IMailServer;
begin
  Result := TIf<IMailServer>.New(
    SSL,
    UseSSL,
    Self
  ).Eval;
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

function TMailServer.UseAuthentication(const UserName, Password: string): IMailServer;
begin
  Result        := Self;
  mail.AuthType := satDefault;
  mail.Username := UserName;
  mail.Password := Password;
end;

{ TMailMessage }

function TMailMessage.AddBccAddr(const BccAddr: IEmailAddress): IMailMessage;
begin
  Result := Self;
  if FMsg.BCCList.EMailAddresses <> ''
    then FMsg.BCCList.EMailAddresses := FMsg.BCCList.EMailAddresses + ';';
  FMsg.BCCList.EMailAddresses := FMsg.BCCList.EMailAddresses + BccAddr.Value;
end;

function TMailMessage.AddCcAddr(const CcAddr: IEmailAddress): IMailMessage;
begin
  Result := Self;
  if FMsg.CCList.EMailAddresses <> ''
    then FMsg.CCList.EMailAddresses := FMsg.CCList.EMailAddresses + ';';
  FMsg.CCList.EMailAddresses := FMsg.CCList.EMailAddresses + CcAddr.Value;
end;

function TMailMessage.AddToAddr(const ToAddr: IEmailAddress): IMailMessage;
begin
  Result := Self;
  if FMsg.Recipients.EMailAddresses <> ''
    then FMsg.Recipients.EMailAddresses := FMsg.Recipients.EMailAddresses + ';';
  FMsg.Recipients.EMailAddresses := FMsg.Recipients.EMailAddresses + ToAddr.Value;
end;

function TMailMessage.AsHTML: IMailMessage;
begin
  Result            := Self;
  FHTML             := True;
  FMsg.ContentType  := 'text/html';
  if Assigned(FMB)
    then FMB.Free;
  FMB               := TIdMessageBuilderHTML.Create;
end;

function TMailMessage.ASPlainText: IMailMessage;
begin
  Result            := Self;
  FMsg.ContentType  := 'text/plain';
end;

function TMailMessage.Attach(const FileName: IString): IMailMessage;
begin
  Result := Attach(Filename.Value);
end;

function TMailMessage.Attach(const FileName: string): IMailMessage;
begin
  Result := Self;
  if FileExists(FileName)
    then
      if not FHTML
        then TIdAttachmentFile.Create(FMsg.MessageParts, FileName)
        else begin
          FMB.HtmlFiles.Add(FileName);
          FMB.FillMessage(FMsg);
        end;
end;

function TMailMessage.Body(const MsgBody: string): IMailMessage;
begin
  Result := Self;
  if not FHTML
    then FMsg.Body.Text := MsgBody
    else begin
      FMB.Html.Text := MsgBody;
      FMB.HtmlCharSet := 'utf-8';
      FMB.FillMessage(FMsg);
    end;
end;

constructor TMailMessage.Create(const FromName: string; const FromAddr, ToAddr: IEmailAddress);
begin
  Create(
    TidMessage.Create(nil),
    FromName,
    FromAddr,
    ToAddr
  );
end;

destructor TMailMessage.Destroy;
begin
  FMsg.Free;
  if Assigned(FMB)
    then FMB.Free;
  inherited;
end;

function TMailMessage.Mime: IMailMessage;
begin
  Result        := Self;
  FMsg.Encoding := meMime;
end;

function TMailMessage.Msg: TidMessage;
begin
  Result := FMsg;
end;

class function TMailMessage.New(const FromName: string; const FromAddr,
  ToAddr: IEmailAddress): IMailMessage;
begin
  Result := Create(FromName, FromAddr, ToAddr);
end;

class function TMailMessage.New(const FromName: IString; const FromAddr, ToAddr: IEmailAddress): IMailMessage;
begin
  Result := Create(FromName.Value, FromAddr, ToAddr);
end;

function TMailMessage.Subject(const MsgSubject: IString): IMailMessage;
begin
  Result := Subject(MsgSubject.Value);
end;

function TMailMessage.Subject(const MsgSubject: string): IMailMessage;
begin
  Result       := Self;
  FMsg.Subject := MsgSubject;
end;

function TMailMessage.Body(const MsgBody: IString): IMailMessage;
begin
  Result := Body(MsgBody.Value);
end;

constructor TMailMessage.Create(const idMessage: TidMessage;
  const FromName: string; const FromAddr, ToAddr: IEmailAddress);
begin
  FMsg              := idMessage;
  FMsg.MessageParts.Clear;
  FMsg.From.Name    := FromName;
  FMsg.From.Address := FromAddr.Value;
  FHTML             := False;
  if Assigned(ToAddr)
    then FMsg.Recipients.EMailAddresses := ToAddr.Value;
end;

class function TMailMessage.New(const idMessage: TidMessage;
  const FromName: string; const FromAddr, ToAddr: IEmailAddress): IMailMessage;
begin
  Result := Create(idMessage, FromName, FromAddr, ToAddr);
end;

class function TMailMessage.New(const idMessage: TidMessage;
  const FromName: IString; const FromAddr, ToAddr: IEmailAddress): IMailMessage;
begin
  Result := Create(idMessage, FromName.Value, FromAddr, ToAddr);
end;

end.
