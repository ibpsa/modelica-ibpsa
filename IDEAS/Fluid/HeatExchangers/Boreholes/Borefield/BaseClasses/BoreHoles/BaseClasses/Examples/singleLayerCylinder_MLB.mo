within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.BoreHoles.BaseClasses.Examples;
model singleLayerCylinder_MLB
  "Comparison of the CylindricalGroundLayer with the Modelica Buildings Library"
  extends Modelica.Icons.Example;
  import Buildings;

  parameter GroundHeatExchanger.Borefield.Data.BorefieldData.example_accurate bfData
    annotation (Placement(transformation(extent={{-60,76},{-40,96}})));

  Buildings.HeatTransfer.Conduction.SingleLayerCylinder soi_MBL(
    final material=Buildings.HeatTransfer.Data.BaseClasses.ThermalProperties(
     k=bfData.soi.k,c=bfData.soi.c,d=bfData.soi.d),
    final h=bfData.adv.hSeg,
    final nSta=bfData.adv.nHor,
    final r_a=bfData.geo.rBor,
    final r_b=bfData.adv.rExt,
    final steadyStateInitial=false,
    final TInt_start=bfData.adv.TFil0_start,
    final TExt_start=bfData.adv.TExt0_start) "Heat conduction in the soil"
        annotation (Placement(transformation(extent={{-10,-62},{10,-42}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    annotation (Placement(transformation(extent={{-66,-62},{-46,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
    annotation (Placement(transformation(extent={{44,-62},{64,-42}})));
  Modelica.Blocks.Sources.Constant const3(k=bfData.adv.TFil0_start)
    annotation (Placement(transformation(extent={{0,-92},{20,-72}})));

  CylindricalGroundLayer soi(
    final material=bfData.soi,
    final h=bfData.adv.hSeg,
    final nSta=bfData.adv.nHor,
    final r_a=bfData.geo.rBor,
    final r_b=bfData.adv.rExt,
    final steadyStateInitial=false,
    final TInt_start=bfData.adv.TFil0_start,
    final TExt_start=bfData.adv.TExt0_start) "Heat conduction in the soil"
                                  annotation (Placement(
        transformation(extent={{-12,16},{8,36}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature2
    annotation (Placement(transformation(extent={{42,16},{62,36}})));
  Modelica.Blocks.Sources.Constant const1(k=bfData.adv.TFil0_start)
    annotation (Placement(transformation(extent={{-2,-14},{18,6}})));
  Modelica.Blocks.Sources.Step     const4(
    height=120,
    offset=0,
    startTime=1000)
    annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2
    annotation (Placement(transformation(extent={{-64,18},{-44,38}})));
  Modelica.Blocks.Sources.Step     const2(
    height=120,
    offset=0,
    startTime=1000)
    annotation (Placement(transformation(extent={{-96,-62},{-76,-42}})));
equation
  connect(prescribedHeatFlow1.port,soi_MBL. port_a) annotation (Line(
      points={{-46,-52},{-10,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(soi_MBL.port_b, prescribedTemperature1.port) annotation (Line(
      points={{10,-52},{24,-52},{24,-28},{80,-28},{80,-52},{64,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const3.y, prescribedTemperature1.T) annotation (Line(
      points={{21,-82},{32,-82},{32,-52},{42,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(soi.port_b, prescribedTemperature2.port) annotation (Line(
      points={{8,26},{22,26},{22,50},{78,50},{78,26},{62,26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const1.y, prescribedTemperature2.T) annotation (Line(
      points={{19,-4},{30,-4},{30,26},{40,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const4.y, prescribedHeatFlow2.Q_flow) annotation (Line(
      points={{-73,28},{-64,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow2.port, soi.port_a) annotation (Line(
      points={{-44,28},{-28,28},{-28,26},{-12,26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const2.y, prescribedHeatFlow1.Q_flow) annotation (Line(
      points={{-75,-52},{-66,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=187200),
    __Dymola_experimentSetupOutput);
end singleLayerCylinder_MLB;
