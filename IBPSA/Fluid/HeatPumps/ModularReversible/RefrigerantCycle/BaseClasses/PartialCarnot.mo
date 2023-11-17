within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialCarnot
  "Model with components for carnot efficiency calculation"
  parameter Boolean useForChi "=false to use in heat pump models";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon
    "Condenser medium specific heat capacity, used for pinch assumption";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva
    "Evaporator medium specific heat capacity, used for pinch assumption";
  parameter Real quaGra=0.3 "Constant quality grade";
  parameter Boolean use_constAppTem=false
    "=true to fix approach temperatures at nominal values. This can improve simulation speed";
  parameter Modelica.Units.SI.TemperatureDifference TAppCon_nominal(min=0)=
    if cpCon < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in condenser"
    annotation (Dialog(group="Efficiency"));

  parameter Modelica.Units.SI.TemperatureDifference TAppEva_nominal(min=0)=
      if cpCon < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in evaporator"
    annotation (Dialog(group="Efficiency"));
  parameter Modelica.Units.SI.TemperatureDifference dTCarMin=5
    "Minimal temperature difference, used to avoid division errors"
     annotation(Dialog(tab="Advanced"));
  Modelica.Blocks.Sources.RealExpression reaEtaCarEff(final y=quaGra*TUseSidAct/
        IBPSA.Utilities.Math.Functions.smoothMax(
        x1=dTCarMin,
        x2=(TConAct - TEvaAct),
        deltaX=0.25)) "Internal calculation of carnot efficiency"
    annotation (Placement(transformation(extent={{-90,38},{-70,58}})));
  Modelica.Blocks.Math.Product proQUse_flow "Calculate QUse_flow" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,40})));
  Modelica.Blocks.Math.Product proPEle "Calculate electrical power consumption" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
  Modelica.Blocks.Sources.Constant constPEle
    "Constant electrical power consumption" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
  Modelica.Blocks.Routing.RealPassThrough pasThrYSet "ySet from signal bus"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Units.SI.Temperature TUseSidAct = if useForChi then TEvaAct else TConAct
    "Useful side refrigerant temperature";
  Modelica.Units.SI.Temperature TConAct = pasThrTCon.y + TAppCon
    "Refrigerant condensation temperature";
  Modelica.Units.SI.Temperature TEvaAct = pasThrTEva.y - TAppEva
    "Refrigerant evaporation temperature";
  Modelica.Units.SI.TemperatureDifference TAppCon = if use_constAppTem then TAppCon_nominal
      else TAppCon_nominal * QCon_flow_internal/QCon_flow_nominal
      "Condenser approach temperature";
  Modelica.Units.SI.TemperatureDifference TAppEva = if use_constAppTem then TAppEva_nominal
      else TAppEva_nominal * QEva_flow_internal/QEva_flow_nominal
      "Evaporator approach temperature ";
  Modelica.Blocks.Sources.Constant constZer(final k=0)
    "Constant zero value if off" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Modelica.Blocks.Logical.Switch swiPEle
    "If device is off, no heat exchange occurs" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,10})));
  Modelica.Blocks.Logical.Switch swiQUse
    "If device is off, no heat exchange occurs" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,10})));

  Modelica.Blocks.Routing.RealPassThrough pasThrTEva
    "Evaporator outlet pass through" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,78})));
  Modelica.Blocks.Routing.RealPassThrough pasThrTCon
    "Condenser outlet pass through" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,78})));
protected
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal
    "Nominal condenser heat flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal
    "Nominal evaporator heat flow rate";
  Modelica.Units.SI.HeatFlowRate QCon_flow_internal = if useForChi then
    swiPEle.y + swiQUse.y else swiQUse.y
    "Condenser heat flow rate";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal = if useForChi then
    swiQUse.y else swiQUse.y - swiPEle.y
     "Evaporator heat flow rate";

equation
  connect(reaEtaCarEff.y, proQUse_flow.u2) annotation (Line(points={{-69,48},{-64,
          48},{-64,56},{-56,56},{-56,52}},
                                  color={0,0,127}));
  connect(proPEle.y, proQUse_flow.u1) annotation (Line(points={{70,39},{70,38},{
          -34,38},{-34,56},{-44,56},{-44,52}}, color={0,0,127}));
  connect(proPEle.u1, constPEle.y) annotation (Line(points={{76,62},{76,72},{90,
          72},{90,79}}, color={0,0,127}));
  connect(pasThrYSet.y, proPEle.u2)
    annotation (Line(points={{41,70},{64,70},{64,62}}, color={0,0,127}));
  connect(constZer.y, swiPEle.u3) annotation (Line(points={{8.88178e-16,21},{
          8.88178e-16,28},{42,28},{42,22}}, color={0,0,127}));
  connect(proPEle.y, swiPEle.u1) annotation (Line(points={{70,39},{70,34},{58,
          34},{58,22}}, color={0,0,127}));
  connect(proQUse_flow.y, swiQUse.u1) annotation (Line(points={{-50,29},{-50,28},
          {-58,28},{-58,22}}, color={0,0,127}));
  connect(swiQUse.u3, constZer.y) annotation (Line(points={{-42,22},{-42,28},{
          8.88178e-16,28},{8.88178e-16,21}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>
  Partial model for equations and componenents used in both heat pump
  and chiller with the Carnot approach.
</p>
</html>", revisions="<html>
<ul><li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li></ul>
</html>"));
end PartialCarnot;
