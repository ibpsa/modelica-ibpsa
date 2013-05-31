within IDEAS.Thermal.Components.Examples;
model Radiator_CoolingDown "Test the cooling down of radiators"

extends Modelica.Icons.Example;

  Emission.Radiator       radiator_new(
    medium=Data.Media.Water(),
    QNom=1000,
    TInitial=333.15)
    annotation (Placement(transformation(extent={{-64,76},{-44,56}})));
  IDEAS.Thermal.Components.Emission.Radiator
                          radiator_new1(
    medium=Data.Media.Water(),
    QNom=2000,
    TInitial=333.15)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=294.15)
    annotation (Placement(transformation(extent={{-14,20},{-34,40}})));
  Thermal.Components.BaseClasses.Ambient ambient(
    medium=Data.Media.Water(),
    usePressureInput=false,
    constantAmbientPressure=200000,
    constantAmbientTemperature=333.15)
    annotation (Placement(transformation(extent={{-90,16},{-70,36}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=Data.Media.Water(),
    m_flowNom=0.05,
    m=1,
    useInput=true)
    annotation (Placement(transformation(extent={{-20,56},{0,76}})));
  Thermal.Components.BaseClasses.Pump pump1(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=0.05,
    useInput=true)
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Thermal.Components.BaseClasses.Ambient ambient1(
    medium=Data.Media.Water(),
    constantAmbientPressure=300000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{48,14},{68,34}})));
  IDEAS.Thermal.Components.Emission.Radiator
                          radiator_new2(
    medium=Data.Media.Water(),
    QNom=1000,
    powerFactor=3.37,
    TInitial=333.15,
    TInNom=318.15,
    TOutNom=308.15)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Thermal.Components.BaseClasses.Pump pump2(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=0.05,
    useInput=true)
    annotation (Placement(transformation(extent={{-14,-50},{6,-30}})));
equation
  pump.m_flowSet = if time > 1 then 0 else 1;
  pump1.m_flowSet = if time > 1 then 0 else 1;
  pump2.m_flowSet = if time > 1 then 0 else 1;
  connect(fixedTemperature.port, radiator_new.heatPortRad) annotation (Line(
      points={{-34,30},{-48.1667,30},{-48.1667,56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new1.heatPortCon) annotation (Line(
      points={{-34,30},{-51.5,30},{-51.5,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new1.heatPortRad) annotation (Line(
      points={{-34,30},{-50,30},{-50,10},{-48.1667,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, radiator_new.flowPort_a) annotation (Line(
      points={{-90,26},{-96,26},{-96,72.25},{-64,72.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, radiator_new1.flowPort_a) annotation (Line(
      points={{-90,26},{-96,26},{-96,-6.25},{-64,-6.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator_new1.flowPort_b, pump1.flowPort_a) annotation (Line(
      points={{-44,6.25},{-32,6.25},{-32,0},{-18,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator_new.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-44,59.75},{-32,59.75},{-32,66},{-20,66}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, ambient1.flowPort) annotation (Line(
      points={{0,66},{48,66},{48,24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient1.flowPort, pump1.flowPort_b) annotation (Line(
      points={{48,24},{50,24},{50,0},{2,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator_new2.flowPort_b,pump2. flowPort_a) annotation (Line(
      points={{-40,-33.75},{-28,-33.75},{-28,-40},{-14,-40}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new2.heatPortCon) annotation (Line(
      points={{-34,30},{-36,30},{-36,-16},{-47.5,-16},{-47.5,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, radiator_new2.heatPortRad) annotation (Line(
      points={{-34,30},{-36,30},{-36,-20},{-44.1667,-20},{-44.1667,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump2.flowPort_b, ambient1.flowPort) annotation (Line(
      points={{6,-40},{48,-40},{48,24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, radiator_new2.flowPort_a) annotation (Line(
      points={{-90,26},{-96,26},{-96,-46.25},{-60,-46.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator_new.heatPortCon, radiator_new1.heatPortCon) annotation (Line(
      points={{-51.5,56},{-52,56},{-52,10},{-51.5,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>These three radiators are supposed to show the same cooling down behaviour.</p>
</html>"));
end Radiator_CoolingDown;
