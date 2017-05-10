within IDEAS.Buildings.Components.Interfaces;
model DummyConnection "Source generator/sink for propsbus"
  parameter Boolean isZone = false "Set to true when connecting to a surface";
  parameter Real A=1 "Surface area"
    annotation(Dialog(enable=not isZone));
  parameter Modelica.SIunits.HeatFlowRate surfCon=0
    "Fixed heat flow rate for surfCon"
    annotation(Dialog(enable=not isZone));
  parameter Modelica.SIunits.HeatFlowRate iSolDir=0
    "Fixed heat flow rate for iSolDir"
    annotation(Dialog(enable=not isZone));
  parameter Modelica.SIunits.HeatFlowRate iSolDif=0
    "Fixed heat flow rate for iSolDif"
    annotation(Dialog(enable=not isZone));
  parameter Modelica.SIunits.Temperature T = 293.15 "Fixed temperature for surfRad, or zone when isZone";

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  IDEAS.Buildings.Components.Interfaces.ZoneBus zoneBus(
    outputAngles=sim.outputAngles,
    numIncAndAziInBus=sim.numIncAndAziInBus)
    annotation (Placement(transformation(extent={{80,-22},{120,18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow[3](
      Q_flow={surfCon,iSolDif,iSolDir}) if
                         not isZone
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Blocks.Sources.Constant area(k=A) if not isZone
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant eps(k=0.88) if not isZone
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Modelica.Blocks.Sources.Constant QTra(k=A) if not isZone
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Modelica.Blocks.Sources.Constant azi(k=IDEAS.Types.Azimuth.S) if      not isZone
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.Constant inc(k=IDEAS.Types.Tilt.Floor) if     not isZone
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=T)
    annotation (Placement(transformation(extent={{-70,-16},{-50,4}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow QGai(Q_flow=0) if
                         not isZone
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy.PrescribedEnergy
    prescribedEnergy if not isZone
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Constant zero(k=0) if not isZone
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(prescribedHeatFlow[1].port, zoneBus.surfCon) annotation (Line(
      points={{-50,20},{62,20},{62,-1.9},{100.1,-1.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow[2].port, zoneBus.iSolDir) annotation (Line(
      points={{-50,20},{58,20},{58,-1.9},{100.1,-1.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow[3].port, zoneBus.iSolDif) annotation (Line(
      points={{-50,20},{60,20},{60,-1.9},{100.1,-1.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eps.y, zoneBus.epsLw) annotation (Line(
      points={{21,90},{100.1,90},{100.1,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eps.y, zoneBus.epsSw) annotation (Line(
      points={{21,90},{100,90},{100,34},{100.1,34},{100.1,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(area.y, zoneBus.area) annotation (Line(
      points={{21,50},{100.1,50},{100.1,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QTra.y, zoneBus.QTra_design) annotation (Line(
      points={{21,10},{100.1,10},{100.1,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(azi.y, zoneBus.azi) annotation (Line(
      points={{21,-50},{100,-50},{100,-30},{100.1,-30},{100.1,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inc.y, zoneBus.inc) annotation (Line(
      points={{21,-90},{100.1,-90},{100.1,-1.9}},
      color={0,0,127},
      smooth=Smooth.None));
  if isZone then
  connect(sim.weaBus, zoneBus.weaBus) annotation (Line(
      points={{-84,32.8},{-40,32.8},{-40,-1.9},{100.1,-1.9}},
      color={255,204,51},
      thickness=0.5));
  end if;
  connect(fixedTemperature.port, zoneBus.surfRad) annotation (Line(points={{-50,-6},
          {-48,-6},{-48,-10},{-44,-10},{100.1,-10},{100.1,-1.9}},
                                        color={191,0,0}));
  if isZone then
    connect(fixedTemperature.port, zoneBus.surfCon) annotation (Line(points={{-50,
          -6},{100.1,-6},{100.1,-1.9}}, color={191,0,0}));
    connect(fixedTemperature.port, zoneBus.iSolDif) annotation (Line(points={{-50,-6},
          {-48,-6},{-48,-8},{100.1,-8},{100.1,-1.9}},
                                        color={191,0,0}));
    connect(fixedTemperature.port, zoneBus.iSolDir) annotation (Line(points={{-50,-6},
          {-48,-6},{-48,-4},{100,-4},{100,-1.9},{100.1,-1.9}},
                                               color={191,0,0}));
  end if;
  connect(QGai.port, zoneBus.Qgai) annotation (Line(points={{-20,-20},{100.1,-20},
          {100.1,-1.9}}, color={191,0,0}));
  connect(prescribedEnergy.port, zoneBus.E) annotation (Line(points={{-20,-40},{
          100.1,-40},{100.1,-1.9}}, color={0,0,0}));
  connect(zero.y, prescribedEnergy.E) annotation (Line(points={{-59,-40},{-49.5,
          -40},{-40,-40}}, color={0,0,127}));
  if isZone then
    connect(sim.E, zoneBus.E) annotation (Line(points={{-90,20},{-90,20},{-90,-2},
            {100.1,-2},{100.1,-1.9}},          color={0,0,0}));
    connect(sim.Qgai, zoneBus.Qgai) annotation (Line(points={{-90,20},{-90,20},{
            -90,-1.9},{100.1,-1.9}},    color={0,0,0}));
  end if;
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Line(
          points={{60,60},{-60,-60}},
          color={0,0,255},
          smooth=Smooth.None), Line(
          points={{-60,60},{60,-60}},
          color={0,0,255},
          smooth=Smooth.None)}));
end DummyConnection;
