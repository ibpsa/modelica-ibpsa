within IDEAS.Fluid.Production.Examples;
model Boiler_validation "Validation model for the boiler"

  extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Thermal.Data.Media.Water(),
                            p=200000)
    annotation (Placement(transformation(extent={{-38,-32},{-18,-12}})));
  Fluid.Movers.Pump pump(
    medium=Thermal.Data.Media.Water(),
    m=1,
    m_flowNom=1300/3600,
    useInput=true)
    annotation (Placement(transformation(extent={{8,-56},{-12,-36}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe(
    medium=Thermal.Data.Media.Water(),
    m=5,
    TInitial=313.15)
    annotation (Placement(transformation(extent={{-10,18},{10,-2}})));
  IDEAS.Fluid.Production.Boiler heater(
    medium=Thermal.Data.Media.Water(),
    QNom=5000,
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000)
    annotation (Placement(transformation(extent={{-70,-16},{-50,4}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-84,-48},{-70,-34}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  Modelica.Blocks.Sources.TimeTable pulse(offset=0, table=[0, 0; 5000, 100;
        10000, 400; 15000, 700; 20000, 1000; 25000, 1300; 50000, 1300])
    annotation (Placement(transformation(extent={{-50,72},{-30,92}})));
  //  Real PElLossesInt( start = 0, fixed = true);
  //  Real PElNoLossesInt( start = 0, fixed = true);
  //  Real QUsefulLossesInt( start = 0, fixed = true);
  //  Real QUsefulNoLossesInt( start = 0, fixed = true);
  //  Real SPFLosses( start = 0);
  //  Real SPFNoLosses( start = 0);
  //
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-34,24},{-14,44}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=30,
    freqHz=1/5000,
    offset=273.15 + 50,
    startTime=20000)
    annotation (Placement(transformation(extent={{-76,24},{-56,44}})));
equation
  heater.TSet = 273.15 + 82;
  pump.m_flowSet = pulse.y/1300;
  //   der(PElLossesInt) = HP.PEl;
  //   der(PElNoLossesInt) = HP_NoLosses.PEl;
  //   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  //   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
  //   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
  //   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-63,-16},{-62,-16},{-62,-41},{-70,-41}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, pipe.heatPort) annotation (Line(
      points={{-14,34},{0,34},{0,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-55,34},{-36,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.flowPort_b, pipe.flowPort_a) annotation (Line(
      points={{-50,-5.09091},{-50,8},{-10,8}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{10,8},{48,8},{48,-46},{8,-46}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-12,-46},{-50,-46},{-50,-10.3636}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPort_a, absolutePressure.flowPort) annotation (Line(
      points={{-50,-10.3636},{-46,-10.3636},{-46,-10},{-44,-10},{-44,-22},{-38,
          -22}},
      color={0,0,255},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=40000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>Model used to validate the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">IDEAS.Thermal.Components.Production.Boiler</a>. With a fixed set point, the boiler receives different mass flow rates. </p>
</html>"));
end Boiler_validation;
