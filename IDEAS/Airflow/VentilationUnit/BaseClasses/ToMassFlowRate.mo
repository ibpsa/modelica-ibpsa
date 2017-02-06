within IDEAS.Airflow.VentilationUnit.BaseClasses;
model ToMassFlowRate "Conversion of m3/s to kg/s"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  parameter Real frac = 1 "Correction factor on m_flow";
  Modelica.SIunits.Density rho = Medium.density(Medium.setState_pTX(Medium.p_default, T, Medium.X_default));
  Modelica.Blocks.Interfaces.RealInput V_flow
    annotation (Placement(transformation(extent={{-124,-60},{-84,-20}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealInput T
    annotation (Placement(transformation(extent={{-126,20},{-86,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=V_flow*rho*frac)
    annotation (Placement(transformation(extent={{-20,-10},{20,10}})));
equation
  connect(realExpression.y, m_flow) annotation (Line(
      points={{22,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ToMassFlowRate;
