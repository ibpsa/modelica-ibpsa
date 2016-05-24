within Annex60.Utilities.Psychrometrics.Examples;
model TWetBul_TDryBulPhi "Model to test the wet bulb temperature computation"
  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Air "Medium model"
           annotation (choicesAllMatching = true);
  constant Modelica.SIunits.Temperature dT_max=0.1
    "Maximum allowed deviation with reference result";

  Annex60.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhi(redeclare
      package Medium = Medium) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-100,
            -20},{-80,0}})));
    Modelica.Blocks.Sources.Ramp phi(
    duration=1,
    height=1,
    offset=0) "Relative humidity"
                 annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=273.15 + 29.4)
    "Dry bulb temperature"          annotation (Placement(transformation(extent={{-100,60},
            {-80,80}})));
  Annex60.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhiApp(redeclare
      package Medium = Medium, approximateWetBulb=true)
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Annex60.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulXi(redeclare package
      Medium = Medium)
    "Model for wet bulb temperature using Xi as an input, used to verify consistency with wetBulPhi"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Annex60.Utilities.Psychrometrics.X_pTphi x_pTphi
    annotation (Placement(transformation(extent={{-22,-36},{-10,-24}})));
equation
   // Validation of one data point based on example 17.1 in
   // Ananthanarayanan, P. N. Basic refrigeration and air conditioning. Tata McGraw-Hill Education, 2013.
   if abs(wetBulPhi.phi-0.48)<0.001 then
     assert(abs(wetBulPhi.TWetBul - 21.1-273.15) < dT_max,
     "Error in computation of wet bulb temperature, deviation with reference result is larger than "
     + String(dT_max) + " K since the wet bulb temperature equals " +String(wetBulPhi.TWetBul));
   end if;

   assert(abs(wetBulPhi.TWetBul-wetBulXi.TWetBul)<1e-6, "Inconsistent implementation of wetBulPhi and wetBulXi!");
  connect(p.y, wetBulPhi.p)
                         annotation (Line(points={{-79,-10},{-40,-10},{-40,42},{
          -1,42}},                                                  color={0,0,
          127}));
  connect(TDryBul.y, wetBulPhi.TDryBul) annotation (Line(
      points={{-79,70},{-32,70},{-32,58},{-1,58}},
      color={0,0,127}));
  connect(phi.y, wetBulPhi.phi) annotation (Line(
      points={{-79,30},{-46,30},{-46,50},{-1,50}},
      color={0,0,127}));
  connect(p.y, wetBulPhiApp.p)
                         annotation (Line(points={{-79,-10},{-40,-10},{-40,2},{
          -1,2}},                                                   color={0,0,
          127}));
  connect(TDryBul.y, wetBulPhiApp.TDryBul)
                                        annotation (Line(
      points={{-79,70},{-32,70},{-32,18},{-1,18}},
      color={0,0,127}));
  connect(phi.y, wetBulPhiApp.phi)
                                annotation (Line(
      points={{-79,30},{-46,30},{-46,10},{-1,10}},
      color={0,0,127}));
  connect(wetBulXi.TDryBul, TDryBul.y) annotation (Line(points={{-1,-22},{-18,-22},
          {-32,-22},{-32,70},{-79,70}}, color={0,0,127}));
  connect(wetBulXi.p, p.y) annotation (Line(points={{-1,-38},{-40,-38},{-40,-10},
          {-79,-10}}, color={0,0,127}));
  connect(x_pTphi.p_in, p.y) annotation (Line(points={{-23.2,-26.4},{-40,-26.4},
          {-40,-10},{-79,-10}}, color={0,0,127}));
  connect(x_pTphi.T, TDryBul.y) annotation (Line(points={{-23.2,-30},{-32,-30},{
          -32,70},{-79,70}}, color={0,0,127}));
  connect(x_pTphi.phi, phi.y) annotation (Line(points={{-23.2,-33.6},{-46,-33.6},
          {-46,30},{-79,30}}, color={0,0,127}));
  connect(x_pTphi.X[1], wetBulXi.Xi[1])
    annotation (Line(points={{-9.4,-30},{-1,-30}},          color={0,0,127}));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/TWetBul_TDryBulPhi.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the wet bulb computation.
The model on the top uses the accurate computation of the
wet bulb temperature, whereas the model below uses the approximate
computation of the wet bulb temperature.
</p>
<p>
The model contains an assert that validates the model based on a single operating point from Example 17.1 in
Ananthanarayanan, P. N. Basic refrigeration and air conditioning. Tata McGraw-Hill Education, 2013.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2016, by Filip Jorissen:<br/>
Updated example with validation data.
See  <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/474\">#474</a> 
for a discussion.
</li>
<li>
October 1, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end TWetBul_TDryBulPhi;
