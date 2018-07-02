within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers;
model BorefieldTwoUTube
  extends partialBorefield;
  Boreholes.BoreholeTwoUTube borehole
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
equation
  connect(masFloDiv.port_a, borehole.port_a)
    annotation (Line(points={{-60,0},{-40,0},{-20,0}}, color={0,127,255}));
  connect(borehole.port_b, masFloMul.port_a)
    annotation (Line(points={{20,0},{40,0},{60,0}}, color={0,127,255}));
  connect(theCol.port_a, borehole.port_wall)
    annotation (Line(points={{-20,60},{0,60},{0,20}}, color={191,0,0}));
end BorefieldTwoUTube;
