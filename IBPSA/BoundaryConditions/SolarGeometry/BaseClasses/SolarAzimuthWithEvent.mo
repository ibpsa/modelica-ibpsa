within IBPSA.BoundaryConditions.SolarGeometry.BaseClasses;
function SolarAzimuthWithEvent "Determines solar azimuth with event"
  input Real solAziTem "Temporary solar azimuth";
  input Real solTim "Solar time";
  input Real day "Number of seconds in day";
  output Real solAzi "Solar azimuth";
algorithm
  if (solTim - integer(solTim/day)*day<43200) then
    solAzi := -solAziTem;
  else
    solAzi := solAziTem;
  end if;
  annotation (
    Documentation(info="<html>
<p>
This function is used within
<a href=\"modelica://IBPSA.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth\">
IBPSA.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth</a> 
to calculate solar azimuth with events.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2020 by David Blum:<br/>
Initial implementation.
This is for issue
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1373\">#1373</a>. 
</li>
</ul>
</html>"));
end SolarAzimuthWithEvent;
