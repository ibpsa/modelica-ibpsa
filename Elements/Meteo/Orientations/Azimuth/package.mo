within IDEAS.Elements.Meteo.Orientations;
package Azimuth "Enumeration for surface azimuth"
   constant Modelica.SIunits.Angle South = 0
  "Azimuth for an exterior wall whose outer surface faces south";
   constant Modelica.SIunits.Angle East = - Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces east";
   constant Modelica.SIunits.Angle North = Modelica.Constants.pi
  "Azimuth for an exterior wall whose outer surface faces north";
   constant Modelica.SIunits.Angle West = + Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces west";


annotation (             Icon(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-100,-100},{100,100}},
      grid={1,1}), graphics={
      Rectangle(
        extent={{-100,-100},{80,50}},
        lineColor={175,175,175},
        fillColor={248,248,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-100,50},{-80,70},{100,70},{80,50},{-100,50}},
        lineColor={175,175,175},
        fillColor={248,248,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{100,70},{100,-80},{80,-100},{80,50},{100,70}},
        lineColor={175,175,175},
        fillColor={248,248,255},
        fillPattern=FillPattern.Solid)}));
end Azimuth;
