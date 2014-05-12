within Annex60.Experimental.Benchmarks.CentralHeatingSystem;
model System1
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= 0.01; // IDA model: mean value of 0.01 kg/s during simulation experiment
  package Medium = Annex60.Media.Water 
  "Medium model";
  Annex60.Experimental.Benchmarks.CentralHeatingSystem.BaseClasses.Room1stOrder room(
    T_start = 273.15 + 23.5, // IDA model: ROOM.Troom = 23.5 °C
    CRoom=2000000.0,  // IDA model: ROOM.Croom = 2000000.0 J/K
    UAmb= 1.0, // IDA model: ROOM.Rroom = 0.06 K/W
    AAmb= 1.0/(0.06*room.UAmb)) //  AAmbient = 1 / (Rroom * UAmbient) = 1 / (0.06 K/W * 1.0 W/(m2.K)) = 16.67 m2
    "Room model" 
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Annex60.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium,
    V_start=0.1) 
    "Expansion vessel model"
    annotation (Placement(transformation(extent={{22,-42},{34,-30}})));
  Annex60.Fluid.FixedResistances.FixedResistanceDpM pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=8000.0) // IDA model PIPE: mean value of 8000 Pa during simulation experiment
    "Pipe model"
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));
  Annex60.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=10.0) 
    "Boiler model"
    annotation (Placement(transformation(extent={{10,-58},{-10,-38}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal, 
    Q_flow_nominal=1500.0, // IDA model: RADIATOR.Firadnom = 1500 W
    VWat=0.005, // IDA model: RADIATOR.Mw = 0.5 kg
    mDry=0.0001, // no additional mass (mDry=0.0 doesn't work)
    //nEle=1, // one node in the benchmark model
    nEle=6,// necessary for numerical stability
    fraRad=0, // only het transfer by convection is considered
    T_a_nominal=273.15 + 90.0, // nominal water inlet temperature
    T_b_nominal=273.15 + 70, // nominal water oulet temperature
    TAir_nominal=273.15 + 20.0, // nominal air temperature
    n=1.3, // in IDA: part of the radiator model
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) 
    "radiator model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature climate
    "Temperature conversion"
    annotation (Placement(transformation(extent={{36,24},{24,36}})));
  Annex60.Fluid.FixedResistances.FixedResistanceDpM pip2(
    redeclare package Medium =  Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=2000.0)   // IDA model PIPE1:  mean value of 2000 Pa during simulation experiment
    "Pipe model"
    annotation (Placement(transformation(extent={{-14,-58},{-34,-38}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 60.0) // IDA model: HEATEXCH.TSet = 60 °C
    annotation (Placement(transformation(extent={{20,-44},{16,-40}})));
  Annex60.Fluid.FixedResistances.FixedResistanceDpM pip3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=2000.0) // IDA model PIPE2:  mean value of 2000 Pa during simulation experiment
    "Pipe model"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Annex60.Fluid.Actuators.Valves.Data.Generic datVal(
    y={0,0.1667,0.3333,0.5,0.6667,1},
    phi={0, 0.19, 0.35, 0.45, 0.5, 0.65}/0.65) 
    "Valve characteristics"
    annotation (Placement(transformation(extent={{-100,24},{-80,44}})));
  Fluid.Actuators.Valves.TwoWayTable val(
    redeclare package Medium = Medium,
    filteredOpening=false,
    from_dp=true,
    flowCharacteristics=datVal,
    CvData=Annex60.Fluid.Types.CvTypes.Kv,
    Kv=0.65,
    m_flow_nominal=m_flow_nominal)
    "Valve model with opening characteristics based on a table"
    annotation (Placement(transformation(extent={{-34,-10},{-14,10}}, rotation=0)));
  Modelica.Blocks.Continuous.LimPID thermostat(
    k=0.5, // IDA model Tset = 22°C, DeadBand = 2 K -> y = 0.5 * (u_s - u_m)
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1.0, // valve tot 
    yMin=0.0,// valve totally closedally open
    wp=1.0) 
    "Thermostat, modelled by a limeted p-controller"
    annotation (Placement(transformation(extent={{4,-4},{-4,4}},rotation=90,origin={-24,30})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tempSen
    annotation (Placement(transformation(extent={{-2,26},{-10,34}})));
  Buildings.Fluid.Movers.FlowMachine_dp pump(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Modelica.Blocks.Sources.Constant dpSet(k=12000.0) // Sum of all pressure losses
    "Set presure for the pump model"
    annotation (Placement(transformation(extent={{-66,18},{-70,22}})));
  Modelica.Blocks.Tables.CombiTable1D climateData(
    tableName = "tab",
    fileName = ModelicaServices.ExternalReferences.loadResource("modelica://Annex60/Experimental/Benchmarks/CentralHeatingSystem/COP_try.prn"),
    columns = {2},
    tableOnFile = true) 
    "Table with weather date" // Same weather data as in IDA ICE
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},rotation=180,origin={66,30})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation(Placement(transformation(extent={{54,24},{42,36}})));
  Fluid.Delays.DelayFirstOrder del(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nPorts=3) 
    "Fixes the division by zero bug in Dymola 2014 FD1"
    annotation (Placement(transformation(extent={{-3,-3},{3,3}},rotation=180,origin={29,-51})));
  Modelica.Blocks.Sources.Constant TAirSet(k=273.15 + 22.0)
    annotation (Placement(transformation(extent={{-18,36},{-22,40}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{98,26},{90,34}})));
  Modelica.Blocks.Math.Gain gain(k=1/3600.0)
    annotation (Placement(transformation(extent={{86,26},{78,34}})));
equation
  connect(rad.port_b, pip1.port_a) annotation (Line(
      points={{10,0},{14,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad.heatPortCon, room.port_sou) annotation (Line(
    points={{-2,7.2},{-2,30},{2,30}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(room.port_amb, climate.port) annotation (Line(
      points={{18,30},{24,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pip2.port_a, hea.port_b) annotation (Line(
      points={{-14,-48},{-10,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.u, TSet.y) annotation (Line(
      points={{12,-42},{15.8,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pip3.port_b, val.port_a) annotation (Line(
      points={{-38,0},{-34,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val.port_b, rad.port_a) annotation (Line(
      points={{-14,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tempSen.port, room.port_sou) annotation (Line(
      points={{-2,30},{2,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump.port_b, pip3.port_a) annotation (Line(
      points={{-62,0},{-58,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip2.port_b, pump.port_a) annotation (Line(
      points={{-34,-48},{-88,-48},{-88,0},{-82,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSet.y, pump.dp_in) annotation (Line(
      points={{-70.2,20},{-72.2,20},{-72.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(climate.T, from_degC.y) annotation (Line(
    points={{37.2,30},{41.4,30}},
    color={0,0,127},
    smooth=Smooth.None));
  connect(from_degC.u, climateData.y[1]) annotation (Line(
    points={{55.2,30},{59.4,30}},
    color={0,0,127},
    smooth=Smooth.None));
  connect(del.ports[1], pip1.port_b) annotation (Line(
      points={{29.8,-48},{38,-48},{38,0},{34,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, del.ports[2]) annotation (Line(
      points={{10,-48},{29,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(del.ports[3], exp.port_a) annotation (Line(
      points={{28.2,-48},{28.2,-46},{28,-46},{28,-42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thermostat.y, val.y) annotation (Line(
      points={{-24,25.6},{-24,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermostat.u_m, tempSen.T) annotation (Line(
      points={{-19.2,30},{-10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAirSet.y, thermostat.u_s) annotation (Line(
      points={{-22.2,38},{-24,38},{-24,34.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(climateData.u[1], gain.y) annotation (Line(
      points={{73.2,30},{77.6,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, clock.y) annotation (Line(
      points={{86.8,30},{89.6,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),graphics),
  experiment(StopTime=31536000),
  __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Benchmarks/CentralHeatingSystem/System1.mos"
        "Simulate and plot"),
  Documentation(info="<html>
  <p>
  Benchmark model for a water heating system.
  The heating system supplies a strong simplified building model, based on one thermal capicity.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  May 7, 2014 by Christoph Nytsch-Geusen:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end System1;
