(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : IMailServer                                              **)
(** Framework     : Indy                                                     **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMailServer, IMailMessage                                **)
(** Classes       : TMailServer, implements IMailServer                      **)
(**               : TMailMessage, implements IMailMessage                    **)
(******************************************************************************)
(** Dependencies  : I<T>, IEmailAddress                                      **)
(**               : RTL, Indy                                                **)
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
(**					terms													 **)
(******************************************************************************)

unit Obj.SSI.IMail;

interface

uses
    SysUtils
  , idSMTP
  , Classes
  , idSSLOpenSSL
  , idMessage
  , Obj.SSI.IEmailAddress
  , Obj.SSI.GenericIntf
  ;

type
    TAfterConnect    = Reference to procedure (const Connected: Boolean);
    TAfterDisconnect = TAfterConnect;
    TAfterSend       = Reference to procedure (const Subject: String);

    IMailServer  = interface;
    IMailMessage = interface;

    IMailServer = interface ['{DCA8E8BA-5765-4591-816A-FD442F4E6384}']
      function UssAuthentication(UserName, Password: String): IMailServer;
      function UseSSL: IMailServer;
      function Connect: IMailServer;
      function OnAfterConnect(Action: TAfterConnect): IMailServer;
      function OnAfterDisconnect(Action: TAfterDisconnect): IMailServer;
      function OnAfterSend(Action: TAfterSend): IMailServer;
      function Send(MailMessage: IMailMessage): IMailServer;
    end;

    IMailMessage = interface ['{440D5058-F8CA-4E6E-9146-056BEB305FFF}']
      function Subject(Subject: String): IMailMessage;
      function Attach(FileName: String): IMailMessage;
      function Body(MsgBody: I<TStringList>): IMailMessage;
      function Msg: TidMessage;
    end;

    TMailServer = Class(TInterfacedObject, IMailServer)
    private
      FAfterConnect    : TAfterConnect;
      FAfterDisconnect : TAfterDisconnect;
      FAfterSend       : TAfterSend;
      mail             : TIdSMTP;
      mailSSL          : TIdSSLIOHandlerSocketOpenSSL;
    public
      constructor Create(HostName: String; HostPort: Word); Overload;
      destructor Destroy; Override;
      class function New(HostName: String; HostPort: Word): IMailServer;
      function UssAuthentication(UserName, Password: String): IMailServer;
      function UseSSL: IMailServer;
      function Connect: IMailServer;
      function OnAfterConnect(Action: TAfterConnect): IMailServer;
      function OnAfterDisconnect(Action: TAfterDisconnect): IMailServer;
      function OnAfterSend(Action: TAfterSend): IMailServer;
      function Send(MailMessage: IMailMessage): IMailServer;
    End;

    TMailMessage = Class(TInterfacedObject, IMailmessage)
    private
      FMsg: TIdMessage;
    public
      constructor Create(FromName: String; FromAddr, ToAddr: IEmailAddress); Overload;
      destructor Destroy; Override;
      class function New(FromName: String; FromAddr, ToAddr: IEmailAddress): IMailMessage;
      function Subject(Subject: String): IMailMessage;
      function Attach(FileName: String): IMailMessage;
      function Body(MsgBody: I<TStringList>): IMailMessage;
      function AddToAddr(ToAddr: IEmailAddress): IMailMessage;
      function AddCcAddr(CcAddr: IEmailAddress): IMailMessage;
      function AddBccAddr(BccAddr: IEmailAddress): IMailMessage;
      function Msg: TidMessage;
    End;


implementation

uses
    IdExplicitTLSClientServerBase
  , IdAttachmentFile
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

constructor TMailServer.Create(HostName: String; HostPort: Word);
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

class function TMailServer.New(HostName: String; HostPort: Word): IMailServer;
begin
     Result := Create(Hostname, HostPort);
end;

function TMailServer.OnAfterConnect(Action: TAfterConnect): IMailServer;
begin
     Result        := Self;
     FAfterConnect := Action;
end;

function TMailServer.OnAfterDisconnect(Action: TAfterDisconnect): IMailServer;
begin
     Result           := Self;
     FAfterDisconnect := Action;
end;

function TMailServer.OnAfterSend(Action: TAfterSend): IMailServer;
begin
     Result     := Self;
     FAfterSend := Action;
end;

function TMailServer.Send(MailMessage: IMailMessage): IMailServer;
begin
     Result := Self;
     mail.Send(MailMessage.Msg);
     if Assigned(FAfterSend)
        then FAfterSend(MailMessage.Msg.Subject);
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
        then mail.UseTLS := utUseImplicitTLS
        else mail.UseTLS := utUseExplicitTLS;
end;

function TMailServer.UssAuthentication(UserName, Password: String): IMailServer;
begin
     Result        := Self;
     mail.AuthType := satDefault;
     mail.Username := UserName;
     mail.Password := Password;
end;

{ TMailMessage }

function TMailMessage.AddBccAddr(BccAddr: IEmailAddress): IMailMessage;
begin
     if FMsg.BCCList.EMailAddresses <> ''
        then FMsg.BCCList.EMailAddresses := FMsg.BCCList.EMailAddresses + ';';
     FMsg.BCCList.EMailAddresses := FMsg.BCCList.EMailAddresses + BccAddr.ToString;
end;

function TMailMessage.AddCcAddr(CcAddr: IEmailAddress): IMailMessage;
begin
     if FMsg.CCList.EMailAddresses <> ''
        then FMsg.CCList.EMailAddresses := FMsg.CCList.EMailAddresses + ';';
     FMsg.CCList.EMailAddresses := FMsg.CCList.EMailAddresses + CcAddr.ToString;
end;

function TMailMessage.AddToAddr(ToAddr: IEmailAddress): IMailMessage;
begin
     if FMsg.Recipients.EMailAddresses <> ''
        then FMsg.Recipients.EMailAddresses := FMsg.Recipients.EMailAddresses + ';';
     FMsg.Recipients.EMailAddresses := FMsg.Recipients.EMailAddresses + ToAddr.ToString;
end;

function TMailMessage.Attach(FileName: String): IMailMessage;
begin
     Result := Self;
     if FileExists(FileName)
        then TIdAttachmentFile.Create(FMsg.MessageParts, FileName);
end;

function TMailMessage.Body(MsgBody: I<TStringList>): IMailMessage;
begin
     Result         := Self;
     FMsg.Body.Text := MsgBody.Obj.Text;
end;

constructor TMailMessage.Create(FromName: String; FromAddr, ToAddr: IEmailAddress);
begin
     inherited Create;
     FMsg                           := TidMessage.Create(nil);
     FMsg.MessageParts.Clear;
     FMsg.From.Name                 := FromName;
     FMsg.From.Address              := FromAddr.ToString;
     FMsg.Recipients.EMailAddresses := ToAddr.ToString;
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

class function TMailMessage.New(FromName: String; FromAddr, ToAddr: IEmailAddress): IMailMessage;
begin
     Result := Create(FromName, FromAddr, ToAddr);
end;

function TMailMessage.Subject(Subject: String): IMailMessage;
begin
     Result       := Self;
     FMsg.Subject := Subject;
end;

end.
