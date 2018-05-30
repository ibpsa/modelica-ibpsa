within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.Validation;
model CylindricalGroundLayer
  "Comparison of the CylindricalGroundLayer with the Modelica Buildings Library"
  import IBPSA;
  extends Modelica.Icons.Example;

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.CylindricalGroundLayer
    soi(
    final steadyStateInitial=false,
    final soiDat=borFieDat.soiDat,
    final h=1,
    final r_a=borFieDat.conDat.rBor,
    final r_b=3,
    final nSta=borFieDat.conDat.nHor,
    final TInt_start=borFieDat.conDat.T_start,
    final TExt_start=borFieDat.conDat.T_start) "Heat conduction in the soil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature preTem(T=borFieDat.conDat.T_start)
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Step     heaFlo(
    offset=0,
    startTime=1000,
    height=1056/18.3) "Heat flow to soil"
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow to soil"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Data.BorefieldData.Template borFieDat = IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation()
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(soi.port_b, preTem.port) annotation (Line(
      points={{10,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo.y, preHeaFlo.Q_flow) annotation (Line(
      points={{-75,0},{-60,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo.port, soi.port_a) annotation (Line(
      points={{-40,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=187200),
    __Dymola_experimentSetupOutput);
end CylindricalGroundLayer;
