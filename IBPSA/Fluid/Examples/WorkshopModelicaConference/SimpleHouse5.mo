within IBPSA.Fluid.Examples.WorkshopModelicaConference;
model SimpleHouse5 "Heating controller model"
  extends SimpleHouse4(pump(inputType=IBPSA.Fluid.Types.InputType.Stages,
        massFlowRates=mWat_flow_nominal*{1}),
        constantSourceHeater=false);

  Modelica.Blocks.Math.BooleanToInteger booleanToInt "Boolean to integer"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal "Boolean to real"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 21, uHigh=273.15 + 23)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Modelica.Blocks.Logical.Not not1
    "Negation for enabling heating when temperature is low"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{90,150},{70,170}})));
equation
  connect(booleanToInt.y, pump.stage) annotation (Line(points={{21,-140},{100,-140},
          {100,-158}},          color={255,127,0}));
  connect(booleanToInt.u,not1. y) annotation (Line(points={{-2,-140},{-11.5,-140},
          {-11.5,-100},{-19,-100}},
                                  color={255,0,255}));
  connect(booleanToReal.y, heaWat.u) annotation (Line(points={{21,-100},{40.5,-100},
          {40.5,-94},{58,-94}}, color={0,0,127}));
  connect(not1.u,hysRad. y) annotation (Line(points={{-42,-100},{-59,-100}},
                  color={255,0,255}));
  connect(senTemZonAir.T,hysRad. u) annotation (Line(points={{69,160},{-230,160},
          {-230,-100},{-82,-100}},            color={0,0,127}));
  connect(senTemZonAir.port, zone.heatPort) annotation (Line(points={{90,160},{
          110,160},{110,140}},       color={191,0,0}));
  connect(not1.y, booleanToReal.u)
    annotation (Line(points={{-19,-100},{-2,-100}}, color={255,0,255}));
end SimpleHouse5;
