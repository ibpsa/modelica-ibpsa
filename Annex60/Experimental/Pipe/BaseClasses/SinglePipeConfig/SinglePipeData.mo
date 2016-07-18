within Annex60.Experimental.Pipe.BaseClasses.SinglePipeConfig;
partial record SinglePipeData
  "Contains pipe properties for single pipes from catalogs"

  parameter Modelica.SIunits.Length Di=0.1 "Equivalent inner diameter";
  parameter Modelica.SIunits.Length Do=Di "Equivalent outer diameter";

  parameter Modelica.SIunits.ThermalConductivity lambdaI=0.028
    "Thermal conductivity of pipe insulation material";
  parameter Modelica.SIunits.ThermalConductivity lambdaG=2
    "Thermal conductivity of ground layers";
  parameter Modelica.SIunits.ThermalConductivity lambdaGS=14.6
    "Equivalent conductivity of ground surface";

  parameter Modelica.SIunits.Length H=2 "Buried depth of pipe";
  final parameter Modelica.SIunits.Length Heff=H + lambdaI/lambdaGS
    "Effective buried depth, corrected for ground conductivity";

  final parameter Modelica.SIunits.Length ro=Do/2 "Equivalent outer radius";
  final parameter Modelica.SIunits.Length ri=Di/2 "Equivalent inner radius";

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
        Line(
          points={{-100,0},{100,0}},
          color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}), Documentation(revisions="<html>
<ul>
<li>July 18, 2016 by Bram van der Heijde: <br>FIrst implementation</li>
</ul>
</html>", info="<html>
<p>Basic record structure for single pipe dimensions and insulation parameters.</p>
</html>"));
end SinglePipeData;
