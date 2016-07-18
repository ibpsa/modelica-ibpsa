within IDEAS.Buildings.Components.BaseClasses.ZoneAirModels;
model Thermal
  "Simple thermal zone air model without other fluid properties or mass exchange"
  extends IDEAS.Buildings.Components.BaseClasses.ZoneAirModels.PartialAirModel(
    m_flow_nominal=0,
    nSurf=1,
    useFluPor=false);

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=Vtot*1.204*1014
        *mSenFac) "Heat capacitor that represents the zone air heat capacity"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
equation
  E=heaCap.T*heaCap.C;
  for i in 1:nSurf loop
  connect(heaCap.port, ports_surf[i])
    annotation (Line(points={{0,0},{-100,0}}, color={191,0,0}));
  end for;
  for i in 1:nSeg loop
  connect(heaCap.port, ports_air[i])
    annotation (Line(points={{0,0},{52,0},{100,0}}, color={191,0,0}));
  end for;
  connect(senTem.port, heaCap.port)
    annotation (Line(points={{0,-60},{0,-60},{0,0}}, color={191,0,0}));
  connect(senTem.T, Tair)
    annotation (Line(points={{20,-60},{108,-60}}, color={0,0,127}));
end Thermal;
