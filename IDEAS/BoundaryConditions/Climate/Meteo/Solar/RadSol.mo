within IDEAS.BoundaryConditions.Climate.Meteo.Solar;
model RadSol "solar angle to surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.SIunits.Angle inc(displayUnit="degree") "inclination";
  parameter Modelica.SIunits.Angle azi(displayUnit="degree") "azimuth";
  parameter Modelica.SIunits.Angle lat(displayUnit="degree") "latitude";
  parameter Boolean remDefVals = false "Remove default signal values";
  parameter Boolean outputAngles=true "Set to false when linearising only";

  output Buildings.Components.Interfaces.SolBus solBus(outputAngles=
        outputAngles)
    annotation (Placement(transformation(extent={{80,-20},{120,20}})));

  Modelica.Blocks.Interfaces.RealInput angZen
    annotation (Placement(transformation(extent={{-124,-60},{-84,-20}})));
  Modelica.Blocks.Interfaces.RealInput solDifHor
    annotation (Placement(transformation(extent={{-124,40},{-84,80}})));
  Modelica.Blocks.Interfaces.RealInput solGloHor
    annotation (Placement(transformation(extent={{-124,60},{-84,100}})));
  Modelica.Blocks.Interfaces.RealInput F1
    annotation (Placement(transformation(extent={{-124,-100},{-84,-60}})));
  Modelica.Blocks.Interfaces.RealInput F2
    annotation (Placement(transformation(extent={{-124,-120},{-84,-80}})));
  Modelica.Blocks.Interfaces.RealInput solDirPer
    annotation (Placement(transformation(extent={{-124,80},{-84,120}})));
  Modelica.Blocks.Interfaces.RealInput angHou
    annotation (Placement(transformation(extent={{-124,-40},{-84,0}})));
  Modelica.Blocks.Interfaces.RealInput angDec
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-104,0})));

protected
  BaseClasses.AngleSolar angSolar(
    final inc=inc,
    final azi=azi,
    final lat=lat) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  BaseClasses.solDirTil solDirTil(
    final inc=inc)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  IDEAS.BoundaryConditions.Climate.Meteo.Solar.BaseClasses.Perez perez(final inc=
       inc, final rho=rho)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.Constant dummyValAzi(k=0) if not remDefVals
    "angAzi dummy value when not needed"
    annotation (Placement(transformation(extent={{-20,-98},{-8,-86}})));
  Modelica.Blocks.Sources.Constant dummyValTenv(k=Modelica.Constants.inf) if
                                                     not remDefVals
    "Tenv dummy value when not needed"
    annotation (Placement(transformation(extent={{-20,-76},{-8,-64}})));

equation
  connect(angSolar.angInc, solDirTil.angSol) annotation (Line(
      points={{-20,36},{0,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDirTil.solDirPer, solDirPer) annotation (Line(
      points={{0,32.8},{0,34},{-8,34},{-8,100},{-104,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDirTil.solDirTil, solBus.iSolDir) annotation (Line(
      points={{20,36},{98,36},{98,0.1},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.angZen, angZen) annotation (Line(
      points={{0,-5},{-54,-5},{-54,-40},{-104,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.F1, F1) annotation (Line(
      points={{0,-9},{-56,-9},{-56,-80},{-104,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.solGloHor, solGloHor) annotation (Line(
      points={{0,-19},{-46,-19},{-46,80},{-104,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.solDifHor, solDifHor) annotation (Line(
      points={{0,-17},{-48,-17},{-48,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.angInc, angSolar.angInc) annotation (Line(points={{0,-1},{-18,-1},
          {-18,0},{-18,36},{-20,36}},         color={0,0,127}));
  connect(perez.solDifTil, solBus.iSolDif) annotation (Line(
      points={{20,-4},{96,-4},{96,0.1},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(perez.F2, F2) annotation (Line(points={{0,-13},{-58,-13},{-58,-100},{-104,
          -100}},   color={0,0,127}));
  connect(angSolar.angInc, solBus.angInc) annotation (Line(
      points={{-20,36},{-18,36},{-18,60},{100,60},{100,0.1},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, solBus.angZen) annotation (Line(points={{-104,-40},{100.1,-40},
          {100.1,0.1}}, color={0,0,127}));
  connect(dummyValAzi.y, solBus.angAzi) annotation (Line(
      points={{-7.4,-92},{100.1,-92},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyValTenv.y, solBus.Tenv) annotation (Line(
      points={{-7.4,-70},{100.1,-70},{100.1,0.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angSolar.angDec, angDec) annotation (Line(points={{-40,36},{-66,36},{-66,
          0},{-104,0}}, color={0,0,127}));
  connect(angSolar.angHou, angHou) annotation (Line(points={{-40,32},{-64,32},{-64,
          -20},{-104,-20}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(graphics={
        Polygon(
          points={{-90,-80},{-40,-40},{40,-40},{90,-80},{-90,-80}},
          lineColor={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{16,-46},{22,-72},{-72,-4},{-18,-22},{16,-46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Ellipse(
          extent={{88,84},{40,38}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
March 25, 2016 by Filip Jorissen:<br/>
Reworked radSol implementation to use RealInputs instead of weaBus.
This simplifies translation and interpretation.
</li>
<li>
February 10, 2015 by Filip Jorissen:<br/>
Adjusted implementation for grouping of solar calculations.
</li>
</ul>
</html>"));
end RadSol;
