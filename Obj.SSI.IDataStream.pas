(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDataStream                                              **)
(** Framework     :                                                          **)
(** Developed by  : Marcos Douglas Santos, mild adaptation by Nuno Picado    **)
(******************************************************************************)
(** Interfaces    : IDataStream                                              **)
(** Classes       : TDataStream, implements IDataStream                      **)
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

unit Obj.SSI.IDataStream;

interface

uses
    Classes
  ;

type
    IDataStream = interface
      function Save(Stream: TStream): IDataStream; Overload;
      function Save(Strings: TStrings): IDataStream; Overload;
      function Save(const FileName: string): IDataStream; Overload;
      function AsString: String;
      function Size: Int64;
    end;

    TDataStream = class sealed(TInterfacedObject, IDataStream)
    strict private
      FStream: TMemoryStream;
    private
      constructor CreatePrivate(Stream: TStream); Overload;
      constructor CreatePrivate(const S: String); Overload;
    public
      constructor Create;
      class function New(Stream: TStream): IDataStream; Overload;
      class function New(const S: String): IDataStream; Overload;
      class function New(Strings: TStrings): IDataStream; Overload;
      class function New: IDataStream; Overload;
      destructor Destroy; Override;
      function Save(Stream: TStream): IDataStream; Overload;
      function Save(Strings: TStrings): IDataStream; Overload;
      function Save(const FileName: String): IDataStream; Overload;
      function AsString: String;
      function Size: Int64;
    end;

implementation

uses
    SysUtils
  ;

{ TDataStream }

constructor TDataStream.CreatePrivate(Stream: TStream);
begin
     inherited Create;
     FStream := TMemoryStream.Create;
     if Assigned(Stream)
        then FStream.LoadFromStream(Stream);
end;

constructor TDataStream.Create;
begin
     raise Exception.Create('TDataStream was meant to be used only in it''s interfaced version. Use New instead.');
end;

constructor TDataStream.CreatePrivate(const S: String);
var
   F: TStringStream;
begin
     F := TStringStream.Create(S);
     try
        CreatePrivate(F);
     finally
        F.Free;
     end;
end;

class function TDataStream.New(Stream: TStream): IDataStream;
begin
     Result := CreatePrivate(Stream);
end;

class function TDataStream.New(const S: String): IDataStream;
begin
     Result := CreatePrivate(S);
end;

class function TDataStream.New(Strings: TStrings): IDataStream;
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

destructor TDataStream.Destroy;
begin
     FStream.Free;
     inherited Destroy;
end;

function TDataStream.Save(Stream: TStream): IDataStream;
begin
     Result := Self;
     FStream.SaveToStream(Stream);
     Stream.Position := 0;
end;

function TDataStream.Save(Strings: TStrings): IDataStream;
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

function TDataStream.Save(const FileName: String): IDataStream;
begin
     Result := Self;
     FStream.SaveToFile(FileName);
end;

function TDataStream.AsString: String;
var
  SS: TStringStream;
begin
     if FStream <> nil
        then begin
                  SS := TStringStream.Create('');
                  try
                     SS.CopyFrom(FStream, 0);  // No need to position at 0 nor provide size
                     Result := SS.DataString;
                  finally
                     SS.Free;
                  end;
             end
        else Result := '';
end;

function TDataStream.Size: Int64;
begin
     Result := FStream.Size;
end;

end.
