within IBPSA.Fluid.Examples.Tutorial.SimpleHouse;
model SimpleHouse2 "Building window model"
  extends SimpleHouse1;

  parameter Modelica.Units.SI.Area A_win=2 "Window area";

  Modelica.Blocks.Math.Gain gaiWin(k=A_win)
    "Gain for solar irradiance through the window"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow window
    "Very simple window model"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(gaiWin.y,window. Q_flow) annotation (Line(points={{-39,-30},{-20,-30}},
                                color={0,0,127}));
  connect(window.port, walCap.port) annotation (Line(points={{0,-30},{132,-30},{
          132,1.77636e-15},{140,1.77636e-15}},
                         color={191,0,0}));
  connect(gaiWin.u, weaBus.HDirNor) annotation (Line(points={{-62,-30},{-150,-30},
          {-150,-10}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}})),
    experiment(StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleHouse2;
