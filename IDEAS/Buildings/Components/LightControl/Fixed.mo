within IDEAS.Buildings.Components.LightControl;
block Fixed "Fixed lighting"
  extends BaseClasses.PartialLights(   final useCtrlInput=false,
  final useOccInput=false);
  parameter Real ctrlFix(min=0)=0 "Fixed control signal";
  Modelica.Blocks.Sources.Constant constCtrl(final k=ctrlFix)
    "Constant block for lighting control"
    annotation (Placement(transformation(extent={{
            -12,-10},{8,10}})));
    //FIX-ME: parameter is Real instead of Integer since this way we include the possibility of adjustable lights

protected
  Interfaces.WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    annotation (Placement(transformation(extent={{-74,82},{-54,102}})));
public
  Modelica.Blocks.Math.Product product "For LIDEAS"
    annotation (Placement(transformation(extent={{40,10},{60,-10}})));
  outer BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(product.u2,weaBus. dummy) annotation (Line(points={{38,6},{24,6},{24,
          92.05},{-63.95,92.05}},
                           color={0,0,127}));
  connect(sim.weaBus,weaBus)  annotation (Line(
      points={{-81,93},{-74,93},{-74,92},{-64,92}},
      color={255,204,51},
      thickness=0.5));
  connect(constCtrl.y, product.u1)
    annotation (Line(points={{9,0},{20,0},{20,-6},{38,-6}}, color={0,0,127}));
  connect(product.y, ctrl)
    annotation (Line(points={{61,0},{120,0}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>This block defines a fixed lighting control</p>
</html>"));
end Fixed;
