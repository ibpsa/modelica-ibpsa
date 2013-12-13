within IDEAS.Thermal.Components.Interfaces.Partials;
partial model Ambient "Partial model of ambient"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Ambient medium" annotation (__Dymola_choicesAllMatching=true);
  Modelica.SIunits.Temperature T "Outlet temperature of medium";
  Modelica.SIunits.Temperature T_port=flowPort.h/medium.cp
    "Temperature at flowPort_a";
protected
  Modelica.SIunits.SpecificEnthalpy h=medium.cp*T;
public
  FlowPort_a flowPort(final medium=medium) annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
equation
  // massflow -> ambient: mixing rule
  // massflow <- ambient: energy flow defined by ambient's temperature
  flowPort.H_flow = semiLinear(
    flowPort.m_flow,
    flowPort.h,
    h);
  annotation (Documentation(info="<HTML>
<p>
Partial model of (Infinite) ambient, defines pressure and temperature.
</p>
</HTML>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),Text(
          extent={{-150,150},{150,90}},
          lineColor={0,0,255},
          textString="%name")}));
end Ambient;
