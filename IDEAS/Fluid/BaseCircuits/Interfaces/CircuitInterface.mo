within IDEAS.Fluid.BaseCircuits.Interfaces;
partial model CircuitInterface "Partial circuit for base circuits"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);

  //Extensions
  extends IDEAS.Fluid.Interfaces.FourPort(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final allowFlowReversal1 = allowFlowReversal,
    final allowFlowReversal2 = allowFlowReversal);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  //Parameters

  //----Settings
  parameter Boolean includePipes=false
    "Set to true to include pipes in the basecircuit"
    annotation(Dialog(group = "Settings"));
  parameter Boolean measureSupplyT=false
    "Set to true to measure the supply temperature"
    annotation(Dialog(group = "Settings"));

  //----if includePipes
  parameter SI.Mass m=1 if includePipes
    "Mass of medium in the supply and return pipes"
    annotation(Dialog(group = "Pipes",
                     enable = includePipes));
  parameter SI.ThermalConductance UA=10
    "Thermal conductance of the insulation of the pipes"
    annotation(Dialog(group = "Pipes",
                     enable = includePipes));
  parameter Modelica.SIunits.Pressure dp=0 "Pressure drop over a single pipe"
    annotation(Dialog(group = "Pipes",
                     enable = includePipes));

  //----Fluid parameters
  parameter Boolean dynamicBalance=true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation(Dialog(tab="Dynamics", group="Equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  //Components
  FixedResistances.InsulatedPipe pipeSupply(
    UA=UA,
    m=m/2,
    dp_nominal=dp,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium) if includePipes
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,60})), choicesAllMatching=true);
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if includePipes
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  FixedResistances.InsulatedPipe pipeReturn(
    UA=UA,
    dp_nominal=dp,
    m=m/2,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium) if includePipes
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,-60})),                                            choicesAllMatching=true);
  Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal) if
                                       measureSupplyT
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Interfaces.RealOutput y if measureSupplyT annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={76,104})));
equation
  connect(port_a1, pipeSupply.port_a) annotation (Line(
      points={{-100,60},{-90,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.heatPort, heatPort) annotation (Line(
      points={{-80,56},{-80,-50},{-64,-50},{-64,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b2, pipeReturn.port_b) annotation (Line(
      points={{-100,-60},{-90,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeReturn.heatPort, heatPort) annotation (Line(
      points={{-80,-56},{-80,-50},{-64,-50},{-64,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, senTem.port_b) annotation (Line(
      points={{100,60},{80,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y, y) annotation (Line(
      points={{70,108},{70,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem.T, y) annotation (Line(
      points={{70,71},{70,108}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Placement(transformation(extent={{60,10},{80,30}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={135,135,135}),
                               Line(
          points={{-100,-60},{100,-60}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
                                   Line(
          points={{-100,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end CircuitInterface;
