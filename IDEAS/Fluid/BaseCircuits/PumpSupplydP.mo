within IDEAS.Fluid.BaseCircuits;
model PumpSupplydP

  //Extensions
  extends Interfaces.CircuitWithPump;
  extends IDEAS.Fluid.Actuators.BaseClasses.ValveParameters(
    final CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=KV);

  //Parameters
  parameter Real KV "Fixed KV value of the balancing valve";

  //Interfaces
  Modelica.Blocks.Interfaces.RealInput u "Control input signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,114})));
  Modelica.Blocks.Interfaces.RealOutput T "Supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,106})));

  //Components
  IDEAS.Fluid.Movers.FlowMachine_dp fan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    motorCooledByFluid=motorCooledByFluid,
    motorEfficiency=motorEfficiency,
    hydraulicEfficiency=hydraulicEfficiency,
    addPowerToMedium=addPowerToMedium)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  IDEAS.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    CvData=CvData,
    Kv=Kv,
    rhoStd=rhoStd,
    deltaM=deltaM,
    m_flow_nominal=m_flow_nominal) annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

  Modelica.Blocks.Sources.Constant hlift(k=1)
    "Constant opening of the balancing valve"
    annotation (Placement(transformation(extent={{-38,-20},{-18,0}})));

  Sensors.TemperatureTwoPort senTem(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tau=120)
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
equation
  connect(u, fan.dp_in) annotation (Line(
      points={{0,114},{0,72},{-0.2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hlift.y,val1. y) annotation (Line(
      points={{-17,-10},{0,-10},{0,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val1.port_b, port_b2) annotation (Line(
      points={{-10,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_b, senTem.port_a) annotation (Line(
      points={{10,60},{50,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, port_b1) annotation (Line(
      points={{70,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, T) annotation (Line(
      points={{60,71},{60,84},{68,84},{68,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, fan.port_a) annotation (Line(
      points={{-60,60},{-10,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, pipeReturn.port_b) annotation (Line(
      points={{10,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html><p>
            This model is the base circuit implementation of a pressure head controlled pump and makes use of <a href=\"modelica://IDEAS.Fluid.Movers.FlowMachine_dp\">IDEAS.Fluid.Movers.FlowMachine_dp</a>. The flow can be regulated by changing the Kv value of the balancing valve.
            </p><p>Note that an hydronic optimization might be necessary to obtain a meaningfull value for the Kv parameter.</p></html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
        Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-10,10},{-10,-22},{22,-6},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-2,66},
          rotation=360),
        Ellipse(
          extent={{-20,80},{20,40}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{-10,-22},{22,-6},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-2,66},
          rotation=360),
        Text(
          extent={{-10,70},{8,50}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          textString="dP"),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-10,-60},
          rotation=360),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={10,-60},
          rotation=180),
        Line(
          points={{0,-60},{0,-44}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-6,-44},{6,-44}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{0,100},{4,86},{0,70}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{70,100},{76,80},{74,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{72,62},{76,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end PumpSupplydP;
