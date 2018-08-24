within IDEAS.Buildings.Components.Occupants;
block CustomBlock
  "Source that has replaceable for a block with a single output"
  extends IDEAS.Buildings.Components.Occupants.BaseClasses.PartialOccupants(final useInput=false);
  outer BoundaryConditions.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  replaceable Modelica.Blocks.Sources.Constant singleOutput(k=0)
  constrainedby Modelica.Blocks.Interfaces.SO
  "Custom block profile"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-10,-16},
            {10,4}})));

  Modelica.Blocks.Math.Product product "For LIDEAS"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Interfaces.WeaBus weaBus(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    annotation (Placement(transformation(extent={{-74,82},{-54,102}})));
equation
  connect(singleOutput.y, product.u2)
    annotation (Line(points={{11,-6},{38,-6}}, color={0,0,127}));
  connect(product.y, nOcc)
    annotation (Line(points={{61,0},{120,0}}, color={0,0,127}));
  connect(sim.weaBus, weaBus) annotation (Line(
      points={{-81,93},{-74,93},{-74,92},{-64,92}},
      color={255,204,51},
      thickness=0.5));
  connect(product.u1, weaBus.dummy) annotation (Line(points={{38,6},{16,6},{16,
          92.05},{-63.95,92.05}},
                           color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block can be used to define a custom profile. 
Any block that extends 
<code>Modelica.Blocks.Interfaces.SO</code>
can be inserted in this placeholder. 
The output value <code>y</code> of the block 
is then used as the number of occupants.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2018 by Damien Picard: <br/> 
Multiplied the occupant number with the dummy variable to 
avoid the suppression of it while linearizing in LIDEAS.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/812\">#812</a>.
</li>
<li>
July 26, 2018 by Filip Jorissen:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/760\">#760</a>.
</li>
</ul>
</html>"));
end CustomBlock;
