within IDEAS.Fluid.Production.BaseClasses;
record OnOffHeatPumpData "Data for an on/off heat pump"
  extends HeatPumpData;
  //zeros in powerData and copData indicate that this data is not available
  //or that the working point is outside of the working range of the device
  Modelica.SIunits.Power[:,:] powerData "Power map for the heat pump";
  Real[:,:] copData "Cop map for the heat pump";

  annotation (Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end OnOffHeatPumpData;
