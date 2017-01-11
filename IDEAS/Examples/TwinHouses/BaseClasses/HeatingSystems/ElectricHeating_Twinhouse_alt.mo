within IDEAS.Examples.TwinHouses.BaseClasses.HeatingSystems;
model ElectricHeating_Twinhouse_alt
  "Electric heating Twinhouse| alternative temperature or heat input"

  extends IDEAS.Templates.Interfaces.BaseClasses.HeatingSystem(
    nLoads=1,nZones=7,nEmbPorts=0);

  parameter Integer Exp= 1;
  parameter Real[nZones] Crad "thermal mass of radiator";
  parameter Real[nZones] Kemission "heat transfer coefficient";
  parameter Real COP=1;

  final parameter Real frad=0.3 "radiative fraction";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] IDEAL_heating_con
    annotation (Placement(transformation(extent={{8,-12},{-12,8}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] IDEAL_heating_rad
    annotation (Placement(transformation(extent={{6,-44},{-14,-24}})));
  ScheduleExp1 scheduleExp1_1
    annotation (Placement(transformation(extent={{88,64},{56,34}})));

equation

  P[1] = QHeaSys/COP;
  Q[1] = 0;
  QHeaSys=sum(scheduleExp1_1.y);

  for i in 1:nZones loop
  IDEAL_heating_rad[i].Q_flow = frad*min(scheduleExp1_1.y[i],Q_design[i]);
  IDEAL_heating_con[i].Q_flow=(1-frad)*min(scheduleExp1_1.y[i],Q_design[i]);
  end for;


  connect(IDEAL_heating_con.port, heatPortCon) annotation (Line(
      points={{-12,-2},{-106,-2},{-106,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(IDEAL_heating_rad.port, heatPortRad) annotation (Line(
      points={{-14,-34},{-108,-34},{-108,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSensor, scheduleExp1_1.TSensor) annotation (Line(points={{-204,-60},{
          -48,-60},{104,-60},{104,49},{89.6,49}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},
            {200,100}})));
end ElectricHeating_Twinhouse_alt;
