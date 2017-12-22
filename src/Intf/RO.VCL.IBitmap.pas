(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IBitmap                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IBitmap                                                  **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : VCL                                                      **)
(******************************************************************************)
(** Description   : Represents a VCL Bitmap                                  **)
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

unit RO.VCL.IBitmap;

interface

uses
    Vcl.Graphics
  ;

type
  IBitmap = interface(IUnknown)
  ['{32F983D3-3F1A-4BF5-9296-B9B20969A409}']
    function AsBitmap: TBitmap;
  end;

implementation

end.
