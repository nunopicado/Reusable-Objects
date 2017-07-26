(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMailServer                                              **)
(** Framework     : Indy                                                     **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMailServer, IMailMessage                                **)
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

unit Obj.SSI.IMail;

interface

uses
    Obj.SSI.IValue
  , idMessage
  ;

type
  TAfterConnect    = Reference to procedure (const Connected: Boolean);
  TAfterDisconnect = TAfterConnect;
  TAfterSend       = Reference to procedure (const Subject: IString);

  IMailServer  = interface;
  IMailMessage = interface;

  IMailServer = interface(IInvokable)
  ['{DCA8E8BA-5765-4591-816A-FD442F4E6384}']
    function UseAuthentication(const UserName, Password: IString): IMailServer;
    function UseSSL: IMailServer;
    function Connect: IMailServer;
    function OnAfterConnect(const Action: TAfterConnect): IMailServer;
    function OnAfterDisconnect(const Action: TAfterDisconnect): IMailServer;
    function OnAfterSend(const Action: TAfterSend): IMailServer;
    function Send(const MailMessage: IMailMessage): IMailServer;
  end;

  IMailMessage = interface(IInvokable)
  ['{440D5058-F8CA-4E6E-9146-056BEB305FFF}']
    function Subject(const Subject: IString): IMailMessage;
    function Attach(const FileName: IString): IMailMessage;
    function Body(const MsgBody: IString): IMailMessage;
    function Msg: TidMessage;
  end;

implementation

end.
