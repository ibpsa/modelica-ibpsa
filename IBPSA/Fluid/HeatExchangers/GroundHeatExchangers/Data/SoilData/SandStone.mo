within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData;
record SandStone
  "SoilData records of sanstone heat transfer properties"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.Template(
    kSoi=2.8,
    dSoi=540,
    cSoi=1210);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This soil data record contains the heat transfer proeprties of
sandstone.</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end SandStone;
