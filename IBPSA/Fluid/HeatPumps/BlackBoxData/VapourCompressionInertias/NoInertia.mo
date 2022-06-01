within IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias;
model NoInertia "No inertia"
  extends BaseClasses.PartialInertia;
equation
  connect(u, y) annotation (Line(points={{-120,0},{110,0}}, color={0,0,127}));
  annotation (Icon(graphics={Line(points={{-100,0},{102,0}}, color={0,0,127})}));
end NoInertia;
