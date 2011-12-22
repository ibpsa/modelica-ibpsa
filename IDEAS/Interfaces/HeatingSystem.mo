within IDEAS.Interfaces;
partial model HeatingSystem

  parameter Integer nZones(min=1) "number of conditioned thermal zones";
  parameter Integer nLoads(min=1) "number of electric loads";

  parameter Modelica.SIunits.Power[nZones] QNom(each min=0)
    "Nominal power, can be seen as the max power of the EMISSION system";

  parameter Real[nZones] VZones "conditioned (C) volumes (V) of the zones";
  parameter Modelica.SIunits.HeatCapacity[nZones] C = 1012*1.204*VZones*5
    "Heat capacity of the conditioned zones";

  outer IDEAS.Climate.SimInfoManager  sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortRad
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[nLoads]
    pinLoad
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortEmb
    "Port to the core of a floor heating/concrete activation"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealInput[nZones] TSensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-96,-60})));
  Modelica.Blocks.Interfaces.RealInput[nZones] TSet
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-90})));
  annotation(Icon(graphics={
        Polygon(
          points={{-46,-8},{-46,-20},{-44,-22},{-24,-10},{-24,2},{-26,4},{-46,-8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-32},{-46,-44},{-44,-46},{-24,-34},{-24,-22},{-26,-20},{-46,
              -32}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-44,-18},{-50,-22},{-50,-46},{-46,-50},{28,-50},{42,-40}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,-46},{-44,-42}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,0},{-20,2},{-20,-32},{-16,-36},{-16,-36},{40,-36}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-24},{-20,-22}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{40,-26},{40,-46},{50,-52},{58,-46},{58,-30},{54,-24},{48,-20},
              {40,-26}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid)}),                         Diagram(
        graphics));

end HeatingSystem;
