within IDEAS.Buildings.Components.BaseClasses;
model ZoneLwGainDistribution "distribution of radiative internal gains"

extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";
  parameter Real[nSurf] weightFactor
    "weightfactor for received shortwave solar radiation";

protected
  Real[nSurf] areaAbsDifSol = area.*epsSw "longwave emissivity weighted areas";
  Real areaAbsDifTotSol= sum(areaAbsDifSol)
    "sum of longwave emissivity weighted areas";
  Real[nSurf] areaAbsDifGain = area.*epsLw
    "shortwave emissivity weighted areas";
  Real areaAbsDifTotGain= sum(areaAbsDifGain)
    "sum of shortwave emissivity weighted areas";

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir
    "direct solar radiation gains recieved through windows"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDif
    "difuse solar radiation gains recieved through windows"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a radGain
    "longwave internal gains"
    annotation (Placement(transformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] radSurfTot
    "total recieved radiation by surface"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput TRad "radiative zonetemperature"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));

  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw
    "longwave surface emissivities"                                                 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsSw
    "shortwave surface emissivities"                                                 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] area "surface areas" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,100})));
equation
for k in 1:nSurf loop
  radSurfTot[k].Q_flow = - areaAbsDifSol[k] * iSolDif.Q_flow / areaAbsDifTotSol - weightFactor[k] * iSolDir.Q_flow - areaAbsDifGain[k] * radGain.Q_flow / areaAbsDifTotGain;
end for;

TRad = sum(radSurfTot.T.*area/sum(area));

iSolDir.T=273.15;
iSolDif.T=273.15;
radGain.T=TRad;

  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-54,38},{72,38}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={72.5,-0.5},
          rotation=90),
        Rectangle(
          extent={{-10,48},{30,30}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,46},{-48,32}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Line(
          points={{-54,0},{98,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-10,10},{30,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,8},{-48,-6}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Line(
          points={{-54,-38},{74,-38}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-10,-28},{30,-46}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,-30},{-48,-44}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0})}));
end ZoneLwGainDistribution;
