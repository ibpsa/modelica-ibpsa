within IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses;
partial model PartialCarnot
  "Model with components for carnot efficiency calculation"

  parameter Real quaGra=0.3 "Constant quality grade";
  parameter Modelica.Units.SI.TemperatureDifference TAppCon_nominal(min=0)
    "Temperature difference between refrigerant and working fluid outlet in condenser"
    annotation (Dialog(group="Efficiency"));

  parameter Modelica.Units.SI.TemperatureDifference TAppEva_nominal(min=0)
    "Temperature difference between refrigerant and working fluid outlet in evaporator"
    annotation (Dialog(group="Efficiency"));
  parameter Modelica.Units.SI.TemperatureDifference dTCarMin=20
    "Minimal temperature difference, used to avoid division errors"
     annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Sources.RealExpression reaEtaCarEff(final y=quaGra*pasThrTUse.y
        *IBPSA.Utilities.Math.Functions.smoothMax(
        x1=dTCarMin,
        x2=(pasThrTUse.y - pasThrTNotUse.y),
        deltaX=0.25)) "Internal calculation of carnot efficiency"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Modelica.Blocks.Math.Product proQUse_flow "Calculate QUse_flow" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,50})));
  Modelica.Blocks.Math.Product proPEle "Calculate electrical power" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
  Modelica.Blocks.Sources.Constant constPel
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
  Modelica.Blocks.Routing.RealPassThrough pasThrTUse "TUse from bus"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,80})));
  Modelica.Blocks.Routing.RealPassThrough pasThrTNotUse
    "Other side, not TUse from bus" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,80})));
  Modelica.Blocks.Routing.RealPassThrough pasThrYSet "ySet from bus"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
equation
  connect(reaEtaCarEff.y, proQUse_flow.u2) annotation (Line(points={{-69,50},{-64,
          50},{-64,62},{-56,62}}, color={0,0,127}));
  connect(proPEle.y, proQUse_flow.u1) annotation (Line(points={{70,39},{70,34},{
          -10,34},{-10,66},{-44,66},{-44,62}}, color={0,0,127}));
  connect(proPEle.u1, constPel.y) annotation (Line(points={{76,62},{76,72},{90,72},
          {90,79}}, color={0,0,127}));
  connect(pasThrYSet.y, proPEle.u2)
    annotation (Line(points={{41,70},{64,70},{64,62}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCarnot;
