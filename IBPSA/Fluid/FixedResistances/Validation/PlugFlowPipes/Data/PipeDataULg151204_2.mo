within IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data;
record PipeDataULg151204_2
  "Experimental data from ULg's pipe test bench from December 4, 2015 (2)"
  extends IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
    T_start_out=14.3,
    T_start_in=14.7,
    m_flowIni=1.251,
    final nCol = 6,
    final filNam = Modelica.Utilities.Files.loadResource(
  "modelica://IBPSA/Resources/Data/Fluid/FixedResistances/Validation/PlugFlowPipes/PipeDataULg151204_2.mos"));
  annotation (Documentation(revisions="<html>
<ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This data record contains the experimental data from the
long test bench carried out at the University of Liège.
See <a href=\"IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg\">
IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg</a>
for more information.
</p>
</html>"));
end PipeDataULg151204_2;
