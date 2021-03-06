(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDataStream                                              **)
(** Framework     :                                                          **)
(** Developed by  : Marcos Douglas Santos, mild adaptation by Nuno Picado    **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TDataStream                                              **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Holds a datastream, created from and saved to various    **)
(**                 formats                                                  **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit RO.TDataStream;

interface

uses
    Classes
  , RO.IDataStream
  , RO.IValue
  ;

type
  TDataStream = class sealed(TInterfacedObject, IDataStream)
  strict private
    FStream: TMemoryStream;
  public
    constructor Create(const Stream: TStream); overload;
    constructor Create(const S: string); overload;
    class function New(const Stream: TStream): IDataStream; overload;
    class function New(const S: string): IDataStream; overload;
    class function New(const S: IString): IDataStream; overload;
    class function New(const Strings: TStrings): IDataStream; overload;
    class function New: IDataStream; overload;
    destructor Destroy; override;
    function Save(const Stream: TStream): IDataStream; overload;
    function Save(const Strings: TStrings): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function Save(const FileName: IString): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

implementation

uses
    SysUtils
  ;

{ TDataStream }

constructor TDataStream.Create(const Stream: TStream);
begin
  inherited Create;
  FStream := TMemoryStream.Create;
  if Assigned(Stream)
    then FStream.LoadFromStream(Stream);
end;

constructor TDataStream.Create(const S: string);
var
  F: TStringStream;
begin
  F := TStringStream.Create(S);
  try
    Create(F);
  finally
    F.Free;
  end;
end;

class function TDataStream.New(const Stream: TStream): IDataStream;
begin
  Result := Create(Stream);
end;

class function TDataStream.New(const S: string): IDataStream;
begin
  Result := Create(S);
end;

class function TDataStream.New(const Strings: TStrings): IDataStream;
var
  Buf: TMemoryStream;
begin
  Buf := TMemoryStream.Create;
  try
    Strings.SaveToStream(Buf);
    Result := New(Buf);
  finally
    Buf.Free;
  end;
end;

class function TDataStream.New: IDataStream;
begin
  Result := New('');
end;

class function TDataStream.New(const S: IString): IDataStream;
begin
  Result := New(S.Value);
end;

destructor TDataStream.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

function TDataStream.Save(const Stream: TStream): IDataStream;
begin
  Result := Self;
  FStream.SaveToStream(Stream);
  Stream.Position := 0;
end;

function TDataStream.Save(const Strings: TStrings): IDataStream;
var
  Buf: TStream;
begin
  Result := Self;
  Buf := TMemoryStream.Create;
  try
    Save(Buf);
    Strings.LoadFromStream(Buf);
  finally
    Buf.Free;
  end;
end;

function TDataStream.Save(const FileName: string): IDataStream;
begin
  Result := Self;
  FStream.SaveToFile(FileName);
end;

function TDataStream.AsString: string;
var
  SS: TStringStream;
begin
  if FStream <> nil then begin
    SS := TStringStream.Create('');
    try
      SS.CopyFrom(FStream, 0);
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end
  else begin
    Result := '';
  end;
end;

function TDataStream.Save(const FileName: IString): IDataStream;
begin
  Result := Save(Filename.Value);
end;

function TDataStream.Size: Int64;
begin
  Result := FStream.Size;
end;

end.
