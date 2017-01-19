within IDEAS.Templates.BaseCircuits.BaseClasses;
partial model FourPort
  parameter Boolean enableFourPort1 = true;
  parameter Boolean enableFourPort2 = true;

  FluidTwoPort fluidTwoPort1(redeclare package Medium = Medium) if not enableFourPort1 annotation (
    Placement(transformation(extent={{100,100},{100,100}}), iconTransformation(
          extent={{-20,80},{20,120}})));
  FluidTwoPort fluidTwoPort2(redeclare package Medium = Medium) if not enableFourPort2
    annotation (Placement(transformation(extent={{100,100},{100,100}}),iconTransformation(extent={{-20,
            -120},{20,-80}})));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1 if enableFourPort1
    annotation (Placement(transformation(extent={{100,100},{100,100}}),
        iconTransformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1 if enableFourPort1
    annotation (Placement(transformation(extent={{100,100},{100,100}}),
        iconTransformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2 if enableFourPort2
    annotation (Placement(transformation(extent={{100,100},{100,100}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2 if enableFourPort2
    annotation (Placement(transformation(extent={{100,100},{100,100}}),
        iconTransformation(extent={{50,-110},{70,-90}})));
protected
  Modelica.Fluid.Interfaces.FluidPort_a port_A1
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_B1
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_A2
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_B2
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
equation
  connect(port_A1, port_a1);
  connect(port_A1, fluidTwoPort1.port_a);
  connect(port_B1, port_b1);
  connect(port_B1, fluidTwoPort1.port_b);
  connect(port_A2, port_a2);
  connect(port_A2, fluidTwoPort2.port_a);
  connect(port_B2, port_b2);
  connect(port_B2, fluidTwoPort2.port_b);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>By convention the &apos;a&apos; side of the model and its connectors are used as the supply side (when appropriate).</p>
</html>", revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics));
end FourPort;
