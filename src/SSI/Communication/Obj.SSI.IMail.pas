unit Obj.SSI.IMail;

interface

uses
    Obj.SSI.IPrimitive
  , idMessage
  ;

type
  TAfterConnect    = Reference to procedure (const Connected: Boolean);
  TAfterDisconnect = TAfterConnect;
  TAfterSend       = Reference to procedure (const Subject: IString);

  IMailServer  = interface;
  IMailMessage = interface;

  IMailServer = interface ['{DCA8E8BA-5765-4591-816A-FD442F4E6384}']
    function UseAuthentication(const UserName, Password: IString): IMailServer;
    function UseSSL: IMailServer;
    function Connect: IMailServer;
    function OnAfterConnect(const Action: TAfterConnect): IMailServer;
    function OnAfterDisconnect(const Action: TAfterDisconnect): IMailServer;
    function OnAfterSend(const Action: TAfterSend): IMailServer;
    function Send(const MailMessage: IMailMessage): IMailServer;
  end;

  IMailMessage = interface ['{440D5058-F8CA-4E6E-9146-056BEB305FFF}']
    function Subject(const Subject: IString): IMailMessage;
    function Attach(const FileName: IString): IMailMessage;
    function Body(const MsgBody: IString): IMailMessage;
    function Msg: TidMessage;
  end;

implementation

end.
