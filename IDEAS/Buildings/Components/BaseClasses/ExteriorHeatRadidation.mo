within IDEAS.Buildings.Components.BaseClasses;
model ExteriorHeatRadidation
  "longwave radiative heat exchange of an exterior surface with the environment"

extends IDEAS.Buildings.Components.Interfaces.StateSingle;
extends Modelica.Blocks.Interfaces.BlockIcon;

  outer IDEAS.Climate.SimInfoManager
                             sim "simulation information manager";

  parameter Modelica.SIunits.Area A "surface area";
  parameter Modelica.SIunits.Angle inc "inclination";

protected
  Real Fse = (1-cos(inc))/2
    "radiant-interchange configuration factor between surface and environment";
  Real Fssky = (1+cos(inc))/2
    "radiant-interchange configuration factor between surface and sky";
  Modelica.SIunits.Temperature Tenv
    "Radiative temperature of the total environment";

public
  Modelica.Blocks.Interfaces.RealInput epsLw
    "shortwave emissivity of the surface"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
equation

Tenv = (Fssky*sim.Tsky^4+(1-Fssky)*sim.Te^4)^0.25;
port_a.Q_flow = A*Modelica.Constants.sigma*epsLw*(port_a.T^4-Tenv^4);

  annotation (Icon(graphics={
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-65.5,-0.5},
          rotation=90),
        Line(
          points={{-58,-42},{64,-42}},
          color={127,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{48,42},{62,28}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Rectangle(
          extent={{-24,-32},{16,-50}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,-34},{66,-48}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360,
          fillColor={127,0,0}),
        Line(
          points={{-60,36},{60,36}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-26,46},{14,28}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-64,0},{-98,0}},
          color={127,0,0},
          smooth=Smooth.None)}));
end ExteriorHeatRadidation;
