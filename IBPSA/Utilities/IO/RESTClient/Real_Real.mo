within IBPSA.Utilities.IO.RESTClient;
model SocCli "The socket client "
  extends Modelica.Blocks.Interfaces.DiscreteBlock(
    startTime=0,
    firstTrigger(fixed=true, start=false),final samplePeriod= samPer);
  parameter Integer numVar(min=1)
    "The number of inputs";
  parameter String host = "127.0.0.1"
    "The host name";
  parameter Integer port = 8888
    "The TCP port";
  parameter Boolean WriEn = true
    "The TCP port";
  Integer reVal
    "The return value";

  Modelica.Blocks.Interfaces.RealInput u1[numVar]
    "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  outer parameter Boolean OveEn "If overwritten is enabled";
  outer parameter Real samPer;
  Real Ove[numVar]
    "Overwritten signals";

  Modelica.Blocks.Interfaces.RealOutput y[numVar]
    "Connector of Real output signal"    annotation (Placement(transformation(extent={{100,-20},
            {140,20}}),enable=OveEn,visible=WriEn));
  Modelica.Blocks.Logical.Switch switch[numVar]
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})),enable=OveEn,visible=OveEn);
  Modelica.Blocks.Sources.RealExpression realExpression1[numVar](y=Ove)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})),enable=OveEn,visible=OveEn);
  Modelica.Blocks.Math.RealToBoolean realToBoolean[numVar]
    annotation (Placement(transformation(extent={{-50,-8},{-34,8}}),enable=OveEn,visible=OveEn));
equation

       when {sampleTrigger and OveEn} then
          (Ove,reVal) =Soc(
      numVar,
      u1,
      host,
      port);
//           Modelica.Utilities.Streams.error("Ove (= " + String(Ove[20]) + ") has to be in the range 0 .. 1");
       end when;

  connect(realExpression1.y, realToBoolean.u)
    annotation (Line(points={{-67,0},{-67,0},{-51.6,0}}, color={0,0,127}));
  connect(switch.u1, realExpression1.y) annotation (Line(points={{-14,8},{-22,8},
          {-22,20},{-60,20},{-60,0},{-67,0}}, color={0,0,127}));
  connect(switch.u3, u1) annotation (Line(points={{-14,-8},{-26,-8},{-26,-28},{-96,
          -28},{-96,0},{-120,0}},   color={0,0,127}));
  connect(realToBoolean.y, switch.u2)
    annotation (Line(points={{-33.2,0},{-33.2,0},{-14,0}}, color={255,0,255}));

   if OveEn then

       for j in 1:numVar loop
        switch[j].y=y[j];
       end for;
      else
       for j in 1:numVar loop
          y[j]=u1[j];
       end for;
       end if;

  annotation (uses(Modelica(version="3.2.2")));
end SocCli;
