within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record SmallScale_validation
  "Borefield data record for the Cimmino and Bernier (2015) experiment"
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template(
      filDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.SmallScale_validation(),
      soiDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SmallScale_validation(),
      conDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SmallScale_validation());

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>
This record contains the borefield data of the Cimmino and
Bernier (2015) experiment.
</p>
<h4>References</h4>
<p>
Cimmino, M. and Bernier, M. 2015. <i>Experimental determination of the
g-functions of a small-scale geothermal borehole</i>. Geothermics 56: 60-71.
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
June 28, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmallScale_validation;
