within IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer;
model ZoneLwGainDistribution "distribution of radiative internal gains"

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir
    "Direct solar radiation gains received through windows"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDif
    "Diffuse solar radiation gains received through windows"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a radGain
    "External long wave internal gains, e.g. from radiator"
    annotation (Placement(transformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] radSurfTot
    "Port for connecting to surfaces"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput TRad
    "Radiative zone temperature, computed as weighted sum of surface temperatures."
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw(
     each final unit="1")
    "Long wave surface emissivities of connected surfaces" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsSw(
     each final unit="1")
    "Short wave surface emissivities of connected surfaces" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] area(
     each final unit="m2")
    "Surface areas of connected surfaces" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,100})));

protected
  final parameter Real[nSurf] weightFactorDir(each final fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Real[nSurf] weightFactorDif(each final fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Real[nSurf] weightFactorGain(each final fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Real[nSurf] weightFactorTRad(each final fixed=false)
    "weightfactor for received direct shortwave solar radiation";

initial equation

  weightFactorDir = area / sum(area);
  weightFactorTRad = weightFactorDir;
  weightFactorDif = area .* epsSw / sum(area .* epsSw);
  weightFactorGain = area .* epsLw / sum(area .* epsLw);

equation
  for k in 1:nSurf loop
    radSurfTot[k].Q_flow =
      -weightFactorDif[k]*iSolDif.Q_flow
      -weightFactorDir[k]*iSolDir.Q_flow
      -weightFactorGain[k]*radGain.Q_flow;
  end for;

  TRad = radSurfTot.T * weightFactorTRad;

  iSolDir.T = TRad;
  iSolDif.T = TRad;
  radGain.T = TRad;

  annotation (
    Diagram(graphics),
    Icon(graphics={
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
          extent={{-15,80},{15,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          origin={9,66},
          rotation=90),
        Rectangle(
          extent={{90,80},{60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-70,50},{60,50},{60,-80}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>The exchange of longwave radiation in a zone has been previously described in the building component models and further considering the heat balance of the interior surface. Here, an expression based on <i>radiant interchange configuration factors</i> or <i>view factors</i> is avoided based on a delta-star transformation and by definition of a <i>radiant star temperature</i> <img src=\"modelica://IDEAS/Images/equations/equation-rE4hQkmG.png\"/>. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. This <img src=\"modelica://IDEAS/Images/equations/equation-rE4hQkmG.png\"/> can be derived from the law of energy conservation in the radiant star node as <img src=\"modelica://IDEAS/Images/equations/equation-iH8dRZqh.png\"/> must equal zero. Long wave radiation from internal sources are dealt with by including them in the heat balance of the radiant star node resulting in a diffuse distribution of the radiative source.</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2016 by Filip Jorissen:<br/>
Simplified implementation by removing intermediate variables.
</li>
</ul>
</html>"));
end ZoneLwGainDistribution;
