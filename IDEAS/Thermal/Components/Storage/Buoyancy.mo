within IDEAS.Thermal.Components.Storage;
model Buoyancy
  "Model to add buoyancy if there is a temperature inversion in the tank"
  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the tank";
  parameter SI.Length h "Total tank height";
  parameter Integer nbrNodes(min=2) = 2 "Number of tank nodes";
  parameter SI.Area surCroSec "Cross section surface of the tank";
  parameter SI.ThermalConductivity lamBuo(min=0)
    "Equivalent thermal conductivity for buoancy mixing";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nbrNodes] heatPort
    "Heat input into the volumes"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));

  Modelica.SIunits.HeatFlowRate[nbrNodes-1] Q_flow
    "Heat flow rate from segment i+1 to i";

equation
  for i in 1:nbrNodes-1 loop
    Q_flow[i] = lamBuo * surCroSec * max(heatPort[i+1].T-heatPort[i].T, 0) / (h/nbrNodes);
  end for;

  heatPort[1].Q_flow = -Q_flow[1];
  for i in 2:nbrNodes-1 loop
       heatPort[i].Q_flow = -Q_flow[i]+Q_flow[i-1];
  end for;
  heatPort[nbrNodes].Q_flow = Q_flow[nbrNodes-1];
  annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
October 28, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,68},{36,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-26},{38,-66}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,10},{32,-22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{28,22},{22,10},{36,10},{36,10},{28,22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,22},{-26,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics));
end Buoyancy;
