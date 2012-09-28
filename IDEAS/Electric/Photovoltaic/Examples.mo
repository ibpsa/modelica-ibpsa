within IDEAS.Electric.Photovoltaic;
package Examples
  extends Modelica.Icons.ExamplesPackage;
  model UsePVGeneral

    PVSystemGeneral pVSystemGeneral(inc=20/180*3.1415, amount=20)
      annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
    PvSystemGeneralFromFile pvSystemGeneralFromFile(PNom=20*230.153)
      annotation (Placement(transformation(extent={{-80,-14},{-60,6}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(f=50, V=230) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={30,-24})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
      annotation (Placement(transformation(extent={{20,-74},{40,-54}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
      powerSensorPV
      annotation (Placement(transformation(extent={{-20,46},{0,66}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sensors.PowerSensor
      powerSensorPVFile
      annotation (Placement(transformation(extent={{-20,-14},{0,6}})));
    inner Climate.SimInfoManager sim(
                redeclare IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
        IDEAS.Climate.Meteo.Files.min15 detail)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    inner IDEAS.Electric.Photovoltaic.Components.ForInputFiles.PVProfileReader
                                               PV1(fileName=
          "../Inputs/PV_Inc20_Azi0.txt")
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  equation
    connect(ground.pin, voltageSource.pin_n) annotation (Line(
        points={{30,-54},{30,-44},{30,-34},{30,-34}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(pVSystemGeneral.pin[1], powerSensorPV.currentP) annotation (Line(
        points={{-59.8,60},{-40,60},{-40,56},{-20,56}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(pvSystemGeneralFromFile.pin[1], powerSensorPVFile.currentP)
      annotation (Line(
        points={{-59.8,0},{-40,0},{-40,-4},{-20,-4}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPVFile.currentN, voltageSource.pin_p) annotation (Line(
        points={{0,-4},{30,-4},{30,-14}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPV.currentN, voltageSource.pin_p) annotation (Line(
        points={{0,56},{30,56},{30,-14}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPVFile.voltageP, powerSensorPVFile.currentP) annotation (
       Line(
        points={{-10,6},{-20,6},{-20,-4}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPV.voltageP, powerSensorPV.currentP) annotation (Line(
        points={{-10,66},{-20,66},{-20,56}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPV.voltageN, voltageSource.pin_n) annotation (Line(
        points={{-10,46},{10,46},{10,-34},{30,-34}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(powerSensorPVFile.voltageN, voltageSource.pin_n) annotation (Line(
        points={{-10,-14},{-10,-34},{30,-34}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation (
      Diagram(graphics),
      experiment(StopTime=3.1536e+007, Interval=600),
      __Dymola_experimentSetupOutput);
  end UsePVGeneral;

  model PVSystem
    "Only a PV system, see python script for generating profiles from this model"

    parameter SI.Angle inc = 40/180*Modelica.Constants.pi annotation(evaluate=False);
    parameter SI.Angle azi = 45/180*Modelica.Constants.pi annotation(evaluate=False);

    IDEAS.Electric.Photovoltaic.PVSystemGeneral pVSystemGeneral(
      amount=20,
      inc=inc,
      azi=azi)
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
        points={{-17.8,18},{40,18},{40,10}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(voltageSource.pin_n, ground.pin) annotation (Line(
        points={{40,-10},{40,-30}},
        color={85,170,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end PVSystem;

  model Test_PvVoltageCtrl "Tester for the PV voltage control model"

    Components.PvVoltageCtrlGeneral_InputVGrid
      pvVoltageCtrlGeneral_InputVGrid_2_1
      annotation (Placement(transformation(extent={{-16,8},{4,28}})));
    Modelica.Blocks.Sources.Sine sine(
      amplitude=36,
      offset=230,
      freqHz=0.85e-2)
      annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
    Modelica.Blocks.Sources.Constant const(k=300)
      annotation (Placement(transformation(extent={{-88,48},{-68,68}})));
  equation
    connect(sine.y, pvVoltageCtrlGeneral_InputVGrid_2_1.VGrid) annotation (Line(
        points={{-59,-16},{-38,-16},{-38,12},{-16,12}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const.y, pvVoltageCtrlGeneral_InputVGrid_2_1.PInit) annotation (
        Line(
        points={{-67,58},{-52,58},{-52,24},{-16,24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const.y, pvVoltageCtrlGeneral_InputVGrid_2_1.QInit) annotation (
        Line(
        points={{-67,58},{-66,58},{-66,38},{-52,38},{-52,20},{-16,20}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end Test_PvVoltageCtrl;
end Examples;
