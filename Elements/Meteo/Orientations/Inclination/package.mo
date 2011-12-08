within IDEAS.Elements.Meteo.Orientations;
package Inclination "Enumeration for surface inclinations"
  constant Modelica.SIunits.Angle Ceiling = 0 "inclination for ceiling";
  constant Modelica.SIunits.Angle Wall = Modelica.Constants.pi/2
  "inclination for vertical wall";
  constant Modelica.SIunits.Angle Floor = Modelica.Constants.pi
  "inclination for floor";


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
end Inclination;
