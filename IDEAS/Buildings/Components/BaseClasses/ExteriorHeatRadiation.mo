within IDEAS.Buildings.Components.BaseClasses;
model ExteriorHeatRadiation
  "longwave radiative heat exchange of an exterior surface with the environment"

  parameter Modelica.SIunits.Area A "Surface area";
  parameter Boolean linearise = true "Linearise radiative heat transfer"
    annotation(Evaluate=true, Dialog(group="Linearisation"));
  parameter Modelica.SIunits.Temperature Tenv_nom = 280
    "Nominal temperature of environment"
    annotation(Dialog(group="Linearisation", enable=linearise));
  parameter Modelica.SIunits.TemperatureDifference dT_nom = 5
    "Nominal temperature difference between wall and environment"
    annotation(Dialog(group="Linearisation", enable=linearise));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput Tenv
    "Radiative temperature of the total environment"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));

  Modelica.Blocks.Interfaces.RealInput epsLw
    "Longwave emissivity of the surface"
    annotation (Placement(transformation(extent={{-120,14},{-80,54}})));

protected
  Real coeffLin = Modelica.Constants.sigma*A*epsLw*(2*Tenv_nom+dT_nom)*(Tenv_nom^2+(Tenv_nom+dT_nom)^2)
    "Coefficient allowing less overhead. This implementation is an approximation of the real linearization f(u)_lin = df/du|(u=u_bar) * (u-u_bar) + f|u_bar. The accuracy of it has been checked.";
  Real coeffNonLin = Modelica.Constants.sigma*A*epsLw
    "Coefficient allowing less overhead";

equation
  if linearise then
    port_a.Q_flow = coeffLin*(port_a.T - Tenv);
  else
    port_a.Q_flow = coeffNonLin*(port_a.T^4 - Tenv^4);

  end if;
  annotation (Icon(graphics={
        Line(points={{-40,10},{40,10}}, color={191,0,0}),
        Line(points={{-40,10},{-30,16}}, color={191,0,0}),
        Line(points={{-40,10},{-30,4}}, color={191,0,0}),
        Line(points={{-40,-10},{40,-10}}, color={191,0,0}),
        Line(points={{30,-16},{40,-10}}, color={191,0,0}),
        Line(points={{30,-4},{40,-10}}, color={191,0,0}),
        Line(points={{-40,-30},{40,-30}}, color={191,0,0}),
        Line(points={{-40,-30},{-30,-24}}, color={191,0,0}),
        Line(points={{-40,-30},{-30,-36}}, color={191,0,0}),
        Line(points={{-40,30},{40,30}}, color={191,0,0}),
        Line(points={{30,24},{40,30}}, color={191,0,0}),
        Line(points={{30,36},{40,30}}, color={191,0,0}),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-60,80},{-60,-80}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{90,80},{60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{60,80},{60,-80}},
          color={0,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p>Longwave radiation between the surface and environment <img src=\"modelica://IDEAS/Images/equations/equation-AMjoTx5S.png\"/> is determined as</p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-nt0agyic.png\"/></p>
<p>as derived from the Stefan-Boltzmann law wherefore <img src=\"modelica://IDEAS/Images/equations/equation-C6ZFvd5P.png\"/> the Stefan-Boltzmann constant <a href=\"IDEAS.Buildings.UsersGuide.References\">[Mohr 2008]</a>, <img src=\"modelica://IDEAS/Images/equations/equation-sLNH0zgx.png\"/> the longwave emissivity of the exterior surface, <img src=\"modelica://IDEAS/Images/equations/equation-Q5X4Yht9.png\"/> the radiant-interchange configuration factor between the surface and sky <a href=\"IDEAS.Buildings.UsersGuide.References\">[Hamilton 1952]</a>, and the surface and the environment respectively and <img src=\"modelica://IDEAS/Images/equations/equation-k2V39u5g.png\"/> and <img src=\"modelica://IDEAS/Images/equations/equation-GuSnzLxW.png\"/> are the exterior surface and sky temperature respectively. Shortwave solar irradiation absorbed by the exterior surface is determined as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-cISf3Itz.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-IKuIUMef.png\"/> is the shortwave absorption of the surface and <img src=\"modelica://IDEAS/Images/equations/equation-Vuo4fgcb.png\"/> the total irradiation on the depicted surface. </p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end ExteriorHeatRadiation;
