within IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield;
record Example
  "Example definition of a borefield data record"
  extends
    IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield.Template(
      filDat=IBPSA.Fluid.HeatExchangers.Ground.Data.Filling.Bentonite(),
      soiDat=IBPSA.Fluid.HeatExchangers.Ground.Data.Soil.SandStone(),
      conDat=IBPSA.Fluid.HeatExchangers.Ground.Data.Configuration.Example());
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>This record presents an example on how to define borefield records
using the template in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield.Template\">
IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield.Template</a>.</p>
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
