within IDEAS.Buildings.Components.BaseClasses;
model HeatRadiation "radiative heat exchange between two temperatures"

  input Real R "heat resistance for longwave radiative heat exchange";

  parameter Boolean linearise = true "Linearise radiative heat transfer"
    annotation(Evaluate=true, Dialog(group="Linearisation"));
  parameter Modelica.SIunits.Temperature Tzone_nom = 295.15
    "Nominal temperature of environment"
    annotation(Dialog(group="Linearisation", enable=linearise));
  parameter Modelica.SIunits.TemperatureDifference dT_nom = -2
    "Nominal temperature difference between wall and zone"
    annotation(Dialog(group="Linearisation", enable=linearise));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Real coeffLin = Modelica.Constants.sigma/R*(2*Tzone_nom+dT_nom)*(Tzone_nom^2+(Tzone_nom+dT_nom)^2)
    "Coefficient allowing less overhead. This implementation is an approximation of the real linearization f(u)_lin = df/du|(u=u_bar) * (u-u_bar) + f|u_bar. The accuracy of it has been checked.";
  Real coeffNonLin = Modelica.Constants.sigma/R
    "Coefficient allowing less overhead";

equation
  port_a.Q_flow+port_b.Q_flow=0;
  if linearise then
    port_a.Q_flow = coeffLin*(port_a.T - port_b.T);
  else
    port_a.Q_flow = coeffNonLin*(port_a.T^4 - port_b.T^4);
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
