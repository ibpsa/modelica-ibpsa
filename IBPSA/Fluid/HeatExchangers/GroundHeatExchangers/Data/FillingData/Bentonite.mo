within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData;
record Bentonite
  "FillingData record of Bentonite heat transfer properties"
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Template(
    kFil=1.15,
    dFil=1600,
    cFil=800);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This filling data record contains the heat transfer properties of
bentonite.</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bentonite;
