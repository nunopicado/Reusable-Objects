unit Obj.SSI.INetworkNode;

interface

type
  INetworkNode = Interface
    function IsIPv4Address: Boolean;
    function AsIPv4Address: AnsiString;
    function AsHostname: AnsiString;
    function IsPortOpen(const Port: Word): Boolean;
  end;

implementation

end.
