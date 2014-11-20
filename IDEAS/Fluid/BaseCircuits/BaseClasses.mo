within IDEAS.Fluid.BaseCircuits;
package BaseClasses
  extends Modelica.Icons.BasesPackage;
  connector FluidTwoPort "For automatically connecting supply and return pipes"
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium model" annotation (choicesAllMatching=true);

    Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium);
    Modelica.Fluid.Interfaces.FluidPort_a port_b(redeclare package Medium=Medium);

    annotation (Icon(graphics={             Ellipse(
            extent={{-100,50},{0,-50}},
            lineColor={0,0,0},
            fillColor={0,127,255},
            fillPattern=FillPattern.Solid), Ellipse(
            extent={{0,50},{100,-50}},
            lineColor={0,0,0},
            fillColor={0,127,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{8,42},{92,-42}},
            lineColor={0,127,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end FluidTwoPort;

  partial model TwoPort

    FluidTwoPort fluidTwoPort_a(redeclare package Medium = Medium) annotation (
        Placement(transformation(extent={{10,90},{-10,110}}), iconTransformation(
            extent={{-10,90},{10,110}})));
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium in the component"
      annotation (__Dymola_choicesAllMatching=true);
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Nominal mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
      "Small mass flow rate for regularization of zero flow"
      annotation(Dialog(tab = "Advanced"));

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end TwoPort;

  partial model FourPort

    FluidTwoPort fluidTwoPort_a(redeclare package Medium = Medium) annotation (
        Placement(transformation(extent={{10,90},{-10,110}}), iconTransformation(
            extent={{-10,90},{10,110}})));
    FluidTwoPort fluidTwoPort_b(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium in the component"
      annotation (__Dymola_choicesAllMatching=true);
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Nominal mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
      "Small mass flow rate for regularization of zero flow"
      annotation(Dialog(tab = "Advanced"));

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end FourPort;

  partial model TwoPortComponent
    extends IDEAS.Fluid.BaseCircuits.BaseClasses.TwoPort;

    replaceable Interfaces.PartialTwoPortInterface partialTwoPortInterface
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  equation
    connect(partialTwoPortInterface.port_a, fluidTwoPort_a.port_a) annotation (
        Line(
        points={{-10,0},{-40,0},{-40,100},{0,100}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(partialTwoPortInterface.port_b, fluidTwoPort_a.port_b) annotation (
        Line(
        points={{10,0},{40,0},{40,100},{0,100}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end TwoPortComponent;
end BaseClasses;
