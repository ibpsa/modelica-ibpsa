within IDEAS.Buildings.Components.BaseClasses;
model GlobalProperties
  Real hCon;
  Real TePow4 = Te^4;
  Real TskyPow4 = Tsky^4;
  Modelica.Blocks.Interfaces.RealInput Va
    annotation (Placement(transformation(extent={{-124,-20},{-84,20}})));
  Modelica.Blocks.Interfaces.RealInput Te
    annotation (Placement(transformation(extent={{-124,20},{-84,60}})));
  Modelica.Blocks.Interfaces.RealInput Tsky
    annotation (Placement(transformation(extent={{-124,60},{-84,100}})));
equation
  hCon = IDEAS.Utilities.Math.Functions.spliceFunction(x=Va-5, pos= 7.1*abs(Va)^(0.78), neg=  4.0*Va + 5.6, deltax=0.5);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end GlobalProperties;
