within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record ExampleConfigurationData
  "Example definition of a ConfigurationData record"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.Template(
    borCon = Types.BoreholeConfiguration.SingleUTube,
    nbBor=4,
    cooBor={{0,0},{0,6},{6,0},{6,6}},
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
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This record presents an example on how to define configuration data records
using the template in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.Template\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.Template</a>.</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExampleConfigurationData;
