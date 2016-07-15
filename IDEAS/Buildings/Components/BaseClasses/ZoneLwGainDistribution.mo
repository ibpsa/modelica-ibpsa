within IDEAS.Buildings.Components.BaseClasses;
model ZoneLwGainDistribution "distribution of radiative internal gains"

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";
  Real test;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir
    "direct solar radiation gains received through windows"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDif
    "difuse solar radiation gains received through windows"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a radGain
    "longwave internal gains"
    annotation (Placement(transformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] radSurfTot
    "total received radiation by surface"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput TRad "radiative zonetemperature"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));

  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw
    "longwave surface emissivities" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsSw
    "shortwave surface emissivities" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] area "surface areas" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

protected
  final parameter Real[nSurf] areaAbsDifSol(fixed=false)
    "longwave emissivity weighted areas";
  final parameter Real areaAbsDifTotSol=sum(areaAbsDifSol)
    "sum of longwave emissivity weighted areas";
  final parameter Real[nSurf] areaAbsGain(fixed=false)
    "shortwave emissivity weighted areas";
  final parameter Real areaAbsTotGain = sum(areaAbsGain)
    "sum of shortwave emissivity weighted areas";

  final parameter Real[nSurf] weightFactorDir(fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Real[nSurf] weightFactorDif(fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Real[nSurf] weightFactorGain(fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Modelica.SIunits.Area AfloorTot(fixed=false)
    "Total floor surface area";
  final parameter Real ASWotherSurface(fixed=false)
    "Total absorption surface on surfaces other than the floor";
  final parameter Real fraTotAbsFloor(fixed=false)
    "Fraction of the bream radiation that is absorbed by the floor";
public
Modelica.Blocks.Interfaces.RealInput[nSurf] inc "Surface inclination angles"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] azi "Surface azimuth angles"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={80,100})));
initial equation

  areaAbsDifSol = area .* epsSw;
  areaAbsGain = area .* epsLw;
  weightFactorDir = {if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor)
                     then area[i]*epsSw[i]/AfloorTot
                     else (1-fraTotAbsFloor)*area[i]*epsSw[i]/ASWotherSurface for i in 1:nSurf};
  weightFactorDif = areaAbsDifSol ./ (ones(nSurf)*areaAbsDifTotSol);
  weightFactorGain = areaAbsGain ./ (ones(nSurf)*areaAbsTotGain);
  AfloorTot = sum({if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor) then area[i] else 0 for i in 1:nSurf}); //ok
  fraTotAbsFloor = sum({if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor) then area[i]*epsSw[i] else 0 for i in 1:nSurf})/AfloorTot; //ok
  ASWotherSurface = sum({if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor) then 0 else area[i]*epsSw[i] for i in 1:nSurf}); //ok

equation
  for k in 1:nSurf loop
    radSurfTot[k].Q_flow = -weightFactorDif[k]*iSolDif.Q_flow -
      weightFactorDir[k]*iSolDir.Q_flow - weightFactorGain[k]*radGain.Q_flow;
  end for;

  TRad = sum(radSurfTot.T .* area/sum(area));

  iSolDir.T = 273.15;
  iSolDif.T = 273.15;
  radGain.T = TRad;
  test = sum(iSolDif.Q_flow) + sum(iSolDir.Q_flow) + radGain.Q_flow + sum(radSurfTot.Q_flow);

  annotation (
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
July 15, 2016 by Filip Jorissen:<br/>
New absorption model for beam radiation based
on limited absorption of short wave radiation of the floors.
</li>
</ul>
</html>"));
end ZoneLwGainDistribution;
