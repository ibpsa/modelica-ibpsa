within IBPSA.Experimental.Pipe.BaseClasses;
partial record PipeData
  "Contains pipe properties for single pipes from catalogs"

  parameter Modelica.SIunits.Length Di=0.1 "Equivalent inner diameter";
  parameter Modelica.SIunits.Length Do=Di "Equivalent outer diameter";

  parameter Modelica.SIunits.ThermalConductivity lambdaI=0.028
    "Thermal conductivity of pipe insulation material";
  parameter Modelica.SIunits.ThermalConductivity lambdaG=1
    "Thermal conductivity of ground layers";
  parameter Modelica.SIunits.ThermalConductivity lambdaGS=14.6
    "Equivalent conductivity of ground surface";

  // Added this for wall capacity calculations.
  // The given inner diameter reflects the inner diameter of the insulation
  // layer, not the nominal diameter (which is approx. Di-2s).
  parameter Modelica.SIunits.Length s=0.0032
    "Inner wall thickness of pipe (inside of Di)";
  parameter Modelica.SIunits.SpecificHeatCapacity cW=490
    "Inner wall thermal capacity";

  parameter Modelica.SIunits.Density rhoW=7850 "Density of wall material";
  final parameter Modelica.SIunits.Area areaW=Modelica.Constants.pi*(ri^2 - (ri
       - s)^2) "Cross-section of inner pipe wall";
  final parameter IBPSA.Experimental.Pipe.Types.ThermalCapacityPerLength CW=
      areaW*rhoW*cW "Thermal capacity per length of inner wall";

  parameter Modelica.SIunits.Length H=2 "Buried depth of pipe";
  final parameter Modelica.SIunits.Length Heff=H + lambdaI/lambdaGS
    "Effective buried depth, corrected for ground conductivity";

  final parameter Modelica.SIunits.Length ro=Do/2 "Equivalent outer radius";
  final parameter Modelica.SIunits.Length ri=Di/2 "Equivalent inner radius";

  // h calculation
  final parameter Real hInvers=lambdaI/lambdaG*Modelica.Math.log(2*Heff/ro) +
      Modelica.Math.log(ro/ri);

  annotation (Icon(graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name"),
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(points={{-100,0},{100,0}}, color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}), Documentation(revisions="<html>
<ul>
<li>August 16, 2016 by Bram van der Heijde: <br>Added parameter for wall capacity calculation</li>
<li>July 18, 2016 by Bram van der Heijde: <br>First implementation</li>
</ul>
</html>", info="<html>
<p>Basic record structure for single pipe dimensions and insulation parameters.</p>
<p>The inner wall parameters are for a steel pipe wall. Another extend should be made for the case of plastic pipes, where these parameters are overridden. </p>
</html>"));
end PipeData;
