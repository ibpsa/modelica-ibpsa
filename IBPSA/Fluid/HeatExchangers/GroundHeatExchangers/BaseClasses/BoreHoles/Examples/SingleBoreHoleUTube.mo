within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.Examples;
model SingleBoreHoleUTube "Test for the SingleBoreHole model"

  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  replaceable
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.SingleBoreHoleUTube
    borHol(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
    dp_nominal=10) annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,0})));

  IBPSA.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDat.conDat.m_flow_nominal_bh,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-80,-10},{
            -60,10}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-10},{60,
            10}}, rotation=0)));
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation
                                        borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn(m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorOut(m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer
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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature preTem[borFieDat.conDat.nVer](
     T=borFieDat.conDat.T_start) "Prescribed temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,80})));
equation
  connect(sou.ports[1], TBorIn.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(TBorIn.port_b, borHol.port_a) annotation (Line(points={{-30,0},{-14,0},
          {-14,1.77636e-015}}, color={0,127,255}));
  connect(borHol.port_b, TBorOut.port_a) annotation (Line(points={{14,
          1.77636e-015},{14,0},{30,0}}, color={0,127,255}));
  connect(TBorOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  connect(preTem.port, lay.port_b)
    annotation (Line(points={{0,70},{0,70},{0,50}}, color={191,0,0}));
  connect(lay.port_a, borHol.port_wall)
    annotation (Line(points={{0,30},{0,22},{0,14}}, color={191,0,0}));
  annotation (
    __Dymola_Commands(file=
          "modelica://IDEAS/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/BaseClasses/Examples/BoreholeSegment.mos"
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
</html>"));
end SingleBoreHoleUTube;
