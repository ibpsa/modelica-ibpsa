within IDEAS.HeatingSystems.Examples;
model IdealRadiatorHeating "Example and test for ideal heating with radiators"
  import IDEAS;
  extends Modelica.Icons.Example;
  parameter Boolean standAlone = true;
  final parameter Integer nZones = 1 "Number of zones";
  IDEAS.HeatingSystems.IdealRadiatorHeating heating(
    final nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    QNom={20000 for i in 1:nZones},
    t=1,
    nLoads=1)
         annotation (Placement(transformation(extent={{-20,-10},{18,12}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289)
    annotation (Placement(transformation(extent={{-36,-56},{-24,-44}})));
  inner IDEAS.SimInfoManager sim(redeclare
      IDEAS.Occupants.Extern.Interfaces.Occ_Files occupants)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones, nEmb=0)
    annotation (Placement(transformation(extent={{-86,-10},{-52,12}})));
  IDEAS.VentilationSystems.None none(nZones=nZones, VZones=ones(nZones) .* 36)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

      inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder causalInhomeFeeder
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) if standAlone annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,-30})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground if
    standAlone
    annotation (Placement(transformation(extent={{76,-80},{96,-60}})));
equation
  connect(TOpSet.y, heating.TSet) annotation (Line(
      points={{-23.4,-50},{-1.19,-50},{-1.19,-10.44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-52,3.2},{-20,3.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-52,-1.2},{-20,-1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-51.32,-5.6},{-20.38,-5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyBuilding.flowPort_Out, none.flowPort_In) annotation (Line(
      points={{-71.2667,12},{-70,12},{-70,54},{-20,54},{-20,52}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.flowPort_In, none.flowPort_Out) annotation (Line(
      points={{-66.7333,12},{-66,12},{-66,50},{-20,50},{-20,48}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, none.TSensor) annotation (Line(
      points={{-51.32,-5.6},{-46,-5.6},{-46,44},{-20.4,44}},
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealRadiatorHeating;
