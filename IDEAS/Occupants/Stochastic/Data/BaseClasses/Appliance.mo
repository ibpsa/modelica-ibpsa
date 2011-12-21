within IDEAS.Occupants.Stochastic.Data.BaseClasses;
record Appliance

extends Modelica.Icons.MaterialProperty;

parameter Real nCycle "Mean number of cycles per year";
parameter Real lengthCycle "Mean cycle length";
parameter Real powerCycle "Mean cycle power";
parameter Real powerStandby "Mean standby power";
parameter Real cal "calibration scalar";
parameter Real owner "average ownership";
parameter Real consumptionYear "target average year consumption, kWh/y";
parameter Real delay "restart delay in minutes";
parameter Integer profile "required activity";

parameter Real frad;
parameter Real fconv;

/*
  profile : 
  
  0 = none;
  1 = BWF.Bui.ActLib.ActTV actTV;
  2 = BWF.Bui.ActLib.ActCooking actCooking;
  3 = BWF.Bui.ActLib.ActLaundry actLaundry;
  4 = BWF.Bui.ActLib.ActWashDress actWashDress;
  5 = BWF.Bui.ActLib.ActIron actIron;
  6 = BWF.Bui.ActLib.ActHouseClean actHouseClean;
  
  99 = occupancy;
  
*/

end Appliance;
