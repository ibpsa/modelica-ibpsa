within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data;
package SoilData "Library of Soil Data"
extends Modelica.Icons.Package;




  record SandBox_validation
    "Soil properties for bore field validation using thermal response test of the Sand box Experiment"
    extends Template(
      k=2.8,
      c=1600,
      d=2000);

  end SandBox_validation;

annotation (Documentation(info="<html>
 <p>Library of Soil Data.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end SoilData;
