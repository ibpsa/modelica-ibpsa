within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData;
record SandBox_validation
  "SoilData record for the Beier et al. (2011) experiment"
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.Template(
    kSoi=2.82,
    cSoi=1500,
    dSoi=2000);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This record contains the soil data of the Beier et al.
(2011) experiment.</p>
<h4>References</h4>
<p>
Beier, R.A., Smith, M.D. and Spitler, J.D. 2011. <i>Reference data sets for
vertical borehole ground heat exchanger models and thermal response test
analysis</i>. Geothermics 40: 79-85.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end SandBox_validation;
