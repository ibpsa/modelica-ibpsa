within IDEAS.Examples.TwinHouses.Interfaces;
partial model PartialTwinHouse
  "Partial model for simulation of twinhouse experiments"
  extends Modelica.Icons.Example;
  parameter Integer exp = 1 "Experiment number: 1 or 2";
  parameter Integer bui = 1 "Building number 1 (N2), 2 (O5)";
  final parameter String dirPath = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Inputs/")
    annotation(Evaluate=true);
  final parameter String filNam=if exp == 1  then "WeatherTwinHouseExp1.txt" else "WeatherTwinHouseExp2.txt"
    annotation(Evaluate=true);
  inner IDEAS.BoundaryConditions.SimInfoManager sim(
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
    lon=0.20469221467389,
    filNam=filNam) "Sim info manager"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

   replaceable IDEAS.Examples.TwinHouses.BaseClasses.Structures.TwinhouseN2 struct(T_start={303.15,
        303.15,303.15,303.15,303.15,303.15,303.15},
    final exp=exp,
    final bui=bui)                                  constrainedby
    IDEAS.Examples.TwinHouses.Interfaces.PartialTTHStructure
    "Building envelope model"
    annotation (Placement(transformation(extent={{-42,-10},{-12,10}})));
   replaceable IDEAS.Examples.TwinHouses.BaseClasses.HeatingSystems.ElectricHeating_Twinhouse_alt
      heaSys
   constrainedby
    IDEAS.Examples.TwinHouses.BaseClasses.HeatingSystems.ElectricHeating_Twinhouse_alt(
    nEmbPorts=0,
    nZones=struct.nZones,
    InInterface=true,
    nLoads=0,
    Crad={1000,1000,1000,1000,1100,1000,100},
    Kemission={100,100,100,100,110,100,100},
    Q_design={1820,750,750,750,750,750,750},
    final exp=exp,
    final bui=bui)                           "Heat system model"
    annotation (Placement(transformation(extent={{0,-10},{40,10}})));
   replaceable IDEAS.Examples.TwinHouses.BaseClasses.Ventilation.Vent_TTH vent(
    nZones=struct.nZones,
    VZones=struct.VZones,
    redeclare package Medium = IDEAS.Media.Air,
    final exp=exp,
    final bui=bui)                              "Ventilation model"
    annotation (Placement(transformation(extent={{0,20},{40,40}})));
protected
  Modelica.Blocks.Sources.RealExpression[8] noInput(each y=0) "No occupants"
    annotation (Placement(transformation(extent={{-30,-46},{-10,-26}})));
public
  Modelica.Blocks.Sources.CombiTimeTable
                                       inputSolTTH(
    tableOnFile=true,
    tableName="data",
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    final fileName=dirPath+filNam)
    "input for solGloHor and solDifHor measured at TTH"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

initial equation
  assert(exp==1 or exp==2, "Only experiment numbers 1 or 2 are supported.");
  assert(not
            (exp==2 and bui==2), "Combination of exp=2 and bui=2 does not exist");

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
  connect(vent.port_a, struct.port_b) annotation (Line(points={{0,32},{
          0,32},{-29,32},{-29,22},{-29,10}},
                                           color={0,0,0}));
  connect(struct.port_a, vent.port_b) annotation (Line(points={{-25,10},
          {-24,10},{-24,28},{0,28}},              color={0,0,0}));
          for i in 1:struct.nZones loop
          end for;
  connect(noInput[1:7].y, heaSys.TSet) annotation (Line(points={{-9,-36},{20,-36},
          {20,-10.2}},               color={0,0,127}));
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
