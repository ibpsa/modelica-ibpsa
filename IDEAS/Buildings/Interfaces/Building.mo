within IDEAS.Buildings.Interfaces;
partial model Building

  outer IDEAS.Climate.SimInfoManager  sim
    annotation (Placement(transformation(extent={{130,-100},{150,-80}})));

parameter Integer nZones(min=1) "number of conditioned zones for simulation";
parameter Modelica.SIunits.Area ATrans
    "transmission heat loss area of the residential unit";
parameter Modelica.SIunits.Volume[nZones] VZones
    "conditioned volume of the building based on external dimensions";

final parameter Modelica.SIunits.Length C = sum(VZones)/ATrans;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] gainCon
    annotation (Placement(transformation(extent={{140,10},{160,30}}),
        iconTransformation(extent={{90,10},{110,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] gainRad
    annotation (Placement(transformation(extent={{140,-30},{160,-10}}),
        iconTransformation(extent={{90,-30},{110,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] genEmb
    annotation (Placement(transformation(extent={{140,50},{160,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Blocks.Interfaces.RealOutput[nZones] TSensor
    annotation (Placement(transformation(extent={{146,-70},{166,-50}})));
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
            {150,100}}),
                  graphics={Line(
          points={{60,8},{0,60},{-60,10},{-60,-60},{60,-60}},
          color={127,0,0},
          smooth=Smooth.None), Polygon(
          points={{-24,30},{-30,26},{-58,50},{-110,8},{-110,-52},{2,-52},{2,-60},
              {-118,-60},{-118,10},{-58,60},{-24,30}},
          lineColor={127,0,0},
          smooth=Smooth.None), Polygon(
          points={{60,8},{56,4},{0,50},{-52,8},{-52,-52},{60,-52},{60,-60},{-60,
              -60},{-60,10},{0,60},{60,8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid)}),                         Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},{150,100}}),
        graphics));

end Building;
