within IDEAS.Examples.TwinHouses.BaseClasses;
model RadiationConvertorPerez
  "Converts east-south-west radiation into diffuse and direct component"
  parameter Modelica.SIunits.Angle lat "Latitude";
  final parameter Modelica.SIunits.Angle south = IDEAS.Types.Azimuth.S;
  final parameter Modelica.SIunits.Angle east = south + Modelica.SIunits.Conversions.from_deg(270);
  final parameter Modelica.SIunits.Angle west = south + Modelica.SIunits.Conversions.from_deg(90);
  final parameter Modelica.SIunits.Angle vertical = IDEAS.Types.Tilt.Wall;
  final parameter Modelica.SIunits.Angle horizontal = Modelica.SIunits.Conversions.from_deg(0);
  parameter Real lon "Longitude";
  parameter Real[3] rho = {0.3, 0.3, 0.3} "Ground reflectance for east, south, west";
  constant Real bMin=Modelica.Math.cos(Modelica.Constants.pi*85/180)
    "Lower bound for b";

  Real[3] a = {IDEAS.Utilities.Math.Functions.smoothMax(
    0,
    Modelica.Math.cos(incEast.incAng),
    0.01),
    IDEAS.Utilities.Math.Functions.smoothMax(
    0,
    Modelica.Math.cos(incSouth.incAng),
    0.01),
    IDEAS.Utilities.Math.Functions.smoothMax(
    0,
    Modelica.Math.cos(incWest.incAng),
    0.01)};
  Real b = IDEAS.Utilities.Math.Functions.smoothMax(
    bMin,
    Modelica.Math.cos(angZen),
    0.01);

  Modelica.Blocks.Interfaces.RealInput H_east
    "Total radiation on a plane facing east"
    annotation (Placement(transformation(extent={{-124,60},{-84,100}})));
  Modelica.Blocks.Interfaces.RealInput H_south
    "Total radiation on a plane facing south"
    annotation (Placement(transformation(extent={{-124,20},{-84,60}})));
  Modelica.Blocks.Interfaces.RealInput H_west
    "Total radiation on a plane facing east"
    annotation (Placement(transformation(extent={{-124,-20},{-84,20}})));
  IDEAS.Utilities.Math.Min Hmin(nin=3, u(each start=0))
    "Minimum radiation on surfaces: everything except direct solar radiation"
    annotation (Placement(transformation(extent={{20,90},{40,70}})));
  Modelica.Blocks.Interfaces.RealOutput solDirHor
    "Radiation on horizontal surface"
    annotation (Placement(transformation(extent={{98,40},{118,60}})));
  Modelica.Blocks.Interfaces.RealOutput solDirPer
    "Direct radiation normal to zenith"
    annotation (Placement(transformation(extent={{98,10},{118,30}})));
  Modelica.Blocks.Interfaces.RealOutput solDifHor
    "Diffuse radiation on a horizontal surface"
    annotation (Placement(transformation(extent={{98,70},{118,90}})));
protected
  IDEAS.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incSouth(final lat=
       lat, final til=vertical,
    azi=south) "Incidence angle of the south oriented sensor"
    annotation (Placement(transformation(extent={{40,-58},{60,-38}})));
protected
  IDEAS.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incWest(
    final lat=lat,
    final til=vertical,
    azi=west) "Incidence angle of the west oriented sensor"
    annotation (Placement(transformation(extent={{40,-82},{60,-62}})));
protected
  IDEAS.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incEast(
    final lat=lat,
    final til=vertical,
    azi=east) "Incidence angle of the east oriented sensor"
    annotation (Placement(transformation(extent={{40,-108},{60,-88}})));
