within Annex60.Experimental.ThermalZones.ReducedOrder.Examples;
model VDI6007TestCase8 "Illustrates the use of ThermalZoneTwoElements"

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat
    annotation (Placement(transformation(extent={{-98,52},{-78,72}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    til=0.17453292519943,
    lat=0.17453292519943,
    azi=0.17453292519943,
    outSkyCon=true,
    outGroCon=true)
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil
    annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
  BoundaryConditions.SkyTemperature.BlackBody TBlaSky
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));
  CorrectionSolarGain.CorGDoublePane corGDoublePane
    annotation (Placement(transformation(extent={{6,54},{26,74}})));
  Modelica.Blocks.Math.Sum
            aggWindow
    annotation (Placement(transformation(extent={{44,57},{58,71}})));
  ROM.ThermalZoneTwoElements thermalZoneTwoElements
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  EqAirTemp.EqAirTemp eqAirTemp
    annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
  Modelica.Blocks.Math.Add SolRad
    annotation (Placement(transformation(extent={{-38,6},{-28,16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{8,14},{20,26}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor
    annotation (Placement(transformation(extent={{28,16},{38,26}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1
    annotation (Placement(transformation(extent={{26,-4},{36,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlowRad
    annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlowConv1
    annotation (Placement(transformation(extent={{48,-64},{68,-44}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableRad
    annotation (Placement(transformation(extent={{6,-40},{22,-24}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTableConv
    annotation (Placement(transformation(extent={{6,-62},{22,-46}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
equation
  connect(weaDat.weaBus, HDirTil.weaBus) annotation (Line(
      points={{-78,62},{-68,62}},
      color={255,204,51},
      thickness=0.5));
  connect(HDirTil.inc, corGDoublePane.inc[1])
    annotation (Line(points={{-47,58},{6,58},{6,57.4}}, color={0,0,127}));
  connect(HDirTil.H, corGDoublePane.HDirTil[1]) annotation (Line(points={{-47,
          62},{-12,62},{-12,70},{6,70}}, color={0,0,127}));
  connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil[1]) annotation (Line(
        points={{-47,24},{-47,24},{-4,24},{-4,61.6},{6,61.6}}, color={0,0,127}));
  connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil[1]) annotation (Line(
        points={{-47,36},{-47,36},{-6,36},{-6,65.8},{6,65.8}}, color={0,0,127}));
  connect(eqAirTemp.TEqAirWindow, prescribedTemperature1.T) annotation (Line(
        points={{-4.2,-1.4},{0,-1.4},{0,20},{6.8,20}}, color={0,0,127}));
  connect(eqAirTemp.TEqAir, prescribedTemperature.T) annotation (Line(points={{
          -4.2,-9.6},{4,-9.6},{4,0},{6.8,0}}, color={0,0,127}));
  connect(weaDat.weaBus, HDifTil.weaBus) annotation (Line(
      points={{-78,62},{-74,62},{-74,30},{-68,30}},
      color={255,204,51},
      thickness=0.5));
  connect(TBlaSky.TBlaSky, eqAirTemp.TBlaSky) annotation (Line(points={{-45,-20},
          {-34,-20},{-34,-4.6},{-22,-4.6}}, color={0,0,127}));
  connect(HDirTil.H, SolRad.u1) annotation (Line(points={{-47,62},{-44,62},{-44,
          14},{-39,14}}, color={0,0,127}));
  connect(HDifTil.H, SolRad.u2) annotation (Line(points={{-47,30},{-44,30},{-44,
          8},{-39,8}}, color={0,0,127}));
  connect(SolRad.y, eqAirTemp.HSol[1]) annotation (Line(points={{-27.5,11},{-26,
          11},{-26,0.4},{-22,0.4}}, color={0,0,127}));
  connect(prescribedTemperature1.port, thermalConductor.port_a)
    annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
  connect(thermalConductor.port_b, thermalZoneTwoElements.window) annotation (
      Line(points={{38,21},{42,21},{42,19.8},{45,19.8}}, color={191,0,0}));
  connect(prescribedTemperature.port, thermalConductor1.port_a)
    annotation (Line(points={{20,0},{26,0},{26,1}}, color={191,0,0}));
  connect(thermalConductor1.port_b, thermalZoneTwoElements.extWall) annotation (
     Line(points={{36,1},{38,1},{38,2},{40,2},{40,12.4},{45,12.4}}, color={191,
          0,0}));
  connect(prescribedHeatFlowRad.port, thermalZoneTwoElements.intGainsRad)
    annotation (Line(points={{68,-32},{84,-32},{98,-32},{98,26},{91,26}}, color=
         {191,0,0}));
  connect(prescribedHeatFlowConv1.port, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{68,-54},{82,-54},{82,-52},{96,-52},{96,19.8},{91,
          19.8}}, color={191,0,0}));
  connect(combiTimeTableRad.y[1], prescribedHeatFlowRad.Q_flow)
    annotation (Line(points={{22.8,-32},{36,-32},{48,-32}}, color={0,0,127}));
  connect(combiTimeTableConv.y[1], prescribedHeatFlowConv1.Q_flow)
    annotation (Line(points={{22.8,-54},{36,-54},{48,-54}}, color={0,0,127}));
  connect(const.y, eqAirTemp.sunblind[1]) annotation (Line(points={{-13.7,17},{
          -10,17},{-10,4},{-14,4}}, color={0,0,127}));
  connect(corGDoublePane.solarRadWinTrans, aggWindow.u)
    annotation (Line(points={{25,64},{42.6,64}}, color={0,0,127}));
  connect(aggWindow.y, thermalZoneTwoElements.solRad) annotation (Line(points={
          {58.7,64},{66,64},{66,44},{26,44},{26,30.8},{45,30.8}}, color={0,0,
          127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end VDI6007TestCase8;
