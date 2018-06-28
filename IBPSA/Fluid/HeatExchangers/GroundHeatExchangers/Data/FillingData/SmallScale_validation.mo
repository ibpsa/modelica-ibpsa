within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData;
record SmallScale_validation
  "FillingData record for the Cimmino and Bernier (2015) experiment"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Template(
    kFil=0.262,
    dFil=1750,
    cFil=745);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This record contains the filling data of the Cimmino and
Bernier (2015) experiment.</p>
<h4>References</h4>
<p>
Cimmino, M. and Bernier, M. 2015. <i>Experimental determination of the
g-functions of a small-scale geothermal borehole</i>. Geothermics 56: 60-71.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmallScale_validation;
