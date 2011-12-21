within IDEAS.Thermal.HeatingSystems.Examples;
model NakedHeatingCheck

  Thermal.HeatingSystems.Heating_DHW_TES_Radiators heating_DHW_TES(
    n_C=1,
    V_C={5},
    QNom={5000})
    annotation (Placement(transformation(extent={{-36,10},{-12,30}})));
  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min5 detail,
      redeclare Commons.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-86,66},{-66,86}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature
    annotation (Placement(transformation(extent={{-52,66},{-32,86}})));
  Modelica.Blocks.Sources.Constant const
    annotation (Placement(transformation(extent={{-12,66},{8,86}})));
equation
  connect(const.y, heating_DHW_TES.TOp[1]) annotation (Line(
      points={{9,76},{16,76},{16,40},{-24.3429,40},{-24.3429,29.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, heating_DHW_TES.TOpAsked[1]) annotation (Line(
      points={{9,76},{16,76},{16,40},{-21.6,40},{-21.6,29.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heating_DHW_TES.heatPortConv[1]) annotation (
      Line(
      points={{-32,76},{-29.28,76},{-29.28,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heating_DHW_TES.heatPortRad[1]) annotation (
      Line(
      points={{-32,76},{-27.0857,76},{-27.0857,30}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end NakedHeatingCheck;