public
  Modelica.Blocks.Sources.RealExpression HDirSouth(y=(H_south - solDifHor/2 -
        rhoGai[2].y/2 - perezCoeff[2].y*solDifHor)*
        IDEAS.Utilities.Math.Functions.inverseXRegularized(cos(incSouth.incAng),
        0.01))
    "Solar radiation measured from south faced surface"
    annotation (Placement(transformation(extent={{-80,4},{0,26}})));
  Modelica.Blocks.Sources.RealExpression HDirEast(y=(H_east - solDifHor/2 -
        rhoGai[1].y/2 - perezCoeff[1].y*solDifHor)*
        IDEAS.Utilities.Math.Functions.inverseXRegularized(cos(incEast.incAng),
        0.01))
    "Solar radiation measured from east faced surface"
    annotation (Placement(transformation(extent={{-80,20},{0,40}})));
  Modelica.Blocks.Sources.RealExpression HDirWest(y=(H_west - solDifHor/2 -
        rhoGai[3].y/2 - perezCoeff[3].y*solDifHor)*
        IDEAS.Utilities.Math.Functions.inverseXRegularized(cos(incWest.incAng),
        0.01))
    "Solar radiation measured from west faced surface"
    annotation (Placement(transformation(extent={{-80,-14},{0,8}})));
protected
  IDEAS.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incHor(
    final lat=lat,
    azi=south,
    final til=horizontal) "Incidence angle on horizontal surface"
    annotation (Placement(transformation(extent={{40,-32},{60,-12}})));
public
  Modelica.Blocks.Sources.RealExpression HDirHorVal(y=cos(incHor.incAng)*
        HDirMax.y) "Solar radiation on a horizontal surface"
    annotation (Placement(transformation(extent={{14,54},{62,74}})));
public
  Modelica.Blocks.Sources.RealExpression HDirMax(
    y=IDEAS.Utilities.Math.Functions.spliceFunction(
           x=min(incSouth.incAng, incEast.incAng)-incWest.incAng,
           pos= HDirWest.y,
           neg=IDEAS.Utilities.Math.Functions.spliceFunction(x=incEast.incAng - incSouth.incAng,
             pos= HDirSouth.y,
             neg= HDirEast.y,
             deltax=0.3),
           deltax=0.3))
    "Direct solar radiation measured from direction that faces sun the most"
    annotation (Placement(transformation(extent={{14,8},{84,30}})));
  Modelica.Blocks.Math.Gain gainDif(k=2/2)
                                         "Inverse of (1+cos90)/2 - see Perez"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Modelica.Blocks.Math.Add add[3](each k2=-0.5)
    "Remove ground reflecting light"
    annotation (Placement(transformation(extent={{-48,70},{-28,90}})));
  Modelica.Blocks.Math.Gain rhoGai[3](k=rho*(1 - Modelica.Math.cos(vertical)))
    "Ground reflectance factor: 0.35 reflectance * (1+cos90)/2 - lower factor west becasue of window, which produces perpendicular reflectance"
    annotation (Placement(transformation(extent={{-20,42},{-40,62}})));
public
  Modelica.Blocks.Sources.RealExpression HGloHor(y=cos(incHor.incAng)*HDirMax.y
         + solDifHor) "Global horizontal radiation without reflectance"
    annotation (Placement(transformation(extent={{62,42},{14,62}})));
  Modelica.Blocks.Interfaces.RealInput angDec "Declination angle"
    annotation (Placement(transformation(extent={{-124,-60},{-84,-20}})));
  Modelica.Blocks.Interfaces.RealInput solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{-124,-86},{-84,-46}})));

  Modelica.Blocks.Interfaces.RealInput F1 "Brightness coefficient 1"
    annotation (Placement(transformation(extent={{-124,96},{-84,136}})));
  Modelica.Blocks.Interfaces.RealInput F2 "Brightness coefficient 2"
    annotation (Placement(transformation(extent={{-124,126},{-84,166}})));
  Modelica.Blocks.Math.Division product[
                                       3] "Inverse of perez"
    annotation (Placement(transformation(extent={{-14,92},{6,72}})));
public
  Modelica.Blocks.Sources.RealExpression perezCoeff[3](y={((0.5*(1 - F1)*(1 +
        Modelica.Math.cos(vertical)) + F1*a[1]/b + F2*Modelica.Math.sin(
        vertical))),((0.5*(1 - F1)*(1 + Modelica.Math.cos(vertical)) + F1*a[2]/
        b + F2*Modelica.Math.sin(vertical))),((0.5*(1 - F1)*(1 +
        Modelica.Math.cos(vertical)) + F1*a[3]/b + F2*Modelica.Math.sin(
        vertical)))}) "Inverse of perez computation"
    annotation (Placement(transformation(extent={{-100,90},{-20,110}})));

  Modelica.Blocks.Interfaces.RealInput angZen "Zenith angle"
    annotation (Placement(transformation(extent={{-124,-112},{-84,-72}})));
