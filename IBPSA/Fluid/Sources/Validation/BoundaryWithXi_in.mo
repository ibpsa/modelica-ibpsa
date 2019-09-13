within IBPSA.Fluid.Sources.Validation;
model BoundaryWithXi_in
  "Validation model for boundary with different media and mass fraction input"
  extends Modelica.Icons.Example;

  Boundary_pT bouMoiAir(redeclare package Medium = Media.Air, use_Xi_in=true)
    "Boundary with moist air"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Boundary_pT bouMoiAirCO2(redeclare package Medium = Media.Air(extraPropertiesNames={"CO2"}),
      use_Xi_in=true)
    "Boundary with moist air"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Boundary_pT bouProFluGas(
   redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents, use_Xi_in=true)
    "Boundary with flue gas"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Boundary_pT bouNatGas(redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas, use_Xi_in=true)
    "Boundary with natural gas"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Modelica.Blocks.Sources.Constant X_i1[1](k={0.985})
    "Prescribed mass fraction"
    annotation (Placement(transformation(extent={{-20,66},{0,86}})));
  Modelica.Blocks.Sources.Constant X_i6[6](k={0.01*i for i in 1:6})
    "Prescribed mass fraction"
    annotation (Placement(transformation(extent={{-20,-14},{0,6}})));
  Modelica.Blocks.Sources.Constant X_i2[6](k={0.01*i for i in 1:6})
    "Prescribed mass fraction"
    annotation (Placement(transformation(extent={{-20,-54},{0,-34}})));
equation
  connect(X_i1.y, bouMoiAir.Xi_in)
    annotation (Line(points={{1,76},{18,76}}, color={0,0,127}));
  connect(X_i6.y, bouProFluGas.Xi_in)
    annotation (Line(points={{1,-4},{18,-4}}, color={0,0,127}));
  connect(X_i1.y, bouMoiAirCO2.Xi_in) annotation (Line(points={{1,76},{10,76},{10,
          36},{18,36}}, color={0,0,127}));
  connect(X_i2.y, bouNatGas.Xi_in)
    annotation (Line(points={{1,-44},{18,-44}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Validation model for <a href=\"modelica://IBPSA.Fluid.Sources.Boundary_pT\">
IBPSA.Fluid.Sources.Boundary_pT</a>
for different media and with mass fraction prescribed by an input.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2019 by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">IBPSA, #1205</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Sources/Validation/BoundaryWithXi_in.mos"
        "Simulate and plot"),
experiment(
      StopTime=1,
      Tolerance=1e-06));
end BoundaryWithXi_in;
