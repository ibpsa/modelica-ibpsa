within IDEAS.Examples.TwinHouses.BaseClasses.HeatingSystems;
model ElectricHeating_Twinhouse_exp1
  "Electric heating Twinhouse|exp2| alternative temperature or heat input"

  extends IDEAS.Templates.Interfaces.BaseClasses.HeatingSystem(
    nLoads=1);

parameter Real[nZones] Crad "thermal mass of radiator";
parameter Real[nZones] Kemission "heat transfer coefficient";
parameter Real COP=1;
Real[nZones] TsetIDEAL;
final parameter Real frad=0.3 "radiative fraction";
  Modelica.SIunits.HeatFlowRate IDEAL_heating[nZones];
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] IDEAL_heating_con
    annotation (Placement(transformation(extent={{8,-12},{-12,8}})));

  Modelica.Blocks.Tables.CombiTable1Ds measuredInput(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(Modelica.Utilities.Files.loadResource("modelica://IDEAS") + "/Inputs/"+"meas_TTH_N2.txt"),
    columns=2:15)
    annotation (Placement(transformation(extent={{38,24},{58,44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] IDEAL_heating_rad
    annotation (Placement(transformation(extent={{6,-44},{-14,-24}})));
  Modelica.Blocks.Math.UnitConversions.From_degC[8] TdegC
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
equation
  IDEAL_heating = IDEAL_heating_con.Q_flow/0.7;
P[1] = QHeaSys/COP;
Q[1] = 0;
TsetIDEAL= measuredInput.y[1:7];
if time <20044800 then
  IDEAL_heating_con[1].Q_flow=0.7*max(0,100000*(273.15+30-TSensor[1]));
  IDEAL_heating_con[2].Q_flow=0;
  IDEAL_heating_con[3].Q_flow=0.7*max(0,100000*(273.15+30-TSensor[3]));
  IDEAL_heating_con[4].Q_flow=0.7*max(0,100000*(273.15+30-TSensor[4]));
  IDEAL_heating_con[5].Q_flow=0.7*max(0,100000*(273.15+30-TSensor[5]));
  IDEAL_heating_con[6].Q_flow=0.7*max(0,100000*(273.15+30-TSensor[6]));
  IDEAL_heating_con[7].Q_flow=0.7*max(0,100000*(273.15+30-TSensor[7]));
elseif time >=20044800 and time < 20800000 then
  IDEAL_heating_con[1].Q_flow=0.7*( min(max(0,100000*(273.15+30-TSensor[1])),Q_design[1]));
  IDEAL_heating_con[2].Q_flow=0;
  IDEAL_heating_con[3].Q_flow=0.7*( min(max(0,100000*(273.15+30-TSensor[3])),Q_design[3]));
  IDEAL_heating_con[4].Q_flow=0.7*( min(max(0,100000*(273.15+30-TSensor[4])),Q_design[4]));
  IDEAL_heating_con[5].Q_flow=0.7*( min(max(0,100000*(273.15+30-TSensor[5])),Q_design[5]));
  IDEAL_heating_con[6].Q_flow=0.7*( min(max(0,100000*(273.15+30-TSensor[6])),Q_design[6]));
  IDEAL_heating_con[7].Q_flow=0.7*( min(max(0,100000*(273.15+30-TSensor[7])),Q_design[7]));
elseif time>=20800000 and time < 22119000 then
  IDEAL_heating_con[1].Q_flow=0.7*( measuredInput.y[8]);
  IDEAL_heating_con[2].Q_flow=0;
  IDEAL_heating_con[3].Q_flow=0.7*( measuredInput.y[9]);
  IDEAL_heating_con[4].Q_flow=0.7*( measuredInput.y[10]);
  IDEAL_heating_con[5].Q_flow=0.7*( measuredInput.y[11]+measuredInput.y[12]);
  IDEAL_heating_con[6].Q_flow=0.7*( measuredInput.y[13]);
  IDEAL_heating_con[7].Q_flow=0.7*( measuredInput.y[14]);
elseif time>=22119000 and time < 22637400 then
 IDEAL_heating_con[1].Q_flow=0.7*( min(max(0,100000*(273.15+25-TSensor[1])),Q_design[1]));
  IDEAL_heating_con[2].Q_flow=0;
  IDEAL_heating_con[3].Q_flow=0.7*( min(max(0,100000*(273.15+25-TSensor[3])),Q_design[3]));
  IDEAL_heating_con[4].Q_flow=0.7*( min(max(0,100000*(273.15+25-TSensor[4])),Q_design[4]));
  IDEAL_heating_con[5].Q_flow=0.7*( min(max(0,100000*(273.15+25-TSensor[5])),Q_design[5]));
  IDEAL_heating_con[6].Q_flow=0.7*( min(max(0,100000*(273.15+25-TSensor[6])),Q_design[6]));
  IDEAL_heating_con[7].Q_flow=0.7*( min(max(0,100000*(273.15+25-TSensor[7])),Q_design[7]));
else
  IDEAL_heating_con[1].Q_flow=0;
  IDEAL_heating_con[2].Q_flow=0;
  IDEAL_heating_con[3].Q_flow=0;
  IDEAL_heating_con[4].Q_flow=0;
  IDEAL_heating_con[5].Q_flow=0+measuredInput.y[12];
  IDEAL_heating_con[6].Q_flow=0;
  IDEAL_heating_con[7].Q_flow=0;
end if;

IDEAL_heating_rad.Q_flow=IDEAL_heating_con.Q_flow/0.7*0.3;
QHeaSys=sum(heatPortRad.Q_flow+heatPortCon.Q_flow);

if time> 20044800 then
  measuredInput.u= sim.timMan.timCal;
  else
  measuredInput.u = 20044800;
  end if;
  connect(IDEAL_heating_con.port, heatPortCon) annotation (Line(
      points={{-12,-2},{-106,-2},{-106,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(IDEAL_heating_rad.port, heatPortRad) annotation (Line(
      points={{-14,-34},{-108,-34},{-108,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(measuredInput.y[1:8], TdegC[1:8].u) annotation (Line(points={{59,34},{84,34},
          {84,40},{108,40}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},
            {200,100}}), graphics={Text(
          extent={{66,34},{80,28}},
          lineColor={28,108,200},
          textString="Order of outputs: 
1: living T 125cm
2: corridor T
3: bath T
4: child T
5: Kit T
6: hall T
7: bedT
8: heat elp living
9: heat elp bath
10: heat elp bed1
11: heat elp kit
12: heat gainvent kit 
13: heat elp hall
14: heat elp bed 2")}));
end ElectricHeating_Twinhouse_exp1;
