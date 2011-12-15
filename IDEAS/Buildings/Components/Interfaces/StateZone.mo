within IDEAS.Buildings.Components.Interfaces;
partial model StateZone

outer IDEAS.Climate.SimInfoManager sim "Simulation information manager"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

parameter Integer nSurf(min=1) "Number of surfaces adjacent to the zone";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b gainRad
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a gainCon
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-104,30})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSurf] surfCon
    annotation (Placement(transformation(extent={{-110,-40},{-90,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] surfRad
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDif
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsSw
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-104,0})));
  Modelica.Blocks.Interfaces.RealOutput TSensor
    annotation (Placement(transformation(extent={{96,-10},{116,10}}),
        iconTransformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] area
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-104,60})));
  annotation (Diagram(graphics),
              Diagram(graphics), Icon(graphics={
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
          points={{-40,-90},{68,22},{68,-42},{40,-70},{40,-90},{-40,-90},{-40,
              -90}},
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