equation
  connect(HDirHorVal.y, solDirHor) annotation (Line(
      points={{64.4,64},{88.3,64},{88.3,50},{108,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirMax.y, solDirPer) annotation (Line(
      points={{87.5,19},{87.5,19.5},{108,19.5},{108,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gainDif.y, solDifHor)
    annotation (Line(points={{81,80},{108,80}}, color={0,0,127}));
  connect(rhoGai.y, add.u2) annotation (Line(points={{-41,52},{-52,52},{-52,74},
          {-50,74}}, color={0,0,127}));
  connect(add[1].u1, H_east) annotation (Line(points={{-50,86},{-72,86},{-72,80},
          {-104,80}}, color={0,0,127}));
  connect(add[2].u1, H_south)
    annotation (Line(points={{-50,86},{-104,86},{-104,40}}, color={0,0,127}));
  connect(add[3].u1, H_west)
    annotation (Line(points={{-50,86},{-104,86},{-104,0}}, color={0,0,127}));
  connect(HGloHor.y, rhoGai[1].u)
    annotation (Line(points={{11.6,52},{-18,52}}, color={0,0,127}));
  connect(HGloHor.y, rhoGai[2].u)
    annotation (Line(points={{11.6,52},{-4,52},{-18,52}}, color={0,0,127}));
  connect(HGloHor.y, rhoGai[3].u)
    annotation (Line(points={{11.6,52},{-3.2,52},{-18,52}}, color={0,0,127}));
  connect(solHouAng, incEast.solHouAng) annotation (Line(points={{-104,-66},{20,
          -66},{20,-102.8},{38,-102.8}}, color={0,0,127}));
  connect(solHouAng, incWest.solHouAng) annotation (Line(points={{-104,-66},{20,
          -66},{20,-76.8},{38,-76.8}}, color={0,0,127}));
  connect(solHouAng, incSouth.solHouAng) annotation (Line(points={{-104,-66},{20,
          -66},{20,-52.8},{38,-52.8}}, color={0,0,127}));
  connect(solHouAng, incHor.solHouAng) annotation (Line(points={{-104,-66},{-42,
          -66},{20,-66},{20,-26.8},{38,-26.8}}, color={0,0,127}));
  connect(angDec, incEast.decAng) annotation (Line(points={{-104,-40},{24,-40},{
          24,-92.6},{37.8,-92.6}}, color={0,0,127}));
  connect(angDec, incWest.decAng) annotation (Line(points={{-104,-40},{24,-40},{
          24,-66.6},{37.8,-66.6}}, color={0,0,127}));
  connect(angDec, incSouth.decAng) annotation (Line(points={{-104,-40},{-40,-40},
          {24,-40},{24,-42.6},{37.8,-42.6}}, color={0,0,127}));
  connect(angDec, incHor.decAng) annotation (Line(points={{-104,-40},{-76,-40},{
          24,-40},{24,-16.6},{37.8,-16.6}}, color={0,0,127}));
  connect(product.y, Hmin.u) annotation (Line(points={{7,82},{12,82},{12,80},{18,
          80}}, color={0,0,127}));
  connect(add.y, product.u1) annotation (Line(points={{-27,80},{-22,80},{-22,76},
          {-16,76}}, color={0,0,127}));
  connect(product.u2, perezCoeff.y)
    annotation (Line(points={{-16,88},{-16,88},{-16,100}}, color={0,0,127}));
  connect(Hmin.y, gainDif.u) annotation (Line(points={{41,80},{50,80},{50,80},{
          58,80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
January 17, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block is a more accurate version of 
<a href=modelica://IDEAS.Examples.TwinHouses.BaseClasses.RadiationConvertor>
IDEAS.Examples.TwinHouses.BaseClasses.RadiationConvertor</a>.
</p>
<p>
However the solution does not converge. 
This may be either to an implementation error, or because a solution does not exist.
</p>
</html>"));
end RadiationConvertorPerez;
