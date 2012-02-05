within IDEAS.Buildings.Validation.BaseClasses;
package Occupants

    extends Modelica.Icons.Package;

  model Gain "BESTEST internal gains by occupants"
    extends IDEAS.Interfaces.Occupant;

    parameter Modelica.SIunits.HeatFlowRate Q = 200 "Baseload internal gain";

  algorithm
  for i in 1:nZones loop
    heatPortCon[i].Q_flow := - Q*0.40;
    heatPortRad[i].Q_flow := - Q*0.60;
  end for;

  end Gain;

end Occupants;
