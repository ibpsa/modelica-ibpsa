within IBPSA.BoundaryConditions.BESTEST;
model IsotropicAndPerezDiffuseRadiation
  "Partial model to run BESTEST validation case studies for weather data processing"
  extends
    IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;
  Modelica.Blocks.Interfaces.RealOutput HPer(
     final quantity="RadiantEnergyFluenceRate",
     final unit="W/m2") "Radiation per unit area"
    annotation (Placement(transformation(extent={{100,-36},{120,-16}})));

  parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt angle";
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude angle";
  parameter Modelica.SIunits.Angle azi(displayUnit="deg") "Azimuth angle";
  parameter Real rho=0.2 "Ground reflectance";

  SolarIrradiation.DirectTiltedSurface HDir(
    til=til,
    lat=lat,
    azi=azi) "Direct Irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  SolarIrradiation.DiffuseIsotropic HDiffIso(
    til=til,
    rho=rho,
    outSkyCon=true,
    outGroCon=true) "Isoentropic diffuse radiation"
    annotation (Placement(transformation(extent={{-32,62},{-12,82}})));
  SolarIrradiation.DiffusePerez HDiffPer(
    til=til,
    rho=rho,
    lat=lat,
    azi=azi,
    outSkyCon=true,
    outGroCon=true) "Diffused radiation using Perez "
    annotation (Placement(transformation(extent={{-32,-92},{-12,-72}})));
protected
  Modelica.Blocks.Math.Add AddHdirHdiffIso
    "Sum of Direct radiation and Isoentropic radiation"
    annotation (Placement(transformation(extent={{48,8},{68,28}})));
  Modelica.Blocks.Math.Add AddHdirHdiffPer
    "Sum of Direct radiation and Perez radiation"
    annotation (Placement(transformation(extent={{50,-34},{70,-14}})));
equation
  connect(weaBus, HDiffIso.weaBus) annotation (Line(
      points={{-100,0},{-74,0},{-74,72},{-32,72}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDir.weaBus, HDiffIso.weaBus) annotation (Line(
      points={{-32,0},{-74,0},{-74,72},{-32,72}},
      color={255,204,51},
      thickness=0.5));
  connect(HDiffPer.weaBus, HDiffIso.weaBus) annotation (Line(
      points={{-32,-82},{-74,-82},{-74,72},{-32,72}},
      color={255,204,51},
      thickness=0.5));
  connect(HDir.H, AddHdirHdiffPer.u1) annotation (Line(points={{-11,0},{2,0},{2,
          -18},{48,-18}}, color={0,0,127}));
  connect(HDiffPer.H, AddHdirHdiffPer.u2) annotation (Line(points={{-11,-82},{-8,
          -82},{-8,-30},{48,-30}}, color={0,0,127}));
  connect(HDiffIso.H, AddHdirHdiffIso.u1) annotation (Line(points={{-11,72},{2,72},
          {2,24},{46,24}}, color={0,0,127}));
  connect(HDir.H, AddHdirHdiffIso.u2)
    annotation (Line(points={{-11,0},{2,0},{2,12},{46,12}}, color={0,0,127}));
  connect(AddHdirHdiffIso.y, H) annotation (Line(points={{69,18},{86,18},{86,0},
          {110,0}}, color={0,0,127}));
  connect(AddHdirHdiffPer.y, HPer) annotation (Line(points={{71,-24},{86,-24},{86,
          -26},{110,-26}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br>First implementation.
</li>
<li>
April 14, 2020, by Ettore Zanetti:<br>Rework after comments from pull request
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1339\">#1339</a>.
</li>
</ul>
</html>", info="<html>
<p>This model is used to have as output the global radiation with a certain inclination and orientation using both the Isotropic sky model and the Perez sky model</p>
</html>"));
end IsotropicAndPerezDiffuseRadiation;
