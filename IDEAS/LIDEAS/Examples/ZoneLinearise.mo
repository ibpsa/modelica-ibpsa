within IDEAS.LIDEAS.Examples;
model ZoneLinearise "Test for linearisation"
  extends LIDEAS.Components.LinearisationInterface(sim(nWindow=1));
  parameter Integer nZones=2;
  parameter Integer nEmb=1;
  package Medium = IDEAS.Media.Air;
  extends Modelica.Icons.Example;
  LIDEAS.Components.LinZone zone(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20,
    nSurf=5) "First zone"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  IDEAS.Buildings.Components.BoundaryWall commonWall(
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    A=10,
    azi=0,
    inc=1.5707963267949,
    use_T_in=true) "Common wall model"
    annotation (Placement(transformation(extent={{-54,-2},{-44,18}})));
  IDEAS.Buildings.Components.InternalWall floor(
    A=10,
    azi=0,
    inc=IDEAS.Types.Tilt.Floor,
    redeclare IDEAS.Buildings.Data.Constructions.TABS constructionType)
    "TABS Floor between the two zones." annotation (Placement(transformation(
        extent={{-5,-10},{5,10}},
        rotation=90,
        origin={9,-38})));

  LIDEAS.Components.LinWindow window(
    A=1,
    redeclare parameter IDEAS.Buildings.Data.Glazing.Ins2 glazing,
    redeclare IDEAS.Buildings.Components.Shading.Screen shaType,
    redeclare IDEAS.Buildings.Data.Frames.Pvc fraType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S,
    indexWindow=1) "Window model"
    annotation (Placement(transformation(extent={{-54,-82},{-44,-62}})));
  IDEAS.Buildings.Components.SlabOnGround slabOnGround(
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.LightWall
      constructionType,
    A=20,
    PWall=3,
    inc=0,
    azi=0) "Floor model"
    annotation (Placement(transformation(extent={{-54,20},{-44,40}})));
  IDEAS.Buildings.Components.OuterWall outerWall(
    azi=0,
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    A=10,
    inc=1.5707963267949) "Outer wall model"
    annotation (Placement(transformation(extent={{-54,-58},{-44,-38}})));
  LIDEAS.Components.LinZone zone1(
    nSurf=2,
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20) "Second zone"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  IDEAS.Buildings.Components.Shading.ShadingControl shadingControl
    "Shading control model"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  IDEAS.Buildings.Components.BoundaryWall commonWall1(
    redeclare parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall
      constructionType,
    A=10,
    azi=0,
    inc=1.5707963267949,
    use_T_in=false,
    use_Q_in=true) "Common wall model"
    annotation (Placement(transformation(extent={{-54,-26},{-44,-6}})));

  Modelica.Blocks.Sources.Constant const(k=273.15 + 20)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Constant const1(k=10)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
equation
  connect(commonWall.propsBus_a, zone.propsBus[1]) annotation (Line(
      points={{-44.8333,10},{-12,10},{-12,-4.4},{20,-4.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(floor.propsBus_a, zone.propsBus[2]) annotation (Line(
      points={{7,-33.8333},{6,-33.8333},{6,-5.2},{20,-5.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(window.propsBus_a, zone1.propsBus[2]) annotation (Line(
      points={{-44.8333,-70},{6,-70},{6,-57},{20,-57}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(outerWall.propsBus_a, zone.propsBus[4]) annotation (Line(
      points={{-44.8333,-46},{-12,-46},{-12,-6.8},{20,-6.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(slabOnGround.propsBus_a, zone.propsBus[3]) annotation (Line(
      points={{-44.8333,32},{-12,32},{-12,-6},{20,-6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(floor.propsBus_b, zone1.propsBus[1]) annotation (Line(
      points={{7,-42.1667},{6.5,-42.1667},{6.5,-55},{20,-55}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shadingControl.y, window.Ctrl) annotation (Line(
      points={{-60,-84},{-58,-84},{-58,-86},{-52.3333,-86},{-52.3333,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(commonWall1.propsBus_a, zone.propsBus[5]) annotation (Line(
      points={{-44.8333,-14},{-12,-14},{-12,-7.6},{20,-7.6}},
      color={255,204,51},
      thickness=0.5));
  connect(const.y, commonWall.T)
    annotation (Line(points={{-79,10},{-57.8333,10}},
                                                   color={0,0,127}));
  connect(const1.y, commonWall1.Q_flow) annotation (Line(points={{-79,-20},{
          -57.8333,-20},{-57.8333,-18}},
                                   color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           __Dymola_Commands(file=
          "Scripts/linearize_ZoneLinearise.mos" "Linearise"),
    Documentation(revisions="<html>
<ul>
<li>April 10, 2018 by Damien Picard: <br>Add documentation.</li>
<li>July 18, 2016 by Filip Jorissen:<br>Cleaned up code and implementation. </li>
<li>By Filip Jorissen:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p>This model represents a very simple two-zone building. The model can be linearised by executing the command &lsquo;Linearise&rsquo; in the &lsquo;Commands&rsquo; menu of Dymola. This executes the script at LIDEAS/LIDEAS/Resources/Scripts/linearize.mos, which contains the following code:</p>
<p>OutputCPUtime:=false;</p>
<p>// linearise model and save results in &apos;re&apos;</p>
<p>re=Modelica_LinearSystems2.ModelAnalysis.Linearize(&QUOT;LIDEAS.Examples.ZoneExampleLinearise&QUOT;);</p>
<p>// extract state space matrices from &apos;re&apos; and save them to a mat file in the current working directory</p>
<p>writeMatrix(fileName=&QUOT;ssm.mat&QUOT;,matrixName=&QUOT;A&QUOT;,matrix=re.A);</p>
<p>writeMatrix(fileName=&QUOT;ssm.mat&QUOT;,matrixName=&QUOT;B&QUOT;,matrix=re.B, append=true);</p>
<p>writeMatrix(fileName=&QUOT;ssm.mat&QUOT;,matrixName=&QUOT;C&QUOT;,matrix=re.C, append=true);</p>
<p>writeMatrix(fileName=&QUOT;ssm.mat&QUOT;,matrixName=&QUOT;D&QUOT;,matrix=re.D, append=true);</p>
<p>// save the variable names of the inputs, outputs and states in the current working directory</p>
<p>Modelica.Utilities.Files.remove(&QUOT;uNames.txt&QUOT;);</p>
<p>for i in 1:size(re.uNames,1) loop Modelica.Utilities.Streams.print(re.uNames[i], &QUOT;uNames.txt&QUOT;); end for;</p>
<p>Modelica.Utilities.Files.remove(&QUOT;yNames.txt&QUOT;);</p>
<p>for i in 1:size(re.yNames,1) loop Modelica.Utilities.Streams.print(re.yNames[i], &QUOT;yNames.txt&QUOT;); end for;</p>
<p>Modelica.Utilities.Files.remove(&QUOT;xNames.txt&QUOT;);</p>
<p>for i in 1:size(re.xNames,1) loop Modelica.Utilities.Streams.print(re.xNames[i], &QUOT;xNames.txt&QUOT;); end for;</p>
<p>OutputCPUtime:=true;</p>
<p>The first and last line of the code avoid that the CPU time is also linearised. The second line performs the actual linearisation and stores the resulting state space model in variable &lsquo;re&rsquo;. The next four lines are used to save the four state space matrices contained by &lsquo;re&rsquo; to a file &lsquo;ssm.mat&rsquo;. The remaining four lines of code also export the variable names of the state space inputs (u), states (x) and outputs (y) to three .txt files, which can then be used externally.</p>
</html>"));
end ZoneLinearise;
