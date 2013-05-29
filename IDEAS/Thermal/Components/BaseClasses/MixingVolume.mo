within IDEAS.Thermal.Components.BaseClasses;
model MixingVolume "Ideal mixing volume"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium();
  parameter Integer nbrPorts(min=2) = 2 "Number of fluid ports, min 2";
  parameter Modelica.SIunits.Mass m=1 "Mass of the mixing volume";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of the mass in the volume";
  Modelica.SIunits.Temperature T(start=TInitial)
    "Temperature of the fluid in the mixing volume";
  Modelica.SIunits.SpecificEnthalpy h=T*medium.cp
    "Specific enthalpy of the fluid in the mixing volume";

  Thermal.Components.Interfaces.FlowPort_a flowPorts[nbrPorts](each final
      medium=medium)
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

equation
  // mass balance
  sum(flowPorts.m_flow) = 0;

  // all pressures are equal
  for i in 2:nbrPorts loop
    flowPorts[i].p = flowPorts[1].p;
  end for;

  // energy balance
  sum(flowPorts.H_flow) = m * medium.cp * der(T);

  // enthalpy outflow
  for i in 1:nbrPorts loop
    flowPorts[i].H_flow = semiLinear(flowPorts[i].m_flow, flowPorts[i].h, h);
  end for;

  annotation (Icon(graphics={Ellipse(
          extent={{-90,78},{88,-92}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p><b>Description</b> </p>
<p>Component to mix different flows ideally. There are minimum two ports. If you want to mix two flows, three ports are needed.</p>
<p>Important: those ports cannot be connected together because they can be at different enthalpies. Therefore, an array of flowPorts is foreseen, of size <i>nbrPorts</i>.</p>
<p><br/><b>Assumptions and limitations </b></p>
<p><ol>
<li>Conservation of mass</li>
<li>No environmental heat exchange</li>
<li>The pressure at the flowPorts[1] is passed on to all other flowPorts[i]</li>
<li>This mixing volume has an internal mass m, and a first order differential equation is solved to compute the mixing temperature based on the enthalpy flows at each of the ports</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>choose how many different ports are needed (number of flows to be mixed + 1)</li>
<li>set the medium and internal volume m</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>None</p>
<p><h4>Example</h4></p>
<p>An example of the use of this model can be found in<a href=\"modelica://IDEAS.Thermal.Components.Examples.MixingVolume\"> IDEAS.Thermal.Components.Examples.MixingVolume</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>May 2013, Roel De Coninck, documentation</li>
<li>2010, Roel De Coninck, first version</li>
</ul></p>
</html>"));
end MixingVolume;
