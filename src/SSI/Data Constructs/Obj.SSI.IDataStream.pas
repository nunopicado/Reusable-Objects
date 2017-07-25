unit Obj.SSI.IDataStream;

interface

uses
    Classes
  ;

type
  IDataStream = interface
    function Save(const Stream: TStream): IDataStream; Overload;
    function Save(const Strings: TStrings): IDataStream; Overload;
    function Save(const FileName: string): IDataStream; Overload;
    function AsString: String;
    function Size: Int64;
  end;

implementation

end.
