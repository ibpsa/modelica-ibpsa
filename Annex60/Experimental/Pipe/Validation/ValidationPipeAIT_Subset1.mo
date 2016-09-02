within Annex60.Experimental.Pipe.Validation;
model ValidationPipeAIT_Subset1
  "Validation pipe against data from Austrian Institute of Technology"
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;
  Fluid.Sources.MassFlowSource_T Point2(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,70})));
  PipeHeatLossMod pip2(
    redeclare package Medium = Medium,
    length=76,
    m_flow_nominal=1,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18),
    Lcap=Lcap,
    pipVol=pipVol,
    allowFlowReversal=allowFlowReversal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,34})));
  parameter Modelica.SIunits.Length Lcap=1
    "Length over which transient effects typically take place";
  parameter Boolean pipVol=false
    "Flag to decide whether volumes are included at the end points of the pipe";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
  Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,-82})));
  PipeHeatLossMod pip1(
    redeclare package Medium = Medium,
    length=76,
    m_flow_nominal=1,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18),
    Lcap=Lcap,
    pipVol=pipVol,
    allowFlowReversal=allowFlowReversal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,-26})));
  Modelica.Blocks.Sources.Constant const1(k=-0.1)
    annotation (Placement(transformation(extent={{-20,80},{-40,100}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperature(T=0)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,0})));
equation
  connect(pip2.port_b, Point2.ports[1]) annotation (Line(
      points={{-70,44},{-70,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip2.port_a, pip1.port_b)
    annotation (Line(points={{-70,24},{-70,24},{-70,-16}}, color={0,127,255}));
  connect(ExcludedBranch.ports[1], pip1.port_a) annotation (Line(points={{-70,-72},
          {-70,-72},{-70,-36}}, color={0,127,255}));
  connect(const1.y, Point2.m_flow_in) annotation (Line(points={{-41,90},{-52,90},
          {-52,90},{-62,90},{-62,86},{-62,86},{-62,80}}, color={0,0,127}));
  connect(pip2.heatPort, fixedTemperature.port) annotation (Line(points={{-60,
          34},{-34,34},{-34,1.33227e-015},{-10,1.33227e-015}}, color={191,0,0}));
  connect(pip1.heatPort, fixedTemperature.port) annotation (Line(points={{-60,
          -26},{-34,-26},{-34,1.33227e-015},{-10,1.33227e-015}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=603900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>The example contains <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDataAIT151218\">experimental data</a> from a real district heating network. This data is used to validate a pipe model.</p>
<p>Pipes&apos; temperatures are not initialized, thus results of outflow temperature before apprixmately the first 10000 seconds should no be considered. </p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/AITTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>To calculate the length specific thermal resistance <code><span style=\"font-family: Courier New,courier;\">R</span></code> of the pipe, the thermal resistance of the surrounding ground is added. </p>
<p><code><span style=\"font-family: Courier New,courier;\">R=1/(0.208)+1/(2*lambda_g*Modelica.Constants.pi)*log(1/0.18)</span></code> </p>
<p>Where the thermal conductivity of the ground <code><span style=\"font-family: Courier New,courier;\">lambda_g = 2.4 </span></code>W/mK. </p>
<p><br><h4><span style=\"color: #008000\">Testing spatialDistribution influence on non-linear systems</span></h4></p>
<p>The model contains two parameters on the top level:</p>
<p><code><span style=\"font-family: Courier New,courier; color: #0000ff;\">parameter&nbsp;</span><span style=\"color: #ff0000;\">Boolean</span>&nbsp;pipVol=false&nbsp;</p><p><span style=\"font-family: Courier New,courier; color: #006400;\">&nbsp;&nbsp;&nbsp;&nbsp;&QUOT;Flag&nbsp;to&nbsp;decide&nbsp;whether&nbsp;volumes&nbsp;are&nbsp;included&nbsp;at&nbsp;the&nbsp;end&nbsp;points&nbsp;of&nbsp;the&nbsp;pipe&QUOT;</span>;</code></p>
<p><code><span style=\"font-family: Courier New,courier; color: #0000ff;\">parameter&nbsp;</span><span style=\"color: #ff0000;\">Boolean</span>&nbsp;allowFlowReversal=true&nbsp;</code></p>
<p><code><span style=\"font-family: Courier New,courier; color: #006400;\">&nbsp;&nbsp;&nbsp;&nbsp;&QUOT;=&nbsp;true&nbsp;to&nbsp;allow&nbsp;flow&nbsp;reversal,&nbsp;false&nbsp;restricts&nbsp;to&nbsp;design&nbsp;direction&nbsp;(port_a&nbsp;-&GT;&nbsp;port_b)&QUOT;</span>;</code></p>
<p><br><code><span style=\"font-family: Courier New,courier;\">pipVol </span></code>controls the presence of two additional mixing volumes at the in/outlets of <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow.</span></code> <code><span style=\"font-family: Courier New,courier;\">allowFlowReversal</span></code> controls whether flow reversal is allowed in the same component.</p>
<p><br>Below, the model translation statistics for different combinations of these parameters are presented:</p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=true, allowFlowReversal=true</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 1090 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6981 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6928 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 30 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 524 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 616 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 66</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 0</span></h4></p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=false, allowFlowReversal=true</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 500 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6946 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6863 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 18 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 409 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 364 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 54</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: {44}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: {5}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 1</span></h4></p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=false, allowFlowReversal=false</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 500 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6946 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6866 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 18 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 399 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 371 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 54</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: {5, 5}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: {1, 1}</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 2</span></h4></p>
<p style=\"margin-left: 30px;\"><br><h4>pipVol=true, allowFlowReversal=false</h4></p>
<p style=\"margin-left: 30px;\">Translated Model</p>
<p style=\"margin-left: 30px;\">Constants: 1090 scalars</p>
<p style=\"margin-left: 30px;\">Free parameters: 6981 scalars</p>
<p style=\"margin-left: 30px;\">Parameter depending: 6932 scalars</p>
<p style=\"margin-left: 30px;\">Continuous time states: 30 scalars</p>
<p style=\"margin-left: 30px;\">Time-varying variables: 513 scalars</p>
<p style=\"margin-left: 30px;\">Alias variables: 623 scalars</p>
<p style=\"margin-left: 30px;\">Assumed default initial conditions: 66</p>
<p style=\"margin-left: 30px;\">Number of mixed real/discrete systems of equations: 0</p>
<p style=\"margin-left: 30px;\">Sizes of linear systems of equations: { }</p>
<p style=\"margin-left: 30px;\">Sizes after manipulation of the linear systems: { }</p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes of nonlinear systems of equations: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Sizes after manipulation of the nonlinear systems: { }</span></h4></p>
<p style=\"margin-left: 30px;\"><h4><span style=\"color: #008000\">Number of numerical Jacobians: 0</span></h4></p>
<p><br>It seems that when the solver has to account for the possibility of flow reversal (aFV=true) and the model includes no additional state for the water in the pipe (pipVol = false), very large nonlinear systems appear when translating. However, the advection equation, implemented by the <code><span style=\"font-family: Courier New,courier;\">spatialDistribution</span></code> function should inherently introduce a state. This state is clearly not recognized by the model translator. We see that if additional volumes are introduced, or if flow reversal is disabled the non-linear system is smaller or entirely eliminated. </p>
</html>", revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br>Added parameters to test the influence of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationPipeAIT.mos"
        "Simulate and plot"));
end ValidationPipeAIT_Subset1;
