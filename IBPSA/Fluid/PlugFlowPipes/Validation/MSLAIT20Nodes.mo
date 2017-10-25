within IBPSA.Fluid.PlugFlowPipes.Validation;
model MSLAIT20Nodes
  "Validation of pipe against data from Austrian Institute of Technology with standard library components"
  extends IBPSA.Fluid.PlugFlowPipes.Validation.MSLAIT2Nodes(
    nNodes=20);
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{220,
            160}})),
    experiment(StopTime=603900, Tolerance=1e-006),
    Documentation(info="<html>
<p>
The example contains
experimental data from a real district heating network. 
</p>
<p>
This model compares the results with the original Modelica Standard Library pipes.
</p>
<p>The pipes' temperatures are not initialized. Therfore, results of
outflow temperature before approximately the first 10000 seconds should not be considered.
</p><h4>Test bench schematic</h4>
<p><img alt=\"Schematic of test district heating network\"
src=\"modelica://IBPSA/Resources/Images/Experimental/AITTestBench.png\"/> </p>
<h4>Calibration</h4>
<p>To calculate the length specific thermal resistance <code>R</code> of the pipe,
the thermal resistance of the surrounding ground is added, which yields
</p>
<p align=\"center\"style=\"font-style:italic;\">R=1/(0.208)+1/(2*lambda<sub>g</sub>*Modelica.Constants.pi)*log(1/0.18),</p>
<p>where the thermal conductivity of the ground <code>lambda_g</code> = 2.4 W/(m K).
</p>
</html>", revisions="<html>
<ul>
<li>November 28, 2016 by Bram van der Heijde:<br/>Remove <code>pipVol.</code></li>
<li>August 24, 2016 by Bram van der Heijde:<br/>
Implement validation with MSL pipes for comparison, based on AIT validation.</li>
<li>July 4, 2016 by Bram van der Heijde:<br/>Added parameters to test the influence
of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br/>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/PlugFlowPipes/Validation/MSLAIT20Nodes.mos"
        "Simulate and plot"));
end MSLAIT20Nodes;
