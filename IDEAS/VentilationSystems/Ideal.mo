within IDEAS.VentilationSystems;
model Ideal
  "Ventilation with constant air flow at constant temperature and no power calculations"
  extends IDEAS.Interfaces.BaseClasses.VentilationSystem(nLoads=1);
  parameter Modelica.SIunits.MassFlowRate m_flow[nZones] = zeros(nZones)
    "Ventilation mass flow rate per zones";
  parameter Modelica.SIunits.Temperature TSet[nZones] = 22*.ones(nZones) .+ 273.15
    "Ventilation set point temperature per zone";

  Fluid.Sources.MassFlowSource_T sou[nZones](
    each use_m_flow_in=true,
    each final nPorts=1,
    redeclare each package Medium = Medium,
    each use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{-60,10},{-80,30}})));
  Fluid.Sources.FixedBoundary sink[nZones](
                         each final nPorts=1, redeclare each package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-30},{-80,-10}})));
  Modelica.Blocks.Sources.Constant m_flow_val[nZones](final k=m_flow)
    annotation (Placement(transformation(extent={{-20,36},{-40,56}})));
  Modelica.Blocks.Sources.Constant TSet_val[nZones](final k=TSet)
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));
equation
  wattsLawPlug.P = zeros(nLoads);
  wattsLawPlug.Q = zeros(nLoads);

  connect(flowPort_Out[:], sou[:].ports[1]);
  connect(flowPort_In[:], sink[:].ports[1]);

  connect(sou.m_flow_in, m_flow_val.y) annotation (Line(
      points={{-60,28},{-46,28},{-46,46},{-41,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet_val.y, sou.T_in) annotation (Line(
      points={{-41,10},{-46,10},{-46,24},{-58,24}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Ideal;
