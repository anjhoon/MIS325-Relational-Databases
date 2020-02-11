-- Andrew Chen, Raymond Li, Jessica Lee
-- MIS HW6

-- Q1
alter table street_cleaning add(
ZipCode varchar2(5));

Begin
update street_cleaning
set zipcode = substr(address, -5,5);

delete from street_cleaning where zipcode not like '94___' or zipcode is null;
end;

-- Q2

create or replace view RequestFreq_ByZip as
select count(request_type) as request_freq, zipcode
from street_cleaning
where request_type = 'HUMAN WASTE'
group by zipcode
order by request_type desc;

-- Q3

create or replace function Get_Lat
(
    GPS_Coordinate_param varchar2
)
return number
AS
    Lat_var number(20,11); 
Begin
    Lat_var := to_number(substr(GPS_Coordinate_param, 2, instr(GPS_Coordinate_param, ',')-2)); 
    Return Lat_var; 
End; 

create or replace function Get_Lon
(
    GPS_Coordinate_param varchar2
)
Return number
AS
    Lon_var number(20,11); 
Begin
    Lon_var := to_number(substr(GPS_Coordinate_param, instr(GPS_Coordinate_param, ',')+2, length(GPS_Coordinate_param) - instr(GPS_Coordinate_param, ' ')-1)); 
    Return Lon_var; 
End; 

set serveroutput on;
Declare
     GPS_Coordinate_var varchar2(255):='(37.77605168, -122.410395881)';
Begin
     DBMS_OUTPUT.put_line(Get_Lat(GPS_Coordinate_var)); 
     DBMS_OUTPUT.put_line(Get_Lon(GPS_Coordinate_var));  
End; 

-- Q4
CREATE OR REPLACE FUNCTION distance (Lat1_param NUMBER,
                                     Lon1_param NUMBER,
                                     Lat2_param NUMBER,
                                     Lon2_param NUMBER
                                     ) RETURN NUMBER IS
     EarthRadius NUMBER := 3963;
     DegToRad NUMBER := 57.29577951; 
 
BEGIN
RETURN(EarthRadius * ACOS((sin(Lat1_param/DegToRad) * SIN(Lat2_param/DegToRad)) + (COS(Lat1_param/DegToRad) * COS(Lat2_param/DegToRad) *COS(Lon2_param/DegToRad - Lon1_param/DegToRad))));
        
END;

CREATE OR REPLACE FUNCTION JudgeProximity 
(
    Lat1 Number,
    Lon1 Number,
    Lat2 Number,
    Lon2 Number,
    Radius_param Number
)     
RETURN NUMBER 
IS
Begin
    If distance(Lat1, Lon1, Lat2, Lon2) <= Radius_param Then
        Return 1; 
    ELsIF distance(Lat1, Lon1, Lat2, Lon2) > Radius_param Then
        Return 0; 
    End If; 
End; 

SET SERVEROUTPUT ON; 
Declare 
    LatVal_1 Number:= 37.7677; 
    LonVal_1 Number:= -122.4122;
    LatVal_2 Number:= 37.7678; 
    LonVal_2 Number:= -122.4122;
    RadVal Number := 0.5; 
    DistanceVal Number; 
    Proximity Number;
    
Begin
    DistanceVal:= distance(LatVal_1,LonVal_1,LatVal_2,LonVal_2);
    DBMS_OUTPUT.put_line(round(DistanceVal,3));
    Proximity:= JudgeProximity(LatVal_1,LonVal_1,LatVal_2,LonVal_2,RadVal);
    DBMS_OUTPUT.put_line(Proximity);
End; 

-- Q5

Create or replace Procedure Poop_Score
(
    Restaurant_Name_Param varchar2, 
    Radius_to_Restaurant number
)
IS   
    cursor PoopEvent_Cur IS
    select * 
    from street_cleaning
    where request_type = 'Human Waste'
    and GPS_coordinate is not null; --zipcode = (select distinct Business_postal_code from restaurant where Business_name = Restaurant_name_param); 
    event_row Street_Cleaning%ROWTYPE;
    Poop_Score_var number:= 0; 
    Restaurant_Coordinates varchar2(255);
    Latitude_1 Number(20,11); 
    Longitude_1 Number(20,11);
    Poop_Coordinates varchar2(255); 
    Latitude_2 Number(20,11); 
    Longitude_2 Number(20,11);  
    
Begin
    select distinct business_location 
    into Restaurant_Coordinates
    from Restaurant
    where business_name = restaurant_name_param;
    Latitude_1:= Get_lat(Restaurant_coordinates);
    Longitude_1:= Get_lon(Restaurant_coordinates);
    
    For event_row in PoopEvent_Cur Loop
        Poop_Coordinates:= event_row.GPS_coordinates; 
        Latitude_2:= Get_lat(Poop_coordinates);
        Longitude_2:= Get_lon(Poop_coordinates);
        If JudgeProximity(Latitude_1, Longitude_1, Latitude_2, Longitude_2, radius_to_restaurant) = 1 Then
            Poop_Score_var := Poop_Score_var+1; 
        End IF; 
    End Loop; 
    DBMS_OUTPUT.put_line(Poop_Score_var||' '||' times of historical request to clean poops within '||Radius_to_Restaurant||' miles around the restaurant.'); 
    IF Poop_Score_var >=100 Then 
        DBMS_OUTPUT.put_line('Watch out! Tons of poops!');
    End IF; 
    Exception
    When no_data_found Then 
        dbms_output.put_line('No Matches found for the Restaurant');
    When others Then
        dbms_output.put_line('Unexpected Error'); 
End; 

-- Q6
set serveroutput on;

call Poop_score('UNIMART', 0.5);
call Poop_score('UNIMART', 0.1);
call Poop_score('Press Club', 0.5);
call Poop_score('Press Club', 0.1);
call Poop_score('CAFE PICARO', 0.5);
call Poop_score('CAFE PICARO', 0.1);
call Poop_score('ABC', 0.5);
call Poop_score('ABC', 0.1);
