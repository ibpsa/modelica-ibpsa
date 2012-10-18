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
          fillPattern=FillPattern.Solid)}));
end MixingVolume;
