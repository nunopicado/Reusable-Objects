unit Obj.FMX.IClipboard;

interface

type
  IClipboard = interface
  ['{A047D2F2-A1CD-4611-8503-73C536AB5D47}']
    function Copy(Value: String): IClipboard;
    function Paste: String;
  end;

implementation

end.
