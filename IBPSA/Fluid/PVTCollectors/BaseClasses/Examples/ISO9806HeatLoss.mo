within IBPSA.Fluid.PVTCollectors.BaseClasses.Examples;
model ISO9806HeatLoss "Example showing the use of ISO9806HeatLoss"
  extends .Modelica.Icons.Example;
  replaceable package Medium = .IDEAS.Media.Water "Medium in the system";

  parameter .IDEAS.Fluid.PVTCollectors.Data.Generic per=
      .IDEAS.Fluid.PVTCollectors.Data.Uncovered.UI_Validation()
    "Performance data" annotation (choicesAllMatching=true);
  .Modelica.Blocks.Sources.Sine T1(
    amplitude=15,
    f=0.1,
    offset=273.15 + 10) "Temperature of the first segment"
    annotation (Placement(transformation(extent={{-92,-22},{-72,-2}})));
  .Modelica.Blocks.Sources.Sine T2(
    f=0.1,
    amplitude=15,
    offset=273.15 + 15) "Temperature of the second segment"
    annotation (Placement(transformation(extent={{-68,-36},{-48,-16}})));
  .Modelica.Blocks.Sources.Sine T3(
    f=0.1,
    amplitude=15,
    offset=273.15 + 20) "Temperature of the third segment"
    annotation (Placement(transformation(extent={{-90,-52},{-70,-32}})));
  .IDEAS.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss heaLosQuaDyn(
    nSeg=3,
    redeclare package Medium = Medium,
    a1=per.a1,
    a2=per.a2,
    a3=per.a3,
    a4=per.a4,
    a6=per.a6,
    a7=per.a7,
    a8=per.a8,
    A_c=per.A) annotation (Placement(transformation(extent={{18,-2},{38,18}})));

  .IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss heaLosSteSta(
    A_c=per.A,
    nSeg=3,
    redeclare package Medium = Medium,
    a1=per.a1,
    a2=per.a2)
    annotation (Placement(transformation(extent={{18,-68},{38,-48}})));
  .Modelica.Blocks.Sources.Sine TEnv(
    f=0.01,
    offset=273.15 + 10,
    amplitude=15) "Temperature of the surrounding environment"
    annotation (Placement(transformation(extent={{-80,24},{-60,44}})));
  .Modelica.Blocks.Sources.Sine winSpePla(
    f=1/(24*3600),
    phase=0,
    offset=3,
    amplitude=2) "wind speed in the collector plane"
    annotation (Placement(transformation(extent={{60,58},{80,78}})));
  .Modelica.Blocks.Sources.RealExpression HHorIR(y=400) "long wave irradiance"
    annotation (Placement(transformation(extent={{-1.5,58},{17.5,74}})));
  .Modelica.Blocks.Sources.RealExpression HGloTil(y=800) "Global irradiance on the tilted surface"
    annotation (Placement(transformation(extent={{26.5,58},{45.5,74}})));
  .Modelica.Blocks.Interfaces.RealOutput QLos_flow_QuaDyn[3]
    "Heat loss rate at current conditions"
    annotation (Placement(transformation(extent={{60,-2},{80,18}})));
  .Modelica.Blocks.Interfaces.RealOutput QLos_flow_SteSta[3]
    "Heat loss rate at current conditions"
    annotation (Placement(transformation(extent={{62,-68},{82,-48}})));
equation
  connect(winSpePla.y, heaLosQuaDyn.winSpePla);
  connect(HHorIR.y,  heaLosQuaDyn.HHorIR);
  connect(HGloTil.y,  heaLosQuaDyn.HGloTil);
  connect(T3.y, heaLosQuaDyn.TFlu[3]) annotation (Line(points={{-69,-42},{-44,-42},
          {-44,2},{-20,2},{-20,2.66667},{16,2.66667}},
                                      color={0,0,127}));
  connect(T2.y, heaLosQuaDyn.TFlu[2]) annotation (Line(points={{-47,-26},{-44,-26},
          {-44,2},{16,2}},      color={0,0,127}));
  connect(TEnv.y, heaLosQuaDyn.TEnv) annotation (Line(points={{-59,34},{8,34},{8,
          14},{16,14}}, color={0,0,127}));
  connect(heaLosSteSta.TEnv, TEnv.y) annotation (Line(points={{16,-52},{8,-52},{
          8,34},{-59,34}}, color={0,0,127}));
  connect(T1.y, heaLosSteSta.TFlu[1]) annotation (Line(points={{-71,-12},{-68,
          -12},{-68,2},{-44,2},{-44,-64.6667},{16,-64.6667}},
                                                         color={0,0,127}));
  connect(T2.y, heaLosSteSta.TFlu[2]) annotation (Line(points={{-47,-26},{-44,-26},
          {-44,-64},{16,-64}}, color={0,0,127}));
  connect(T3.y, heaLosSteSta.TFlu[3]) annotation (Line(points={{-69,-42},{-44,
          -42},{-44,-63.3333},{16,-63.3333}},
                                         color={0,0,127}));
  connect(T1.y, heaLosQuaDyn.TFlu[1]) annotation (Line(points={{-71,-12},{-68,-12},
          {-68,1.33333},{16,1.33333}}, color={0,0,127}));
  connect(heaLosQuaDyn.QLos_flow, QLos_flow_QuaDyn)
    annotation (Line(points={{39,8},{70,8}}, color={0,0,127}));
  connect(heaLosSteSta.QLos_flow, QLos_flow_SteSta)
    annotation (Line(points={{39,-58},{72,-58}}, color={0,0,127}));
  annotation (
   Documentation(info="<html>
<p>
This example demonstrates the implementation of
<a href=\"modelica://IDEAS.Fluid.PVTCollectors.BaseClasses.ISO9806HeatLoss\">
IDEAS.Fluid.PVTCollectors.BaseClasses.ISO9806QuasiDynamicHeatLoss</a>,
which calculates the quasi-dynamic heat loss of a PVT or solar thermal collector
according to the ISO 9806:2017 standard.
</p>
<p>
In addition to showcasing the ISO 9806:2017-based model, this example also compares its behavior
to the steady-state heat loss model
<a href=\"modelica://IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss\">
IDEAS.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a>,
which is based on the now-superseded EN 12975 standard.
</p>
<p>
This comparison highlights the differences between the steady-state and quasi-dynamic
approaches, particularly in how they account for environmental factors such as wind speed
and long-wave irradiance.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 2, 2025, by Lone Meertens:<br/>
First implementation of ISO 9806 quasi-dynamic heat loss example.
This is for <a href=\"https://github.com/open-ideas/IDEAS/issues/1436\">1436</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/PVTCollectors/BaseClasses/Examples/ISO9806HeatLoss.mos"
        "Simulate and plot"),
 experiment(
      StartTime=0,
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="dassl"));
end ISO9806HeatLoss;
