within IBPSA.BoundaryConditions.BESTEST;
model IsotropicAndPerezDiffuseRadiation
  "Partial model to run BESTEST validation case studies for weather data processing"
  extends
    IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;
  Modelica.Blocks.Interfaces.RealOutput HPer(
     final quantity="RadiantEnergyFluenceRate",
     final unit="W/m2") "Radiation per unit area"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt angle";
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude angle";
  parameter Modelica.SIunits.Angle azi(displayUnit="deg") "Azimuth angle";
  parameter Real rho=0.2 "Ground reflectance";

  SolarIrradiation.DirectTiltedSurface HDir(
    til=til,
    lat=lat,
    azi=azi) "Direct Irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  SolarIrradiation.DiffuseIsotropic HDiffIso(
    til=til,
    rho=rho,
    outSkyCon=true,
    outGroCon=true) "Isoentropic diffuse radiation"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  SolarIrradiation.DiffusePerez HDiffPer(
    til=til,
    rho=rho,
    lat=lat,
    azi=azi,
    outSkyCon=true,
    outGroCon=true) "Diffused radiation using Perez "
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
protected
  Modelica.Blocks.Math.Add addHdirHdiffIso
    "Sum of Direct radiation and Isoentropic radiation"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Math.Add addHdirHdiffPer
    "Sum of Direct radiation and Perez radiation"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
equation
  connect(weaBus, HDiffIso.weaBus) annotation (Line(
      points={{-100,0},{-74,0},{-74,70},{-40,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(HDir.weaBus, HDiffIso.weaBus) annotation (Line(
      points={{-40,0},{-74,0},{-74,70},{-40,70}},
      color={255,204,51},
      thickness=0.5));
  connect(HDiffPer.weaBus, HDiffIso.weaBus) annotation (Line(
      points={{-40,-70},{-74,-70},{-74,70},{-40,70}},
      color={255,204,51},
      thickness=0.5));
  connect(HDir.H,addHdirHdiffPer. u1) annotation (Line(points={{-19,0},{0,0},{0,
          -34},{48,-34}}, color={0,0,127}));
  connect(HDiffPer.H,addHdirHdiffPer. u2) annotation (Line(points={{-19,-70},{0,
          -70},{0,-46},{48,-46}},  color={0,0,127}));
  connect(HDiffIso.H,addHdirHdiffIso. u1) annotation (Line(points={{-19,70},{0,
          70},{0,6},{48,6}},
                           color={0,0,127}));
  connect(HDir.H,addHdirHdiffIso. u2)
    annotation (Line(points={{-19,0},{0,0},{0,-6},{48,-6}}, color={0,0,127}));
  connect(addHdirHdiffIso.y, H) annotation (Line(points={{71,0},{110,0}},
                    color={0,0,127}));
  connect(addHdirHdiffPer.y, HPer) annotation (Line(points={{71,-40},{110,-40}},
                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
<li>
April 14, 2020, by Ettore Zanetti:<br/>
Rework after comments from pull request
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1339\">#1339</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model outputs the global radiation with a certain inclination and orientation
using the isotropic sky model and the Perez sky model.</p>
</html>"));
end IsotropicAndPerezDiffuseRadiation;
