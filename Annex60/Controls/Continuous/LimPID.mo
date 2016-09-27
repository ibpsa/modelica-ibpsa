within Annex60.Controls.Continuous;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
  import Modelica.Blocks.Types.InitPID;
  import Modelica.Blocks.Types.Init;
  import Modelica.Blocks.Types.SimpleController;
  extends Modelica.Blocks.Interfaces.SVcontrol;
  output Real controlError = u_s - u_m
    "Control error (set point - measurement)";
  parameter .Modelica.Blocks.Types.SimpleController controllerType=
         .Modelica.Blocks.Types.SimpleController.PID "Type of controller";
  parameter Real k(min=0, unit="1") = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == .Modelica.Blocks.Types.SimpleController.PI or
          controllerType == .Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == .Modelica.Blocks.Types.SimpleController.PD or
          controllerType == .Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1 "Upper limit of output";
  parameter Real yMin=0 "Lower limit of output";
  parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter .Modelica.Blocks.Types.InitPID initType= .Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(group="Initialization"));
      // Removed as the Limiter block no longer uses this parameter.
      // parameter Boolean limitsAtInit = true
      //  "= false, if limits are ignored during initialization"
      // annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
                         enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == .Modelica.Blocks.Types.InitPID.InitialOutput, group=
          "Initialization"));
  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter Boolean use_reset = false
    "Enables option to trigger a reset for the integrator part" annotation(Evaluate=true, Dialog(group="Integrator Reset"), choices(checkBox=true));
  constant Modelica.SIunits.Time unitTime=1 annotation (HideResult=true);

  Modelica.Blocks.Math.Add addP(k1=revAct*wp, k2=-revAct) "Adder for P gain"
                                                          annotation (Placement(
        transformation(extent={{-80,40},{-60,60}}, rotation=0)));
  Modelica.Blocks.Math.Add addD(k1=revAct*wd, k2=-revAct) if with_D
    "Adder for D gain"                                              annotation (Placement(
        transformation(extent={{-80,-10},{-60,10}}, rotation=0)));
  Modelica.Blocks.Math.Gain P(k=1) "Proportional term"
                                   annotation (Placement(transformation(extent={
            {-40,40},{-20,60}}, rotation=0)));
  Utilities.Math.IntegratorWithReset I(
    final use_reset=use_reset,
    k=unitTime/Ti,
    y_start=xi_start,
    initType=if initType == Modelica.Blocks.Types.InitPID.SteadyState then Modelica.Blocks.Types.Init.SteadyState else if
        initType == Modelica.Blocks.Types.InitPID.InitialState or initType == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
         then Modelica.Blocks.Types.Init.InitialState else Modelica.Blocks.Types.Init.NoInit,
    yResetSou=Annex60.BoundaryConditions.Types.DataSource.Input) if                              with_I "Integral term" annotation (Evaluate=true,
      Placement(transformation(extent={{-40,-60},{-20,-40}}, rotation=0)));

  Modelica.Blocks.Continuous.Derivative D(
    k=Td/unitTime,
    T=max([Td/Nd,1.e-14]),
    x_start=xd_start,
    initType=if initType == Modelica.Blocks.Types.InitPID.SteadyState or
                initType == Modelica.Blocks.Types.InitPID.InitialOutput
             then
               Modelica.Blocks.Types.Init.SteadyState
             else
               if initType == Modelica.Blocks.Types.InitPID.InitialState then
                 Modelica.Blocks.Types.Init.InitialState
               else
                 Modelica.Blocks.Types.Init.NoInit) if with_D "Derivative term"
                                                     annotation (Placement(
        transformation(extent={{-40,-10},{-20,10}}, rotation=0)));
  Modelica.Blocks.Math.Gain gainPID(k=k) "Multiplier for control gain"
                                         annotation (Placement(transformation(
          extent={{30,-10},{50,10}}, rotation=0)));
  Modelica.Blocks.Math.Add3 addPID(
    final k1=1,
    final k2=1,
    final k3=1) "Adder for the gains"
                                   annotation (Placement(transformation(extent={
            {0,-10},{20,10}}, rotation=0)));
  Modelica.Blocks.Math.Add3 addI(k1=revAct, k2=-revAct) if with_I
    "Adder for I gain"                                            annotation (Placement(
        transformation(extent={{-80,-60},{-60,-40}}, rotation=0)));
  Modelica.Blocks.Math.Add addSat(k1=+1, k2=-1) if with_I
    "Adder for integrator feedback"                       annotation (Placement(
        transformation(
        origin={80,-50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Blocks.Math.Gain gainTrack(k=1/(k*Ni)) if with_I
    "Gain for anti-windup compensation"                     annotation (
      Placement(transformation(extent={{40,-80},{20,-60}}, rotation=0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=yMax,
    uMin=yMin,
    strict=strict) "Output limiter" annotation (Placement(transformation(extent={{70,
            -10},{90,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.BooleanInput reset if  use_reset
    "Resets optionally the PID output to zero when trigger input becomes true."
    annotation (Evaluate=true, Placement(transformation(extent={{-140,-86},{-100,-46}})));
  Modelica.Blocks.Math.Add addForRes(k1=-1, k2=-1) if   use_reset
    "Calculates the necessary value to set the PID output to zero"
    annotation (Placement(transformation(extent={{-30,-34},{-40,-24}})));
protected
  parameter Boolean with_I = controllerType==Modelica.Blocks.Types.SimpleController.PI or
                             controllerType==Modelica.Blocks.Types.SimpleController.PID annotation(Evaluate=true, HideResult=true);
  parameter Boolean with_D = controllerType==Modelica.Blocks.Types.SimpleController.PD or
                             controllerType==Modelica.Blocks.Types.SimpleController.PID annotation(Evaluate=true, HideResult=true);

public
  Modelica.Blocks.Sources.Constant Dzero(k=0) if not with_D annotation (
      Placement(transformation(extent={{-30,20},{-20,30}}, rotation=0)));

  Modelica.Blocks.Sources.Constant Izero(k=0) if not with_I "Zero input signal"
                                                            annotation (
      Placement(transformation(extent={{10,-55},{0,-45}}, rotation=0)));

  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller";

protected
  final parameter Real revAct = if reverseAction then -1 else 1
    "Switch for sign for reverse action";
initial equation
  if initType==Modelica.Blocks.Types.InitPID.InitialOutput then
     gainPID.y = y_start;
  end if;
equation
  assert(yMax >= yMin, "LimPID: Limits must be consistent. However, yMax (=" + String(yMax) +
                       ") < yMin (=" + String(yMin) + ")");
  if initType == Modelica.Blocks.Types.InitPID.InitialOutput and (y_start < yMin or y_start > yMax) then
      Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) +
         ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");
  end if;

  connect(u_s, addP.u1) annotation (Line(points={{-120,0},{-96,0},{-96,56},{
          -82,56}}, color={0,0,127}));
  connect(u_s, addD.u1) annotation (Line(points={{-120,0},{-96,0},{-96,6},{
          -82,6}}, color={0,0,127}));
  connect(u_s, addI.u1) annotation (Line(points={{-120,0},{-96,0},{-96,-42},{
          -82,-42}}, color={0,0,127}));
  connect(addP.y, P.u) annotation (Line(points={{-59,50},{-42,50}}, color={0,
          0,127}));
  connect(addD.y, D.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(addI.y, I.u) annotation (Line(points={{-59,-50},{-42,-50}}, color={
          0,0,127}));
  connect(P.y, addPID.u1) annotation (Line(points={{-19,50},{-10,50},{-10,8},
          {-2,8}}, color={0,0,127}));
  connect(D.y, addPID.u2)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(I.y, addPID.u3) annotation (Line(points={{-19,-50},{-10,-50},{-10,
          -8},{-2,-8}}, color={0,0,127}));
  connect(addPID.y, gainPID.u)
    annotation (Line(points={{21,0},{28,0}}, color={0,0,127}));
  connect(gainPID.y, addSat.u2) annotation (Line(points={{51,0},{60,0},{60,
          -20},{74,-20},{74,-38}}, color={0,0,127}));
  connect(gainPID.y, limiter.u)
    annotation (Line(points={{51,0},{68,0}}, color={0,0,127}));
  connect(limiter.y, addSat.u1) annotation (Line(points={{91,0},{94,0},{94,
          -20},{86,-20},{86,-38}}, color={0,0,127}));
  connect(limiter.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(addSat.y, gainTrack.u) annotation (Line(points={{80,-61},{80,-70},{
          42,-70}}, color={0,0,127}));
  connect(gainTrack.y, addI.u3) annotation (Line(points={{19,-70},{-88,-70},{
          -88,-58},{-82,-58}}, color={0,0,127}));
  connect(u_m, addP.u2) annotation (Line(
      points={{0,-120},{0,-92},{-92,-92},{-92,44},{-82,44}},
      color={0,0,127},
      thickness=0.5));
  connect(u_m, addD.u2) annotation (Line(
      points={{0,-120},{0,-92},{-92,-92},{-92,-6},{-82,-6}},
      color={0,0,127},
      thickness=0.5));
  connect(u_m, addI.u2) annotation (Line(
      points={{0,-120},{0,-92},{-92,-92},{-92,-50},{-82,-50}},
      color={0,0,127},
      thickness=0.5));
  connect(Dzero.y, addPID.u2) annotation (Line(points={{-19.5,25},{-14,25},{
          -14,0},{-2,0}}, color={0,0,127}));
  connect(Izero.y, addPID.u3) annotation (Line(points={{-0.5,-50},{-10,-50},{
          -10,-8},{-2,-8}}, color={0,0,127}));

  connect(reset, I.reset) annotation (Line(points={{-120,-66},{-54,-66},{-54,-43},
          {-42,-43}},   color={255,0,255}));
  connect(P.y, addForRes.u1) annotation (Line(points={{-19,50},{-14,50},{-10,50},
          {-10,-4},{-12,-4},{-12,-26},{-29,-26}}, color={0,0,127}));
  connect(D.y, addForRes.u2) annotation (Line(points={{-19,0},{-18,0},{-18,-32},
          {-29,-32}}, color={0,0,127}));
  connect(Dzero.y, addForRes.u2) annotation (Line(points={{-19.5,25},{-16,25},{
          -16,-32},{-29,-32}}, color={0,0,127}));
  connect(addForRes.y, I.yReset_in) annotation (Line(points={{-40.5,-29},{-48,-29},
          {-48,-57},{-42,-57}}, color={0,0,127}));
   annotation (
defaultComponentName="conPID",
Documentation(info="<html>
<p>
This model is similar to
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">Modelica.Blocks.Continuous.LimPID</a>,
except for the following changes:
</p>
<ol>
<li>
<p>
It can be configured to have a reverse action.
</p>
<p>If the parameter <code>reverseAction=false</code> (the default), then
<code>u_m &lt; u_s</code> increases the controller output,
otherwise the controller output is decreased. Thus,
</p>
<ul>
<li>for a heating coil with a two-way valve, set <code>reverseAction = false</code>, </li>
<li>for a cooling coils with a two-way valve, set <code>reverseAction = true</code>. </li>
</ul>
</li>
<li>
<p>
It can be configured to enable an input port that allows an integrator reset.
</p>
<p>
To do so, set <code>use_reset=true</code>, which enables the boolean input port
<code>reset</code>. Whenever the boolean input
<code>reset</code> has a rising edge, the output of the
integrator is reset to the value <code>y_reset</code>.
This allows for example to reset the integrator in order to start the controller
with a zero output signal whenever an equipment that it controls is switched on.
By default, <code>use_reset=false</code>.
</p>
</li>
<li>
The parameter <code>limitsAtInit</code> has been removed.
</li>
<li>
Some parameters assignments in the instances have been made final.
</li>
</ol>
</html>",
revisions="<html>
<ul>

<li>
August 25, 2016, by Michael Wetter:<br/>
Removed parameter <code>limitsAtInit</code> because it was only propagated to
the instance <code>limiter</code>, but this block no longer makes use of this parameter.
This is a non-backward compatible change.<br/>
Revised implemenentation, added comments, made some parameter in the instances final.
</li>
<li>July 18, 2016, by Philipp Mehrfeld:<br/>
Added integrator reset.
This is for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/494\">issue 494</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Changed the default value to <code>strict=true</code> in order to avoid events
when the controller saturates.
This is for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/433\">issue 433</a>.
</li>
<li>
February 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-6,-20},{66,-66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.P),
          extent={{-32,-22},{68,-62}},
          lineColor={0,0,0},
          textString="P",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PI),
          extent={{-28,-22},{72,-62}},
          lineColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PD),
          extent={{-16,-22},{88,-62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="P D"),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PID),
          extent={{-14,-22},{86,-62}},
          lineColor={0,0,0},
          textString="PID",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Line(points={{-80,-80},{-80,-20},{30,60},{80,60}}, color={0,0,127}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          visible=strict,
          points={{30,60},{81,60}},
          color={255,0,0},
          smooth=Smooth.None)}));
end LimPID;
