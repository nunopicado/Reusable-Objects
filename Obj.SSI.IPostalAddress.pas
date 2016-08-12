(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : IPostalAddress                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPostalAddress                                           **)
(** Classes       : TPostalAddress, implements IPostalAddress                **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles postal address values                            **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**                 terms													                           **)
(******************************************************************************)

unit Obj.SSI.IPostalAddress;

interface

uses
    Obj.SSI.IPostalCode
  , Obj.SSI.IGeoCoordinate
  ;

type
    IPostalAddress = interface ['{28E88EB6-F313-4D5D-9974-22C14F073D2C}']
      function ToString: String;
      function Address1: String;
      function Address2: String;
      function PostalCode: IPostalCode;
      function City: String;
      function Region: String;
      function Country: String;
      function Latitude: IGeoCoordinate;
      function Longitude: IGeoCoordinate;
    end;

    TPostalAddress = class(TInterfacedObject, IPostalAddress)
    private
      FAddress1: String;
      FAddress2: String;
      FPostalCode: IPostalCode;
      FCity: String;
      FRegion: String;
      FCountry: String;
      FLatitude: IGeoCoordinate;
      FLongitude: IGeoCoordinate;
    public
      constructor Create(Address1, Address2: String; PostalCode: IPostalCode; City, Region, Country: String; Latitude, Longitude: IGeoCoordinate); Overload;
      class function New(Address1, Address2: String; PostalCode: IPostalCode; City, Region, Country: String; Latitude, Longitude: IGeoCoordinate): IPostalAddress; Overload;
      class function New(Address1, Address2: String; PostalCode: IPostalCode; City, Region, Country: String): IPostalAddress; Overload;
      function ToString: String;
      function Address1: String;
      function Address2: String;
      function PostalCode: IPostalCode;
      function City: String;
      function Region: String;
      function Country: String;
      function Latitude: IGeoCoordinate;
      function Longitude: IGeoCoordinate;
    end;

implementation

uses
    SysUtils;

{ TMailAddress }

function TPostalAddress.Address1: String;
begin
     Result := FAddress1;
end;

function TPostalAddress.Address2: String;
begin
     Result := FAddress2;
end;

function TPostalAddress.City: String;
begin
     Result := FCity;
end;

function TPostalAddress.Country: String;
begin
     Result := FCountry;
end;

constructor TPostalAddress.Create(Address1, Address2: String; PostalCode: IPostalCode; City, Region, Country: String; Latitude, Longitude: IGeoCoordinate);
begin
     inherited Create;
     FAddress1   := Address1;
     FAddress2   := Address2;
     FPostalCode := PostalCode;
     FCity       := City;
     FRegion     := Region;
     FCountry    := Country;
     FLatitude   := Latitude;
     FLongitude  := Longitude;
end;

function TPostalAddress.ToString: String;
begin
     Result := FAddress1 + #13#10 +
               FAddress2 + #13#10 +
               FPostalCode.ToString + ' ' + FCity + #13#10 +
               FRegion + ' - ' + FCountry;
end;

class function TPostalAddress.New(Address1, Address2: String; PostalCode: IPostalCode; City, Region, Country: String; Latitude, Longitude: IGeoCoordinate): IPostalAddress;
begin
     Result := Create(Address1, Address2, PostalCode, City, Region, Country, Latitude, Longitude);
end;

function TPostalAddress.Latitude: IGeoCoordinate;
begin
     Result := FLatitude;
end;

function TPostalAddress.Longitude: IGeoCoordinate;
begin
     Result := FLongitude;
end;

class function TPostalAddress.New(Address1, Address2: String; PostalCode: IPostalCode; City, Region, Country: String): IPostalAddress;
begin
     Result := Create(Address1, Address2, PostalCode, City, Region, Country, nil, nil);
end;

function TPostalAddress.PostalCode: IPostalCode;
begin
     Result := FPostalCode;
end;

function TPostalAddress.Region: String;
begin
     Result := FRegion;
end;

end.
