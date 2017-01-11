within IDEAS.Examples.TwinHouses.BaseClasses.HeatingSystems;
model ScheduleExp1
  parameter Integer[4] Schedule={20044800,20800000,22119000,22637400};
  parameter Modelica.SIunits.Temperature Tinit1=303.15;
  parameter Modelica.SIunits.Temperature Tinit2=298.15;
  parameter String filename = "meas_TTH_N2.txt";
  Modelica.Blocks.Interfaces.RealInput[7] TSensor
    annotation (Placement(transformation(extent={{-130,-20},{-90,20}})));
  Modelica.Blocks.Interfaces.RealOutput[7] y
    annotation (Placement(transformation(extent={{86,58},{130,102}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                       measuredInput(
    tableOnFile=true,
    tableName="data",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(Modelica.Utilities.Files.loadResource("modelica://IDEAS") + "/Inputs/"+filename),
    columns=2:15,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-56,50},{-36,70}})));
  Modelica.Blocks.Math.UnitConversions.From_degC[7] TdegC
    annotation (Placement(transformation(extent={{16,56},{36,76}})));
  Modelica.Blocks.Interfaces.RealOutput[7] TSet_IDEAL
    annotation (Placement(transformation(extent={{90,-62},{134,-18}})));
  Modelica.Blocks.Interfaces.RealOutput[7] Pel_IDEAL
    annotation (Placement(transformation(extent={{92,-102},{136,-58}})));
equation
  TSet_IDEAL= TdegC.y;
  Pel_IDEAL[1] = measuredInput.y[8];
  Pel_IDEAL[2]=0;
  Pel_IDEAL[3]=measuredInput.y[9];
  Pel_IDEAL[4]=measuredInput.y[10];
  Pel_IDEAL[5]=measuredInput.y[11]+measuredInput.y[12];
  Pel_IDEAL[6]=measuredInput.y[13];
  Pel_IDEAL[7]=measuredInput.y[14];
if time <Schedule[2] then
  y[1]=max(0,100000*(Tinit1-TSensor[1]));
  y[2]=0;
  y[3]=max(0,100000*(Tinit1-TSensor[3]));
  y[4]=max(0,100000*(Tinit1-TSensor[4]));
  y[5]=max(0,100000*(Tinit1-TSensor[5]));
  y[6]=max(0,100000*(Tinit1+30-TSensor[6]));
  y[7]=max(0,100000*(Tinit1+30-TSensor[7]));
elseif (time>=Schedule[2] and time < Schedule[3]) or time >=Schedule[4] then
  y=Pel_IDEAL;
elseif time>=Schedule[3] and time < Schedule[4] then
  y[1]=max(0,100000*(Tinit2-TSensor[1]));
  y[2]=0;
  y[3]=max(0,100000*(Tinit2-TSensor[3]));
  y[4]=max(0,100000*(Tinit2-TSensor[4]));
  y[5]=max(0,100000*(Tinit2-TSensor[5]));
  y[6]=max(0,100000*(Tinit2-TSensor[6]));
  y[7]=max(0,100000*(Tinit2-TSensor[7]));
else
  y=Pel_IDEAL;
end if;
  connect(measuredInput.y[1:7],TdegC [1:7].u) annotation (Line(points={{-35,60},
          {-10,60},{-10,66},{14,66}},
                             color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
                                   Text(
          extent={{-28,60},{-14,54}},
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
end ScheduleExp1;
