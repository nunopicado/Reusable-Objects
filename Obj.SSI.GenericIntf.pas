unit Obj.SSI.GenericIntf;

interface

uses
    SysUtils;

type
    ESSIError = Class(Exception);

    I<T> = Interface                  ['{D6A7F28C-56D5-4D59-8C58-41489D9A3098}']
      function Obj: T;
    End;
	
implementation

end.