within IDEAS.Examples.TwinHouses;
model BuildingN2_Exp1_TB
  "Model for simulation of experiment 1 for the N2 building"
 extends Modelica.Icons.Example;
  BaseClasses.Structures.TwinhouseN2_TB struct(T_start={303.15,303.15,303.15,303.15,303.15,303.15,
        303.15})
    annotation (Placement(transformation(extent={{-42,-10},{-12,10}})));
  BaseClasses.HeatingSystems.ElectricHeating_Twinhouse_exp1 heaSys(
    nEmbPorts=0,
    nZones=struct.nZones,
    InInterface=true,
    nLoads=0,
    Crad={1000,1000,1000,1000,1100,1000,100},
    Q_design={2000,750,750,750,750,750,750},
    Kemission={100,100,100,100,110,100,100})
    annotation (Placement(transformation(extent={{0,-10},{40,10}})));
   BaseClasses.Ventilation.Vent_TTH vent(
      nZones=struct.nZones,
      VZones=struct.VZones,
      redeclare package Medium = IDEAS.Media.Air)
      annotation (Placement(transformation(extent={{0,20},{40,40}})));
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
      lat=0.83555892609977,
      lon=0.20469221467389,
      linIntRad=false,
      linExtRad=false,
    radSol(each rho=0.23))
      annotation (Placement(transformation(extent={{-68,64},{-48,84}})));

    Modelica.Blocks.Sources.RealExpression[8] noInput
      annotation (Placement(transformation(extent={{-30,-46},{-10,-26}})));
    Modelica.Blocks.Tables.CombiTable1Ds inputSolTTH(
      tableOnFile=true,
      tableName="data",
      fileName=
          IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(Modelica.Utilities.Files.loadResource("modelica://IDEAS") + "//Inputs//"+"weatherinput.txt"),
      columns=2:30,
      smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2)
      "input for solGloHor and solDifHor measured at TTH"
      annotation (Placement(transformation(extent={{-92,64},{-72,84}})));

equation
  if time> 20044800 then
  inputSolTTH.u= sim.timMan.timCal;
  else
  inputSolTTH.u = 20044800;
  end if;
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
          -36},{20,-10},{20,-10.2}}, color={0,0,127}));
  connect(noInput[8].y, heaSys.mDHW60C) annotation (Line(points={{-9,-36},{26,
          -36},{26,-10.2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=1.5e+007,
      StopTime=2.35872e+007,
      Interval=900,
      Tolerance=1e-006));
end BuildingN2_Exp1_TB;
