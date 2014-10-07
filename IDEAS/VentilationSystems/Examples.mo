within IDEAS.VentilationSystems;
package Examples
  extends Modelica.Icons.ExamplesPackage;
  model constantAirFlowRecup
  parameter Boolean standAlone=true;

  replaceable package Medium =      IDEAS.Media.Air;

    Buildings.Examples.Structure structure(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-78,-40},{-48,-20}})));
    ConstantAirFlowRecup constantAirFlowRecup(
      nZones=3,
      VZones=structure.VZones,
      n=2.*structure.VZones,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
    Interfaces.BaseClasses.CausalInhomeFeeder       causalInhomeFeeder
      annotation (Placement(transformation(extent={{16,-10},{36,10}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(
      f=50,
      V=230,
      phi=0) if standAlone annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={58,-30})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground if
      standAlone
      annotation (Placement(transformation(extent={{48,-80},{68,-60}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
      plugFeeder(v(re(start=230), im(start=0))) if not standAlone
      "Electricity connection to the district feeder"
      annotation (Placement(transformation(extent={{78,-10},{98,10}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner SimInfoManager       sim
      "Simulation information manager for climate data"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  equation
      connect(voltageSource.pin_p,ground. pin) annotation (Line(
          points={{58,-40},{58,-60}},
          color={85,170,255},
          smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle,plugFeeder)  annotation (Line(
        points={{36,0},{88,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle,voltageSource. pin_n) annotation (Line(
        points={{36,0},{58,0},{58,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(constantAirFlowRecup.plugLoad, causalInhomeFeeder.nodeSingle)
      annotation (Line(
        points={{-8,0},{16,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(structure.flowPort_Out, constantAirFlowRecup.flowPort_In)
      annotation (Line(
        points={{-65,-20},{-66,-20},{-66,2},{-28,2}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(structure.flowPort_In, constantAirFlowRecup.flowPort_Out)
      annotation (Line(
        points={{-61,-20},{-60,-20},{-60,-2},{-28,-2}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(structure.TSensor, constantAirFlowRecup.TSensor) annotation (Line(
        points={{-47.4,-36},{-36,-36},{-36,-6},{-28.4,-6}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end constantAirFlowRecup;

  model none
  parameter Boolean standAlone=true;

  replaceable package Medium =      IDEAS.Media.Air;

    Buildings.Examples.Structure structure(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-78,-40},{-48,-20}})));
    None none(
      nZones=3,
      VZones=structure.VZones,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
    Interfaces.BaseClasses.CausalInhomeFeeder       causalInhomeFeeder
      annotation (Placement(transformation(extent={{16,-10},{36,10}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(
      f=50,
      V=230,
      phi=0) if standAlone annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={58,-30})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground if
      standAlone
      annotation (Placement(transformation(extent={{48,-80},{68,-60}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
      plugFeeder(v(re(start=230), im(start=0))) if not standAlone
      "Electricity connection to the district feeder"
      annotation (Placement(transformation(extent={{78,-10},{98,10}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner SimInfoManager       sim
      "Simulation information manager for climate data"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  equation
      connect(voltageSource.pin_p,ground. pin) annotation (Line(
          points={{58,-40},{58,-60}},
          color={85,170,255},
          smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle,plugFeeder)  annotation (Line(
        points={{36,0},{88,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle,voltageSource. pin_n) annotation (Line(
        points={{36,0},{58,0},{58,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(none.plugLoad, causalInhomeFeeder.nodeSingle) annotation (Line(
        points={{-8,0},{16,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(structure.flowPort_Out, none.flowPort_In) annotation (Line(
        points={{-65,-20},{-66,-20},{-66,2},{-28,2}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(structure.flowPort_In, none.flowPort_Out) annotation (Line(
        points={{-61,-20},{-60,-20},{-60,-2},{-28,-2}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(structure.TSensor, none.TSensor) annotation (Line(
        points={{-47.4,-36},{-36,-36},{-36,-6},{-28.4,-6}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end none;

  model none2
  parameter Boolean standAlone=true;

  replaceable package Medium =      IDEAS.Media.Air;

    Buildings.Examples.Structure structure(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-78,-40},{-48,-20}})));
    Ideal none(
      nZones=3,
      VZones=structure.VZones,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
    Interfaces.BaseClasses.CausalInhomeFeeder       causalInhomeFeeder
      annotation (Placement(transformation(extent={{16,-10},{36,10}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(
      f=50,
      V=230,
      phi=0) if standAlone annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={58,-30})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground if
      standAlone
      annotation (Placement(transformation(extent={{48,-80},{68,-60}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
      plugFeeder(v(re(start=230), im(start=0))) if not standAlone
      "Electricity connection to the district feeder"
      annotation (Placement(transformation(extent={{78,-10},{98,10}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner SimInfoManager       sim
      "Simulation information manager for climate data"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  equation
      connect(voltageSource.pin_p,ground. pin) annotation (Line(
          points={{58,-40},{58,-60}},
          color={85,170,255},
          smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle,plugFeeder)  annotation (Line(
        points={{36,0},{88,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle,voltageSource. pin_n) annotation (Line(
        points={{36,0},{58,0},{58,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(none.plugLoad, causalInhomeFeeder.nodeSingle) annotation (Line(
        points={{-8,0},{16,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(structure.flowPort_Out, none.flowPort_In) annotation (Line(
        points={{-65,-20},{-66,-20},{-66,2},{-28,2}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(structure.flowPort_In, none.flowPort_Out) annotation (Line(
        points={{-61,-20},{-60,-20},{-60,-2},{-28,-2}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(structure.TSensor, none.TSensor) annotation (Line(
        points={{-47.4,-36},{-36,-36},{-36,-6},{-28.4,-6}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end none2;

  model none3
    parameter Integer nZones = 3;

    replaceable package Medium =      IDEAS.Media.Air;

    Buildings.Examples.Structure structure(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-78,-40},{-48,-20}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner SimInfoManager       sim
      "Simulation information manager for climate data"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
    Fluid.Sources.MassFlowSource_T sou[nZones](
      each use_m_flow_in=true,
      each final nPorts=1,
      redeclare package Medium = Medium,
      each use_T_in=true) "Source"
      annotation (Placement(transformation(extent={{-4,32},{-24,52}})));
    Fluid.Sources.FixedBoundary sink[nZones](
                           each final nPorts=1, redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-4,-8},{-24,12}})));
    Modelica.Blocks.Sources.Constant TSet_val[nZones](each k=295.15)
      annotation (Placement(transformation(extent={{36,22},{16,42}})));
    Modelica.Blocks.Sources.Pulse    m_flow_val[nZones](amplitude=0.01, period=
          36000)
      annotation (Placement(transformation(extent={{46,68},{26,88}})));
  equation
    connect(TSet_val.y,sou. T_in) annotation (Line(
        points={{15,32},{10,32},{10,46},{-2,46}},
        color={0,0,127},
        smooth=Smooth.None));

      connect(structure.flowPort_In, sink[:].ports[1]) annotation (Line(
        points={{-61,-20},{-60,-20},{-60,2},{-24,2}},
        color={0,0,0},
        smooth=Smooth.None));
      connect(structure.flowPort_Out, sou[:].ports[1]) annotation (Line(
        points={{-65,-20},{-66,-20},{-66,42},{-24,42}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(m_flow_val.y, sou.m_flow_in) annotation (Line(
        points={{25,78},{8,78},{8,50},{-4,50}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end none3;

  model none4
    parameter Integer nZones = 3;

    replaceable package Medium =      Modelica.Media.Air.SimpleAir(T_min=273.15-50);

    Buildings.Examples.Structure structure(redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-78,-40},{-48,-20}})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner SimInfoManager       sim
      "Simulation information manager for climate data"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
    Fluid.Sources.MassFlowSource_T sou[nZones](
      each use_m_flow_in=true,
      each final nPorts=1,
      redeclare package Medium = Medium,
      each use_T_in=true) "Source"
      annotation (Placement(transformation(extent={{-4,32},{-24,52}})));
    Fluid.Sources.FixedBoundary sink[nZones](
                           each final nPorts=1, redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-4,-8},{-24,12}})));
    Modelica.Blocks.Sources.Pulse    m_flow_val[nZones](amplitude=0.01, period=
          36000)
      annotation (Placement(transformation(extent={{36,58},{16,78}})));
    Modelica.Blocks.Sources.Constant TSet_val[nZones](each k=295.15)
      annotation (Placement(transformation(extent={{36,22},{16,42}})));
  equation
    connect(sou.m_flow_in,m_flow_val. y) annotation (Line(
        points={{-4,50},{10,50},{10,68},{15,68}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(TSet_val.y,sou. T_in) annotation (Line(
        points={{15,32},{10,32},{10,46},{-2,46}},
        color={0,0,127},
        smooth=Smooth.None));

      connect(structure.flowPort_In, sink[:].ports[1]) annotation (Line(
        points={{-61,-20},{-60,-20},{-60,2},{-24,2}},
        color={0,0,0},
        smooth=Smooth.None));
      connect(structure.flowPort_Out, sou[:].ports[1]) annotation (Line(
        points={{-65,-20},{-66,-20},{-66,42},{-24,42}},
        color={0,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end none4;
end Examples;
