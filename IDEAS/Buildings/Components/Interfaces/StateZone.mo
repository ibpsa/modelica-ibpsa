within IDEAS.Buildings.Components.Interfaces;
partial model StateZone "Partial model for thermal building zones"

  parameter Integer nSurf(min=1)
    "Number of surfaces adjacent to and heat exchangeing with the zone";
  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b gainRad
    "Internal zone node for radiative heat gains"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a gainCon
    "Internal zone node for convective heat gains"
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TSensor(unit="K", displayUnit="degC")
    "Sensor temperature of the zone, i.e. operative temeprature" annotation (
      Placement(transformation(extent={{96,-10},{116,10}}), iconTransformation(
          extent={{96,-10},{116,10}})));
  ZoneBus[nSurf] propsBus annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-100,40}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=-90,
        origin={-100,40})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-90,90},{90,-90}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          lineColor={0,0,0}),
        Rectangle(
          extent={{68,70},{-68,-70}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-68,70},{68,70}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-40,-70},{40,-90}},
          lineThickness=0.5,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-90},{68,22},{68,-42},{40,-70},{40,-90},{-40,-90},{-40,-90}},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-68,70},{-68,-70},{-40,-70},{-40,-80},{40,-80},{40,-70},{68,
              -70},{68,70}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-39,40},{39,-40}},
          lineColor={0,0,0},
          fontName="Calibri",
          origin={-2,3},
          rotation=0,
          textString="%name")}));

end StateZone;
