within IDEAS.Examples.TwinHouses.Interfaces;
partial model PartialTwinHouse
  "Partial model for simulation of twinhouse experiments"
  extends Modelica.Icons.Example;
  inner IDEAS.BoundaryConditions.SimInfoManager sim(
    filNam="weatherinput.TMY",
    weaDat(
      pAtmSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      ceiHeiSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      ceiHei=7,
      HSou=IDEAS.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor,
      totSkyCovSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      opaSkyCovSou=IDEAS.BoundaryConditions.Types.DataSource.Parameter,
      calTSky=IDEAS.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover,
      totSkyCov=0.6,
      opaSkyCov=0.6),
    linIntRad=false,
    linExtRad=false,
    radSol(each rho=0.23),
    lat=0.83555892609977,
    lon=0.20469221467389)
                     "Sim info manager"
    annotation (Placement(transformation(extent={{-68,64},{-48,84}})));

   replaceable IDEAS.Examples.TwinHouses.BaseClasses.Structures.TwinhouseN2 struct(T_start={303.15,
        303.15,303.15,303.15,303.15,303.15,303.15}) constrainedby
    IDEAS.Examples.TwinHouses.Interfaces.PartialTTHStructure
    "Building envelope model"
    annotation (Placement(transformation(extent={{-42,-10},{-12,10}})));
   replaceable IDEAS.Examples.TwinHouses.BaseClasses.HeatingSystems.ElectricHeating_Twinhouse_alt
    heaSys(
    nEmbPorts=0,
    nZones=struct.nZones,
    InInterface=true,
    nLoads=0,
    Crad={1000,1000,1000,1000,1100,1000,100},
    Kemission={100,100,100,100,110,100,100},
    Q_design={1820,750,750,750,750,750,750}) "Heat system model"
    annotation (Placement(transformation(extent={{0,-10},{40,10}})));
   replaceable IDEAS.Examples.TwinHouses.BaseClasses.Ventilation.Vent_TTH vent(
    nZones=struct.nZones,
    VZones=struct.VZones,
    redeclare package Medium = IDEAS.Media.Air) "Ventilation model"
    annotation (Placement(transformation(extent={{0,20},{40,40}})));
protected
  Modelica.Blocks.Sources.RealExpression[8] noInput(each y=0) "No occupants"
    annotation (Placement(transformation(extent={{-30,-46},{-10,-26}})));
public
  Modelica.Blocks.Sources.CombiTimeTable
                                       inputSolTTH(
    tableOnFile=true,
    tableName="data",
    fileName=
        IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(Modelica.Utilities.Files.loadResource("modelica://IDEAS") + "//Inputs//"+"weatherinput.txt"),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "input for solGloHor and solDifHor measured at TTH"
    annotation (Placement(transformation(extent={{-92,64},{-72,84}})));
equation

  connect(sim.weaDat.HGloHor_in, inputSolTTH.y[8]);
  connect(sim.weaDat.HDifHor_in, inputSolTTH.y[10]);
  connect(struct.heatPortEmb, heaSys.heatPortEmb)
    annotation (Line(points={{-12,6},{0,6}}, color={191,0,0}));
  connect(struct.heatPortCon, heaSys.heatPortCon)
    annotation (Line(points={{-12,2},{0,2}},        color={191,0,0}));
  connect(struct.heatPortRad, heaSys.heatPortRad)
    annotation (Line(points={{-12,-2},{0,-2}}, color={191,0,0}));
  connect(struct.TSensor, heaSys.TSensor)
    annotation (Line(points={{-11.4,-6},{-0.4,-6}},color={0,0,127}));
  connect(struct.TSensor, vent.TSensor) annotation (Line(points={{-11.4,-6},{
          -6,-6},{-6,-4},{-6,24},{-0.4,24}},        color={0,0,127}));
  connect(vent.flowPort_In, struct.flowPort_Out) annotation (Line(points={{0,32},{
          0,32},{-29,32},{-29,22},{-29,10}},
                                           color={0,0,0}));
  connect(struct.flowPort_In, vent.flowPort_Out) annotation (Line(points={{-25,10},
          {-24,10},{-24,28},{0,28}},              color={0,0,0}));
          for i in 1:struct.nZones loop
          end for;
  connect(noInput[1:7].y, heaSys.TSet) annotation (Line(points={{-9,-36},{20,
          -36},{20,-10.2},{20,-10.2}},
                                     color={0,0,127}));
  connect(noInput[8].y, heaSys.mDHW60C) annotation (Line(points={{-9,-36},{26,
          -36},{26,-10.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=1.5e+007,
      StopTime=2.35872e+007,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/Twinhouses/BuildingN2_Exp1.mos"
        "Simulate and plot"));
end PartialTwinHouse;
