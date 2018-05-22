within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data;
package FillingData "Library of Filling Data"
extends Modelica.Icons.Package;




  record SandBox_validation
    extends Template(
      k=0.73,
      d=2000,
      c=2000);

  end SandBox_validation;

annotation (Documentation(info="<html>
 <p>Library of Filling Data.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end FillingData;
