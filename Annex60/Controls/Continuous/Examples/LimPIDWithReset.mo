within Annex60.Controls.Continuous.Examples;
model LimPIDWithReset
  "Example that demonstrates the controller output reset"
  extends Modelica.Icons.Example;

  Plant plaWitRes "Plant connected to controller with reset" annotation (
      Placement(transformation(extent={{20,40},{40,60}})));
  Controller conWitRes(reset=Annex60.Types.Reset.Parameter)
    "Controller with reset" annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Plant plaNoRes "Plant connected to controller without reset" annotation (
      Placement(transformation(extent={{20,-20},{40,0}})));
  Controller conNoRes(reset=Annex60.Types.Reset.Disabled)
    "Controller without reset" annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=20,
    width=50,
    offset=293.15,
    y(unit="K"),
    period=180)    "Temperature set point"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

protected
  model Plant
    "Plant model"
    extends Modelica.Blocks.Icons.Block;


    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap(C=10, T(fixed=true,
          start=293.15)) "Heat capacitor"
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
      "Temperature sensor"
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
    Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
      "Heat flow sensor"
      annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
      "Prescribed heat flow rate"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W") annotation (Placement(
          transformation(extent={{-120,-10},{-100,10}})));
    Modelica.Blocks.Interfaces.RealOutput T(unit="K") annotation (Placement(
          transformation(extent={{100,-10},{120,10}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=5)
      "Thermal conductor"
      annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBou(T=293.15)
      "Boundary condition"
      annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon1(G=1)
      "Thermal conductor"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap1(C=10, T(fixed=true,
          start=293.15)) "Heat capacitor"
      annotation (Placement(transformation(extent={{44,0},{64,20}})));
  equation
    connect(preHea.port,heaFloSen. port_a)
      annotation (Line(points={{-40,0},{-30,0}}, color={191,0,0}));
    connect(heaFloSen.port_b,cap. port)
      annotation (Line(points={{-10,0},{0,0},{10,0}},    color={191,0,0}));
    connect(Q_flow, preHea.Q_flow)
      annotation (Line(points={{-110,0},{-96,0},{-60,0}}, color={0,0,127}));
    connect(T, temSen.T)
      annotation (Line(points={{110,0},{90,0}},        color={0,0,127}));
    connect(TBou.port, theCon.port_a)
      annotation (Line(points={{-40,-40},{-34,-40},{-28,-40}}, color={191,0,0}));
    connect(cap.port, theCon1.port_a)
      annotation (Line(points={{10,0},{20,0}}, color={191,0,0}));
    connect(theCon1.port_b, cap1.port)
      annotation (Line(points={{40,0},{54,0}}, color={191,0,0}));
    connect(cap1.port, temSen.port)
      annotation (Line(points={{54,0},{62,0},{70,0}}, color={191,0,0}));
    connect(theCon.port_b, cap.port)
      annotation (Line(points={{-8,-40},{10,-40},{10,0}}, color={191,0,0}));
    annotation (Documentation(info="<html>
<p>
Plant model for
<a href=\"modelica://Annex60.Controls.Continuous.Examples.LimPIDWithReset\">
Annex60.Controls.Continuous.Examples.LimPIDWithReset</a>.
consisting of a simple heat transfer model.
</p>
<h4>Implementation</h4>
<p>
To compare the effect of the controller output reset, the plant and control
models have been implemented in separate blocks so they can be instantiated
twice in the system model with the appropriate control settings.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 3, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Plant;

  model Controller "PID controller with optional output reset"
    extends Modelica.Blocks.Icons.Block;
    parameter Types.Reset reset=Annex60.Types.Reset.Disabled
      "Type of controller output reset";

    Modelica.Blocks.Interfaces.RealInput TSet(unit="K") "Temperature set point"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    Modelica.Blocks.Interfaces.RealInput u_m(unit="K")
      "Measured temperature"
      annotation (Placement(transformation(
            rotation=90,extent={{-10,-10},{10,10}},
          origin={0,-110}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,-110})));

    Annex60.Controls.Continuous.LimPID conPID(
      final reset=reset,
      yMax=1,
      yMin=0,
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=1,
      k=10) "PID controller"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Math.Gain gain(k=5000)
                                          "Gain for heat flow rate"
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    Modelica.Blocks.Logical.GreaterThreshold trigger(threshold=303.15)
      "Trigger input for controller reset"
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

    Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
            extent={{100,-10},{120,10}}), iconTransformation(extent={{
              100,-10},{120,10}})));

  equation
    connect(conPID.y,gain. u)
      annotation (Line(points={{11,0},{11,0},{28,0}},
                                                   color={0,0,127}));
    connect(trigger.y,conPID. trigger) annotation (Line(points={{-19,-30},{-8,-30},
            {-8,-12}},  color={255,0,255}));
    connect(u_m, conPID.u_m) annotation (Line(points={{0,-110},{0,-12}},
                        color={0,0,127}));
    connect(conPID.u_s, TSet) annotation (Line(points={{-12,0},{-70,0},{-120,0}},
                      color={0,0,127}));
    connect(trigger.u, TSet) annotation (Line(points={{-42,-30},{-70,-30},{-70,0},
            {-120,0}}, color={0,0,127}));
    connect(gain.y, y)
      annotation (Line(points={{51,0},{100,0},{110,0}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
Controller model for
<a href=\"modelica://Annex60.Controls.Continuous.Examples.LimPIDWithReset\">
Annex60.Controls.Continuous.Examples.LimPIDWithReset</a>.
</p>
<p>
The controller is reset whenever the input signal becomes bigger than
<i>30</i>&deg;C.
</p>
<h4>Implementation</h4>
<p>
To compare the effect of the controller output reset, the plant and control
models have been implemented in separate blocks so they can be instantiated
twice in the system model with the appropriate control settings.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 3, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Controller;

equation
  connect(plaWitRes.T, conWitRes.u_m) annotation (Line(points={{41,50},{60,50},{
          60,20},{-30,20},{-30,39}}, color={0,0,127}));
  connect(conWitRes.y, plaWitRes.Q_flow)
    annotation (Line(points={{-19,50},{19,50}}, color={0,0,127}));

  connect(plaNoRes.T, conNoRes.u_m) annotation (Line(points={{41,-10},{60,-10},{
          60,-40},{-30,-40},{-30,-21}}, color={0,0,127}));
  connect(conNoRes.y, plaNoRes.Q_flow)
    annotation (Line(points={{-19,-10},{19,-10}}, color={0,0,127}));
  connect(TSet.y, conWitRes.TSet) annotation (Line(points={{-59,0},{-50,0},{-50,
          50},{-42,50}}, color={0,0,127}));
  connect(TSet.y, conNoRes.TSet) annotation (Line(points={{-59,0},{-50,0},{-50,-10},
          {-42,-10}}, color={0,0,127}));
 annotation (
experiment(StopTime=600),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Controls/Continuous/Examples/LimPIDWithReset.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that demonstrates the effect
of the integrator reset.
The top model has the reset of the controller output enabled.
By plotting the controller error, one sees that the integrator reset
improves the closed loop performance slightly.
Note, however, that both controllers have an integrator anti-windup
and hence the integrator reset has limited benefits.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LimPIDWithReset;
