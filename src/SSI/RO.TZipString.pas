(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TZipString                                               **)
(**                 TUnZipString                                             **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : ZLib                                                     **)
(******************************************************************************)
(** Description   : Zips and unzips a string                                 **)
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

unit RO.TZipString;

interface

uses
    RO.IValue
  , RO.TString
  ;

type
  TZipString = class(TDecorableIString, IString)
  public
    function Value: string; override;
  end;

  TUnZipString = class(TDecorableIString, IString)
  public
    function Value: string; override;
  end;

implementation

uses
    Classes
  , ZLib
  ;

{ TZipString }

function TZipString.Value: string;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result    := '';
  strInput  := TStringStream.Create(FOrigin.Value);
  strOutput := TStringStream.Create;
  try
    Zipper := TZCompressionStream.Create(TCompressionLevel.clMax, strOutput);
    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result := strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

{ TUnZipString }

function TUnZipString.Value: string;
var
  strInput,
  strOutput : TStringStream;
  Unzipper  : TZDecompressionStream;
begin
  Result     := '';
  strInput   := TStringStream.Create(FOrigin.Value);
  strOutput  := TStringStream.Create;
  try
    Unzipper := TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, Unzipper.Size);
    finally
      Unzipper.Free;
    end;
    Result := strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

end.
