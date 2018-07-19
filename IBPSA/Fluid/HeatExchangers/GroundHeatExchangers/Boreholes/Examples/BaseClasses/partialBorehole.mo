within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples.BaseClasses;
partial model partialBorehole
  "Partial model for borehole example models"

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Integer nHor(min=1) = 10
    "Number of cells to use in radial discretization of soil";
  parameter Modelica.SIunits.Temperature T_start = 273.15 + 22
    "Initial soil temperature";

  replaceable
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.partialBorehole
    borHol(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    dp_nominal=borFieDat.conDat.dp_nominal,
    nSeg=nSeg) "Borehole connected to a discrete ground model" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,0})));

  IBPSA.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-76,-10},{
            -56,10}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,-12},{70,
            8}},  rotation=0)));
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Example
    borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn(m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
      redeclare package Medium = Medium) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorOut(m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
      redeclare package Medium = Medium) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,70})));
  Modelica.Blocks.Sources.Constant TGroUn(k=T_start)
    "Undisturbed ground temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,90})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol(m=nSeg)
    "Thermal collector" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,70})));
equation
  connect(sou.ports[1], TBorIn.port_a)
    annotation (Line(points={{-56,0},{-50,0}}, color={0,127,255}));
  connect(TBorIn.port_b, borHol.port_a) annotation (Line(points={{-30,0},{-14,0},
          {-14,1.77636e-015}}, color={0,127,255}));
  connect(borHol.port_b, TBorOut.port_a) annotation (Line(points={{14,
          1.77636e-015},{14,0},{30,0}}, color={0,127,255}));
  connect(TBorOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{70,0},{70,-2}}, color={0,127,255}));
  connect(preTem.T, TGroUn.y)
    annotation (Line(points={{-62,70},{-80,70},{-80,79}}, color={0,0,127}));
  connect(preTem.port, therCol.port_b)
    annotation (Line(points={{-40,70},{-35,70},{-30,70}}, color={191,0,0}));
  connect(therCol.port_a, borHol.port_wall)
    annotation (Line(points={{-10,70},{0,70},{0,14}}, color={191,0,0}));

  annotation(Documentation(info="<html>
This partial model is used for examples using boreholes models which extend
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.partialBorehole\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.partialBorehole</a>.
</html>", revisions="<html>
<ul>
<li>
July 9, 2018, by Alex Laferri&egrave;re:<br>
First implementation.
</li>
</ul>
</html>"));
end partialBorehole;
