unit RO.IMaybe;

interface

type
  IMaybe<T> = interface(IInvokable)
  ['{C584761B-78F3-42CC-86AF-DA3EC4978D6E}']
    function Value: T;
    function IsSet: Boolean;
  end;

implementation

end.
