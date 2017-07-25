unit Obj.SSI.Helpers;

interface

type
    THString = Record Helper for String
      function ToInteger: Integer;
      function Length: Integer;
    End;

implementation

uses
    SysUtils
  ;

{ THString }

function THString.Length: Integer;
begin
     Result := System.Length(Self);
end;

function THString.ToInteger: Integer;
begin
     Result := StrToInt(Self);
end;

end.
