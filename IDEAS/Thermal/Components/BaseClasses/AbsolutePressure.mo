within IDEAS.Thermal.Components.BaseClasses;
model AbsolutePressure "Defines absolute pressure level"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water() "medium"
    annotation(__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.Pressure p(start=0) "Pressure ground";
  Thermal.Components.Interfaces.FlowPort_a flowPort(final medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
equation
  // defining pressure
  flowPort.p = p;
  // no energy exchange; no mass flow by default
  flowPort.H_flow = 0;
annotation (Documentation(info="<HTML>
AbsolutePressure to define pressure level of a closed cooling cycle.
Coolant's mass flow, temperature and enthalpy flow are not affected.<br>
</HTML>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics={
        Line(
          points={{-70,20},{-70,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{-60,60},{60,-60}}, lineColor={100,100,100})}));
end AbsolutePressure;
