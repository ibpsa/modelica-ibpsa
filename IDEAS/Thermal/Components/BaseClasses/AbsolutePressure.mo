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
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{-150,150},{150,90}},
          lineColor={0,0,255},
          textString="%name"), Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end AbsolutePressure;
