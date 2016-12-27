(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IClipboard                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IClipboard                                               **)
(** Classes       : TClipboard, implements IClipboard                        **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles clipboard value copying and pasting              **)
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

unit Obj.SSI.Clipboard;

interface

uses
    FMX.Platform
  ;

type
    IClipboard = interface
    ['{A047D2F2-A1CD-4611-8503-73C536AB5D47}']
      function Copy(Value: String): IClipboard;
      function Paste: String;
    end;

    TClipboard = Class(TInterfacedObject, IClipboard)
    private
      FClipboard: IFMXClipboardService;
      constructor Create;
    public
      class function New: IClipboard;
      function Copy(Value: String): IClipboard;
      function Paste: String;
    End;

implementation

uses
    SysUtils;

{ TClipboard }

constructor TClipboard.Create;
begin
     if not TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(FClipboard))
        then raise Exception.Create('Clipboard could not be accessed.');
end;

class function TClipboard.New: IClipboard;
begin
     Result := Create;
end;

function TClipboard.Paste: String;
begin
     Result := FClipboard.GetClipboard.ToString;
end;

function TClipboard.Copy(Value: String): IClipboard;
begin
     Result := Self;
     FClipboard.SetClipboard(Value);
end;

end.
