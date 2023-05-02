within IBPSA.Fluid.HeatPumps.SafetyControls.Examples;
model OperationalEnvelope "Example for usage of operational envelope model"
  extends BaseClasses.PartialSafetyControlExample;
  extends Modelica.Icons.Example;
  IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope opeEnv(
    use_opeEnvFroRec=true,
    datTab=
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN255.Vitocal350BWH110
        (),
    tabUpp=[-40,60; 40,60]) "Safety control for operational envelope"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Pulse ySetPul(amplitude=1, period=50)
    "Pulse signal for ySet"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Pulse TConOutEmu(
    amplitude=40,
    period=20,
    offset=303.15) "Emulator for condenser outlet temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Pulse TEvaInEmu(
    amplitude=-10,
    period=15,
    offset=283.15) "Emulator for evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation
  connect(opeEnv.sigBus, sigBus) annotation (Line(
      points={{-2.5,2.9},{-50,2.9},{-50,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetPul.y, opeEnv.ySet) annotation (Line(points={{-79,30},{-8,30},{-8,
          12},{-3.6,12}}, color={0,0,127}));
  connect(hys.u, opeEnv.yOut) annotation (Line(points={{22,-50},{44,-50},{44,12},
          {23,12}}, color={0,0,127}));
  connect(opeEnv.yOut, yOut) annotation (Line(points={{23,12},{44,12},{44,-40},
          {110,-40}}, color={0,0,127}));
  connect(ySetPul.y, ySet) annotation (Line(points={{-79,30},{-8,30},{-8,40},{
          110,40}}, color={0,0,127}));
  connect(TConOutEmu.y, sigBus.TConOutMea) annotation (Line(points={{-79,-10},{
          -50,-10},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TEvaInEmu.y, sigBus.TEvaInMea) annotation (Line(points={{-79,-50},{
          -52,-50},{-52,-52},{-50,-52}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
<p>This example shows the usage and effect of the model <a href=\"IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope\">IBPSA.Fluid.HeatPumps.SafetyControls.OperationalEnvelope</a>.</p>
</html>"));
end OperationalEnvelope;
