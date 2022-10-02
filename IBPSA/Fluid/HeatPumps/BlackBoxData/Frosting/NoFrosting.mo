within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting;
model NoFrosting "No frosting, iceFac=1"
  extends BaseClasses.PartialIceFac;
  Modelica.Blocks.Sources.Constant constNoIce(final k=1)
    "If no frosting is modeled, set iceFac=1 always" annotation (Placement(
        transformation(extent={{-10,10},{10,-10}}, rotation=0)));
equation
  connect(constNoIce.y, iceFac)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Don't account for frosting.</p>
</html>"));
end NoFrosting;
