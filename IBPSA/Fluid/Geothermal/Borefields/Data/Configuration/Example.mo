within IBPSA.Fluid.Geothermal.Borefields.Data.Configuration;
record Example
  "Example definition of a configuration data record"
  extends
    IBPSA.Fluid.Geothermal.Borefields.Data.Configuration.Template(
      borCon = Types.BoreholeConfiguration.SingleUTube,
      cooBor={{22.24,50.03},{17.21,46.06},{11.12,43.68},{4.76,43.68},{0,43.68}},
      mBor_flow_nominal=0.3,
      dp_nominal=5e4,
      hBor=100.0,
      rBor=0.075,
      dBor=1.0,
      rTub=0.02,
      kTub=0.5,
      eTub=0.002,
      xC=0.05);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="conDat",
    Documentation(
info="<html>
<p>
This record presents an example for how to define configuration data records
using the template in
<a href=\"modelica://IBPSA.Fluid.Geothermal.Borefields.Data.Configuration.Template\">
IBPSA.Fluid.Geothermal.Borefields.Data.Configuration.Template</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Example;
