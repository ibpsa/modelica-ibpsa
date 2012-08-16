within IDEAS.Electric.Photovoltaic;
package Examples
  extends Modelica.Icons.ExamplesPackage;
  model UsePVGeneral
    PVSystemGeneral pVSystemGeneral
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    PvSystemGeneralFromFile pvSystemGeneralFromFile
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(f=50, V=230) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={30,-10})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
      annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
      powerSensorPV
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
      powerSensorPVFile
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    inner Climate.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min10
        detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner Components.ForInputFiles.Read10minPV PV1
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  equation
    connect(ground.pin, voltageSource.pin_n) annotation (Line(
        points={{30,-40},{30,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(pVSystemGeneral.pin[1], powerSensorPV.currentP) annotation (Line(
        points={{-59.8,74},{-40,74},{-40,70},{-20,70}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(pvSystemGeneralFromFile.pin[1], powerSensorPVFile.currentP)
      annotation (Line(
        points={{-59.8,14},{-40,14},{-40,10},{-20,10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPVFile.currentN, voltageSource.pin_p) annotation (Line(
        points={{0,10},{30,10},{30,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPV.currentN, voltageSource.pin_p) annotation (Line(
        points={{0,70},{30,70},{30,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPVFile.voltageP, powerSensorPVFile.currentP) annotation (
       Line(
        points={{-10,20},{-20,20},{-20,10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPV.voltageP, powerSensorPV.currentP) annotation (Line(
        points={{-10,80},{-20,80},{-20,70}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPV.voltageN, voltageSource.pin_n) annotation (Line(
        points={{-10,60},{10,60},{10,-20},{30,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPVFile.voltageN, voltageSource.pin_n) annotation (Line(
        points={{-10,0},{-10,-20},{30,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation (
      Diagram(graphics),
      experiment(StopTime=3.1536e+007, Interval=600),
      __Dymola_experimentSetupOutput);
  end UsePVGeneral;

  model PVSystem
    "Only a PV system, see python script for generating profiles from this model"

    IDEAS.Electric.Photovoltaic.PVSystemGeneral pVSystemGeneral
      annotation (Placement(transformation(extent={{-38,4},{-18,24}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
      annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(f=50, V=230) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={40,0})));
    inner IDEAS.Climate.SimInfoManager sim(redeclare
        IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
        IDEAS.Climate.Meteo.Files.min15 detail)
      annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
  equation
    connect(pVSystemGeneral.pin[1], voltageSource.pin_p) annotation (Line(
        points={{-17.8,18},{40,10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(voltageSource.pin_n, ground.pin) annotation (Line(
        points={{40,-10},{40,-30}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end PVSystem;
end Examples;
