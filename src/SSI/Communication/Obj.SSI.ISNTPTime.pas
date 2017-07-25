unit Obj.SSI.ISNTPTime;

interface

uses
    Obj.SSI.IDate
  ;

type
  TSPBehavior   = (spThrowException, spReturnCurrentDate);

  ISNTPTime = interface
  ['{BFE1C861-89E5-4F8C-B0B1-3CEA18845737}']
    function Now: IDate;
  end;

implementation

end.
