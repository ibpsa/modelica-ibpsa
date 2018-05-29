within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model SingleBoreHoleUTube "Test for the SingleBoreHole model"
  import IBPSA;

  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  replaceable
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.SingleBoreHoleUTube
    borHolDis(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
    dp_nominal=10) "Borehole connected to a discrete ground model" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,0})));

  IBPSA.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDat.conDat.m_flow_nominal_bh,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-76,-10},{
            -56,10}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=2,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,-12},{70,
            8}},  rotation=0)));
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation
                                        borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn(m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorDisOut(m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.CylindricalGroundLayer
    lay[borFieDat.conDat.nVer](
    each soiDat=borFieDat.soiDat,
    each h=borFieDat.conDat.hSeg,
    each r_a=borFieDat.conDat.rBor,
    each r_b=borFieDat.conDat.rExt,
    each nSta=borFieDat.conDat.nHor,
    each TInt_start=borFieDat.conDat.T_start,
    each TExt_start=borFieDat.conDat.T_start) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,70})));
  replaceable
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.SingleBoreHoleUTube
    borHolAna(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
    dp_nominal=10) "Borehole model connected to an analytical ground model"
    annotation (Placement(transformation(
        extent={{-14,14},{14,-14}},
        rotation=0,
        origin={0,-44})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorAnaOut(m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{30,-54},{50,-34}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.GroundTemperatureResponse
    groTemRes(p_max=2, borFieDat=borFieDat) "Ground temperature response"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol1(m=
        borFieDat.conDat.nVer) "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,-80})));
  Modelica.Blocks.Sources.Constant TGroUn(k=borFieDat.conDat.T_start)
    "Undisturbed ground temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,90})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol(m=borFieDat.conDat.nVer)
    "Thermal collector" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,70})));
  Modelica.Blocks.Math.Add deltaT(k2=-1)
    "Temperature difference between borehole with discrete ground and borehole with analytical ground"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
equation
  connect(sou.ports[1], TBorIn.port_a)
    annotation (Line(points={{-56,0},{-50,0}}, color={0,127,255}));
  connect(TBorIn.port_b, borHolDis.port_a) annotation (Line(points={{-30,0},{-14,
          0},{-14,1.77636e-015}}, color={0,127,255}));
  connect(borHolDis.port_b, TBorDisOut.port_a) annotation (Line(points={{14,
          1.77636e-015},{14,0},{30,0}}, color={0,127,255}));
  connect(TBorDisOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{56,0},{70,0}}, color={0,127,255}));
  connect(lay.port_a, borHolDis.port_wall)
    annotation (Line(points={{0,30},{0,22},{0,14}}, color={191,0,0}));
  connect(TBorIn.port_b, borHolAna.port_a) annotation (Line(points={{-30,0},{
          -30,0},{-30,-44},{-14,-44}}, color={0,127,255}));
  connect(borHolAna.port_b, TBorAnaOut.port_a)
    annotation (Line(points={{14,-44},{22,-44},{30,-44}}, color={0,127,255}));
  connect(TBorAnaOut.port_b, sin.ports[2])
    annotation (Line(points={{50,-44},{70,-44},{70,-4}}, color={0,127,255}));
  connect(groTemRes.Tb, therCol1.port_b)
    annotation (Line(points={{-40,-80},{-35,-80},{-30,-80}}, color={191,0,0}));
  connect(therCol1.port_a, borHolAna.port_wall)
    annotation (Line(points={{-10,-80},{0,-80},{0,-58}}, color={191,0,0}));
  connect(TGroUn.y, groTemRes.Tg) annotation (Line(points={{-80,79},{-80,79},{
          -80,-80},{-72,-80},{-62,-80}}, color={0,0,127}));
  connect(preTem.T, TGroUn.y)
    annotation (Line(points={{-62,70},{-80,70},{-80,79}}, color={0,0,127}));
  connect(preTem.port, therCol.port_b)
    annotation (Line(points={{-40,70},{-35,70},{-30,70}}, color={191,0,0}));
  connect(therCol.port_a, lay.port_b)
    annotation (Line(points={{-10,70},{0,70},{0,50}}, color={191,0,0}));
  connect(TBorDisOut.T, deltaT.u1) annotation (Line(points={{40,11},{42,11},{42,
          44},{42,46},{58,46}}, color={0,0,127}));
  connect(TBorAnaOut.T, deltaT.u2) annotation (Line(points={{40,-33},{40,-33},{
          40,-28},{52,-28},{52,34},{58,34}}, color={0,0,127}));
  annotation (
    __Dymola_Commands( file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/BaseClasses/Boreholes/Examples/SingleBoreHoleUTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
This example illustrates modeling a segment of a borehole heat exchanger.
It simulates the behavior of the borehole on a single horizontal section including the ground and the
boundary condition.
</html>", revisions="<html>
<ul>
<li>
August 30, 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=360000));
end SingleBoreHoleUTube;
