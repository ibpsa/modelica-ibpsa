within IDEAS.Templates.Ventilation.Examples;
model none
parameter Boolean standAlone=true;

replaceable package Medium =      IDEAS.Media.Air;

  Buildings.Examples.BaseClasses.structure structure(redeclare package Medium
      = Medium)
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
