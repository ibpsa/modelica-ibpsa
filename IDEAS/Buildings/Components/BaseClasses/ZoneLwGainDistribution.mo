within IDEAS.Buildings.Components.BaseClasses;
model ZoneLwGainDistribution "distribution of radiative internal gains"

parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";

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

protected
  Real[nSurf] areaAbsDifSol = area.*epsSw "longwave emissivity weighted areas";
  Real areaAbsDifTotSol= sum(areaAbsDifSol)
    "sum of longwave emissivity weighted areas";
  Real[nSurf] areaAbsDifGain = area.*epsLw
    "shortwave emissivity weighted areas";
  Real areaAbsDifTotGain= sum(areaAbsDifGain)
    "sum of shortwave emissivity weighted areas";
  Real[nSurf] weightFactor = area ./ (ones(nSurf)*sum(area))
    "weightfactor for received direct shortwave solar radiation";

equation
for k in 1:nSurf loop
  radSurfTot[k].Q_flow = - areaAbsDifSol[k] * iSolDif.Q_flow / areaAbsDifTotSol - weightFactor[k] * iSolDir.Q_flow - areaAbsDifGain[k] * radGain.Q_flow / areaAbsDifTotGain;
end for;

TRad = sum(radSurfTot.T.*area/sum(area));

iSolDir.T=273.15;
iSolDif.T=273.15;
radGain.T=TRad;

  annotation (Diagram(graphics), Icon(graphics={
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
          smooth=Smooth.None)}));
end ZoneLwGainDistribution;
