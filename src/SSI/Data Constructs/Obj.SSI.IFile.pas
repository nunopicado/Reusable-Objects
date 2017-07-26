unit Obj.SSI.IFile;

interface

uses
    Obj.SSI.IDataStream
  , Obj.SSI.IValue
  ;

type
  IFile = interface
  ['{22841154-9E5C-4D64-8780-5FA2C29B4988}']
    function Size: Int64;
    function Created: TDateTime;
    function Modified: TDateTime;
    function Accessed: TDateTime;
    function Version(const Full: Boolean = True): IString;
    function AsDataStream: IDataStream;
  end;

implementation

end.
