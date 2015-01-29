within IDEAS.HeatingSystems.Examples;
model IdealRadiatorHeating "Example and test for ideal heating with radiators"
  import IDEAS;
  extends Modelica.Icons.Example;
  final parameter Integer nZones = 1 "Number of zones";
  IDEAS.HeatingSystems.IdealRadiatorHeating heating(
    final nZones=nZones,
    QNom={20000 for i in 1:nZones},
    t=1,
    nLoads=0,
    VZones=building.VZones)
         annotation (Placement(transformation(extent={{-20,-10},{18,12}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding building(nZones=nZones, nEmb=0)
    annotation (Placement(transformation(extent={{-86,-10},{-52,12}})));
  IDEAS.VentilationSystems.None none(nZones=nZones, VZones=building.VZones)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

      inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder causalInhomeFeeder
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{76,-80},{96,-60}})));
  IDEAS.Occupants.Standards.ISO13790 iSO13790_1(
    nZones=building.nZones,
    nLoads=0,
    AFloor=building.AZones)
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
equation
  connect(building.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-52,3.2},{-20,3.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-52,-1.2},{-20,-1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(
      points={{-51.32,-5.6},{-20.38,-5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.flowPort_Out, none.flowPort_In) annotation (Line(
      points={{-71.2667,12},{-70,12},{-70,54},{-20,54},{-20,52}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(building.flowPort_In, none.flowPort_Out) annotation (Line(
      points={{-66.7333,12},{-66,12},{-66,50},{-20,50},{-20,48}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, none.TSensor) annotation (Line(
      points={{-51.32,-5.6},{-46,-5.6},{-46,44},{-20.2,44}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(voltageSource.pin_p,ground. pin) annotation (Line(
        points={{86,-40},{86,-60}},
        color={85,170,255},
        smooth=Smooth.None));
  connect(causalInhomeFeeder.pinSingle,voltageSource. pin_n) annotation (Line(
      points={{64,0},{86,0},{86,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(none.plugLoad,causalInhomeFeeder. nodeSingle) annotation (Line(
      points={{0,50},{32,50},{32,0},{44,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.plugLoad, causalInhomeFeeder.nodeSingle) annotation (Line(
      points={{18,1},{32,1},{32,0},{44,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(iSO13790_1.TSet, heating.TSet) annotation (Line(
      points={{0,-28},{0,-10.22},{-1,-10.22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iSO13790_1.mDHW60C, heating.mDHW60C) annotation (Line(
      points={{3,-28},{3,-10.22},{4.7,-10.22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iSO13790_1.plugLoad, causalInhomeFeeder.nodeSingle) annotation (Line(
      points={{10,-38},{32,-38},{32,0},{44,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(iSO13790_1.heatPortRad, building.heatPortRad) annotation (Line(
      points={{-10,-40},{-38,-40},{-38,-1.2},{-52,-1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iSO13790_1.heatPortCon, building.heatPortCon) annotation (Line(
      points={{-10,-36},{-30,-36},{-30,3.2},{-52,3.2}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealRadiatorHeating;
