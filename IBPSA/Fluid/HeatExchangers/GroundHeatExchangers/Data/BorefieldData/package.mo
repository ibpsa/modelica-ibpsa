within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data;
package BorefieldData "Collection of borefield data records"


  record SandBox_validation
    "Borefield data record for the Beier et al. (2011) experiment"
    extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template(
      filDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.SandBox_validation(),
      soiDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SandBox_validation(),
      conDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation());

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram( coordinateSystem(preserveAspectRatio=false)),
      Documentation(
  info="<html>
<p>This record contains the borefield data of the Beier et al.
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

annotation (Documentation(info="<html>
<p>This package contains data records for use with ground heat exchanger models
in <a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers</a>. The borefield data records
contain one of the
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData\">
ConfigurationData</a> records, one of the
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData\">
FillingData</a> records, and one of the
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData\">
SoilData</a> records</p>
</html>"));
end BorefieldData;
