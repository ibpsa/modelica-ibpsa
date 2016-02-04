within IDEAS.Buildings.Components.BaseClasses;
model ZoneLwDistribution "internal longwave radiative heat exchange"

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";

  parameter Boolean linearise=true "Linearise radiative heat exchange";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSurf] port_a
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  IDEAS.Buildings.Components.BaseClasses.HeatRadiation[nSurf] radRes(
    R=R,
    each linearise=linearise);

  Modelica.Blocks.Interfaces.RealInput[nSurf] A "surface areas" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw
    "longwave surface emissivities" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

protected
  Real[nSurf] F=A ./ (ones(nSurf)*sum(A) - A) "view factor per surface";
  Real[nSurf] R=(ones(nSurf) - epsLw) ./ (A .* epsLw) + (ones(nSurf) - F) ./ A
    "heat resistance for logwave radiative heat exchange";

equation
  for i in 1:nSurf loop
    connect(radRes[i].port_b, port_a[i]);
  end for;

  for i in 1:nSurf - 1 loop
    connect(radRes[i].port_a, radRes[i + 1].port_a);
  end for;

  annotation (
    Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-90,80},{90,-80}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          lineColor={0,0,0}),
        Rectangle(
          extent={{68,60},{-68,-60}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=0.5),
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
        Line(
          points={{-68,60},{68,60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{68,60},{68,-60},{-68,-60},{-68,60}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>The exchange of longwave radiation in a zone has been previously described in the building component models and further considering the heat balance of the interior surface. Here, an expression based on <i>radiant interchange configuration factors</i> or <i>view factors</i> is avoided based on a delta-star transformation and by definition of a <i>radiant star temperature</i> <img src=\"modelica://IDEAS/Images/equations/equation-rE4hQkmG.png\"/>. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. This <img src=\"modelica://IDEAS/Images/equations/equation-rE4hQkmG.png\"/> can be derived from the law of energy conservation in the radiant star node as <img src=\"modelica://IDEAS/Images/equations/equation-iH8dRZqh.png\"/> must equal zero. Long wave radiation from internal sources are dealt with by including them in the heat balance of the radiant star node resulting in a diffuse distribution of the radiative source.</p>
</html>"));
end ZoneLwDistribution;
