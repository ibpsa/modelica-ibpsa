within IDEAS.Buildings.Components.BaseClasses;
model HeatRadiation "radiative heat exchange between two temperatures"

  input Real R "heat resistance for longwave radiative heat exchange";

  parameter Boolean linear=true;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=293.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=293.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.SIunits.TemperatureDifference dT=port_a.T - port_b.T;

equation
  port_a.Q_flow = -port_b.Q_flow;

  if linear then
    port_a.Q_flow = 0.8*5.67*dT/R;
  else
    port_a.Q_flow = Modelica.Constants.sigma/R*dT*(port_a.T + port_b.T)*(port_a.T^2 + port_b.T^2);

  end if;
  annotation (Icon(graphics={Line(points={{-40,10},{40,10}}, color={191,0,0}),
          Line(points={{-40,10},{-30,16}}, color={191,0,0}),Line(points={{-40,
          10},{-30,4}}, color={191,0,0}),Line(points={{-40,-10},{40,-10}},
          color={191,0,0}),Line(points={{30,-16},{40,-10}}, color={191,0,0}),
          Line(points={{30,-4},{40,-10}}, color={191,0,0}),Line(points={{-40,-30},
          {40,-30}}, color={191,0,0}),Line(points={{-40,-30},{-30,-24}}, color=
          {191,0,0}),Line(points={{-40,-30},{-30,-36}}, color={191,0,0}),Line(
          points={{-40,30},{40,30}}, color={191,0,0}),Line(points={{30,24},{40,
          30}}, color={191,0,0}),Line(points={{30,36},{40,30}}, color={191,0,0}),
          Rectangle(
          extent={{-90,80},{-60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),Line(
          points={{-60,80},{-60,-80}},
          color={0,0,0},
          thickness=0.5),Rectangle(
          extent={{90,80},{60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),Line(
          points={{60,80},{60,-80}},
          color={0,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p>Basic implementation of Stefan Boltzmanns law for radiation.</p>
</html>"));
end HeatRadiation;
