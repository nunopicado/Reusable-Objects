(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPrinters                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TPrinters                                                **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : WinSpool, VCL                                            **)
(******************************************************************************)
(** Description   : Represents the list of printers registered in the        **)
(**                 Windows Spooler. Can send direct escape sequences to a   **)
(**                 printer                                                  **)
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

unit RO.VCL.TPrinters;

interface

uses
    WinSpool
  , Spring.Collections
  , RO.IValue
  , RO.IPrinters
  , RO.IByteSequence
  ;

type
  TPrinters = class(TInterfacedObject, IPrinters)
  private var
    FSelected : string;
    FDocInfo1 : TDocInfo1;
  public
    constructor Create;
    class function New: IPrinters;
    function SendSequence(const Sequence: IByteSequence): IPrinters;
    function AsList: IEnumerable<string>;
    function Exists(const Name: string): Boolean;
    function Select(const Name: string): IPrinters;
    function Default: string;
  end;

implementation

uses
    SysUtils
  , Printers
  , RO.TValue
  , RO.TIf
  ;

constructor TPrinters.Create;
begin
  with FDocInfo1 do begin
    pDocName    := nil;
    pOutputFile := nil;
    pDataType   := 'RAW';
  end;
  if Exists(Default)
    then Select(Default);
end;

class function TPrinters.New: IPrinters;
begin
  Result := Create;
end;

function TPrinters.Select(const Name: string): IPrinters;
resourcestring
  cInvalidPrinter = 'Failed to find %s printer.';
begin
  Result := Self;
  if not Exists(Name)
    then raise Exception.Create(Format(cInvalidPrinter, [QuotedStr(Name)]));
  FSelected := Name;
end;

function TPrinters.SendSequence(const Sequence: IByteSequence): IPrinters;
var
  Handle : THandle;
  N      : Cardinal;
begin
  Result := Self;
  if not OpenPrinter(PChar(FSelected), Handle, nil)
    then raise exception.Create(Format('Failed opening printer: %d', [GetLastError]))
    else begin
      StartDocPrinter(Handle, 1, @FDocInfo1);
      WritePrinter(
        Handle,
        Pointer(Sequence.AsEnumerable.ToArray),
        Sequence.AsEnumerable.Count,
        N
      );
      EndDocPrinter(Handle);
      ClosePrinter(Handle);
    end;
end;

function TPrinters.AsList: IEnumerable<string>;
var
  List : IList<string>;
  i    : Integer;
begin
  List := TCollections.CreateList<string>;
  with Printer.Printers do
    for i := 0 to Pred(Count) do
      List.Add(ValueFromIndex[i]);
  Result := List;
end;

function TPrinters.Default: string;
begin
  Result := TIf<string>.New(
    Printer.PrinterIndex > 0,
    PChar(Printer.Printers[Printer.PrinterIndex]),
    ''
  ).Eval;
end;

function TPrinters.Exists(const Name: string): Boolean;
begin
  Result := Printer.Printers.IndexOfName(Name) <> -1;
end;

end.
