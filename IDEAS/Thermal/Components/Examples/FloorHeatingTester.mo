within IDEAS.Thermal.Components.Examples;
model FloorHeatingTester "Simple floorheating tester"

  /*
  This test model is checking the tabs power and outlet temperature for different cases
  - step up on the input temp
  - step down on the input temp
  - step up in flowrate
  - step down in flowrate
  
  Check all the reactions to these steps carefully before using a tabs model.
    
  */

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Modelica.SIunits.Area A_Floor=20;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        medium, p=200000)
    annotation (Placement(transformation(extent={{34,-54},{54,-34}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=medium,
    m_flowNom=300/3600,
    useInput=true,
    m=0,
    TInitial=293.15)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  replaceable IDEAS.Thermal.Components.Emission.Tabs
                                                   tabs(
    medium=medium,
    m_flowMin=15*20/3600,
    A_Floor=A_Floor,
    redeclare IDEAS.Thermal.Components.Emission.FH_Standard2
                                                           FHChars)
     constrainedby IDEAS.Thermal.Components.Emission.Auxiliaries.Partial_Tabs(
       medium=medium,
       m_flowMin=15*20/3600,
       A_Floor=A_Floor,
       redeclare IDEAS.Thermal.Components.Emission.FH_Standard2 FHChars)
    "tabs model"
               annotation (Placement(transformation(extent={{68,2},{88,22}})));
  inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{32,24},{52,44}})));
  Modelica.Blocks.Sources.Sine step(
    startTime=50000,
    offset=293.15,
    amplitude=2,
    freqHz=1/86400)
    annotation (Placement(transformation(extent={{-10,72},{10,92}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection
    annotation (Placement(transformation(extent={{88,64},{68,44}})));
  Modelica.Blocks.Sources.TimeTable tempTable(
    offset=0,
    startTime=0,
    table=[0,293.15; 5000,293.15; 5000,303.15; 150000,303.15; 150000,293.15;
        300000,293.15])
    annotation (Placement(transformation(extent={{-50,-38},{-36,-24}})));
  Thermal.Components.BaseClasses.HeatedPipe heatedPipe(medium=medium, m=0)
    annotation (Placement(transformation(extent={{-28,-86},{-8,-66}})));
  Thermal.Components.BaseClasses.HeatedPipe heatedPipe1(medium=medium, m=0)
    annotation (Placement(transformation(extent={{8,-16},{28,4}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
  Modelica.Blocks.Sources.TimeTable m_flowTable(
    offset=0,
    startTime=0,
    table=[0,0; 500,0; 500,1; 20000,1; 20000,0; 25000,0; 25000,1; 40000,1;
        40000,0; 45000,0])
    annotation (Placement(transformation(extent={{-74,32},{-54,52}})));
  Modelica.Blocks.Sources.Constant const(k=293.15)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{-74,2},{-54,22}})));
  Modelica.Blocks.Sources.Step const2(
    height=10,
    offset=293.15,
    startTime=5000)
    annotation (Placement(transformation(extent={{-50,-62},{-36,-48}})));
equation
  convection.Gc = 11*A_Floor;

  connect(absolutePressure.flowPort, tabs.flowPort_a)          annotation (Line(
      points={{34,-44},{34,-30},{48,-30},{48,16},{68,16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tabs.port_a, convection.solid) annotation (Line(
      points={{78,22},{80,22},{80,32},{94,32},{94,54},{88,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, prescribedTemperature.port) annotation (Line(
      points={{68,54},{62,54},{62,34},{52,34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tabs.flowPort_b, heatedPipe.flowPort_b) annotation (Line(
      points={{68,8},{62,8},{62,-76},{-8,-76}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_a, volumeFlow1.flowPort_a) annotation (Line(
      points={{-28,-76},{-42,-76},{-42,-74},{-62,-74},{-62,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(volumeFlow1.flowPort_b, heatedPipe1.flowPort_a) annotation (Line(
      points={{-16,-6},{8,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe1.flowPort_b, tabs.flowPort_a) annotation (Line(
      points={{28,-6},{34,-6},{34,-4},{44,-4},{44,16},{68,16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, heatedPipe1.heatPort) annotation (Line(
      points={{10,-38},{18,-38},{18,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const.y, prescribedTemperature.T) annotation (Line(
      points={{11,50},{18,50},{18,34},{30,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-53,12},{-26,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tempTable.y, prescribedTemperature1.T) annotation (Line(
      points={{-35.3,-31},{-22,-31},{-22,-38},{-12,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=40000, Interval=10),
    __Dymola_experimentSetupOutput,
    Commands(file="Scripts/Tester_FloorHeating.mos" "RunTester"));
end FloorHeatingTester;
