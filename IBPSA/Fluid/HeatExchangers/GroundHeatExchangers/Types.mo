within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type BoreholeConfiguration = enumeration(
      SingleUTube
    "Single U-Tube configuration",
      DoubleUTubeParallel
    "Double parallel U-Tube configuration: pipes connected in parallel",
      DoubleUTubeSeries
    "Double series U-Tube configuration: pipes connected in series")
  "Enumaration to define the borehole configurations"
  annotation (Documentation(info="<html>
<p>
Typedefinition for different ground heat exchangers.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  annotation (preferredView="info", Documentation(info="<html>
 <p>
 This package contains type definitions.
 </p>
 </html>"));
end Types;
