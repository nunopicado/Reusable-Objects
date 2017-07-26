(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : INetworkNode                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado (Code assembling)                            **)
(******************************************************************************)
(** Interfaces    : INetworkNode                                             **)
(** Classes       : TNetworkNode, implements INetworkNode                    **)
(******************************************************************************)
(** Dependencies  : RTL, WinSock                                             **)
(******************************************************************************)
(** Description   : Handles network nodes                                    **)
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

unit Obj.SSI.TNetworkNode;

interface

uses
    Obj.SSI.INetworkNode
  ;

type
  TNetworkNode = Class(TInterfacedObject, INetworkNode)
  private
    FNode: String;
    function HostToIP(const Hostname: AnsiString; var IP: AnsiString): Boolean;
    function IPToHost(const IP: AnsiString; var Hostname: AnsiString): Boolean;
  public
    constructor Create(Node: AnsiString);
    class function New(Node: AnsiString): INetworkNode;
    function IsIPv4Address: Boolean;
    function AsIPv4Address: AnsiString;
    function AsHostname: AnsiString;
    function IsPortOpen(const Port: Word): Boolean;
  End;

implementation

uses
    SysUtils
  , WinAPI.WinSock
  ;

{ TNetworkNode }

function TNetworkNode.HostToIP(const Hostname: AnsiString; var IP: AnsiString): Boolean;
var
  aHostName: Array [0..255] of AnsiChar;
  pcAddr   : PAnsiChar;
  HostEnt  : PHostEnt;
  wsData   : TWSAData;
begin
  WSAStartup($0101, wsData);
  try
    GetHostName(aHostName, SizeOf(aHostName));
    StrPCopy(aHostName, Hostname);
    HostEnt := GetHostByName(aHostName);
    if Assigned(HostEnt)
      then if Assigned(HostEnt^.H_Addr_List)
             then begin
                    pcAddr := HostEnt^.H_Addr_List^;
                    if Assigned(pcAddr)
                      then begin
                             IP     := Format('%d.%d.%d.%d', [Byte(pcAddr[0]), Byte(pcAddr[1]), Byte(pcAddr[2]), Byte(pcAddr[3])]);
                             Result := True;
                           end
                      else Result := False;
                  end
             else Result := False
      else Result := False;
  finally
    WSACleanup;
  end;
end;

function TNetworkNode.AsHostname: AnsiString;
begin
  if not IsIPv4Address
    then Result := FNode
    else if not IPToHost(FNode, Result)
           then raise Exception.Create('Failed to obtain node''s hostname.');
end;

function TNetworkNode.AsIPv4Address: AnsiString;
begin
  if IsIPv4Address
    then Result := FNode
    else if not HostToIP(FNode, Result)
           then raise Exception.Create('Failed to obtain node''s IP address.');
end;

constructor TNetworkNode.Create(Node: AnsiString);
begin
  FNode := Node;
end;

function TNetworkNode.IPToHost(const IP: AnsiString; var Hostname: AnsiString): Boolean;
var
  SockAddrIn : TSockAddrIn;
  HostEnt    : PHostEnt;
  WSAData    : TWSAData;
begin
  Result := False;
  WSAStartup($101, WSAData);
  try
    SockAddrIn.sin_addr.s_addr := inet_addr(PAnsiChar(IP));
    HostEnt:= GetHostByAddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
    if HostEnt <> nil
       then begin
              Hostname := StrPas(Hostent^.h_name);
              Result   := True;
            end;
  finally
    WSACleanup;
  end;
end;

function TNetworkNode.IsIPv4Address: Boolean;
var
  i           : Integer;
  GroupLength : Integer;
  GroupCount  : Integer;
  GroupValue  : Integer;
  ErrCode     : Integer;
begin
  Result      := False;
  GroupCount  := 0;
  GroupLength := 0;
  for i := 1 to FNode.Length do
    case FNode[i] of
      '0'..'9': begin
                  Inc(GroupLength);
                  if (GroupLength > 3)
                    then Exit;
                end;
      '.'     : begin
                  Inc(GroupCount);
                  Val(Copy(FNode, i - GroupLength, GroupLength), GroupValue, ErrCode);
                  if ((GroupCount > 3) or (GroupLength = 0)) or (GroupValue > 255)
                    then Exit;
                  GroupLength := 0;
                end;
    else Exit;
    end;
  Val(Copy(FNode, i - GroupLength, GroupLength), GroupValue, ErrCode);
  Result := (GroupCount = 3) and (GroupLength > 0) and (GroupValue < 256);
end;

function TNetworkNode.IsPortOpen(const Port: Word): Boolean;
var
  Client : SockAddr_In;
  Sock   : Integer;
  WSData : WSAData;
begin
  WSAStartup($0002, WSData);                                              // Initiates use of the Winsock DLL
  try
    Client.sin_family      := AF_INET;                                    // Set the protocol to use , in this case (IPv4)
    Client.sin_port        := htons(Port);                                // Convert to TCP/IP network byte order (big-endian)
    Client.sin_addr.s_addr := inet_addr(PAnsiChar(AsIPv4Address));        // Convert to IN_ADDR  structure
    Sock                   := Socket(AF_INET, SOCK_STREAM, 0);            // Creates a socket
    Result                 := Connect(Sock, Client, SizeOf(Client)) = 0;  // Establishes a connection to a specified socket
  finally
    WSACleanup;
  end;
end;

class function TNetworkNode.New(Node: AnsiString): INetworkNode;
begin
  Result := Create(Node);
end;

end.