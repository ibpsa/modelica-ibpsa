within IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data;
record PipeDataULg160104_2 "Experimental data from ULg's pipe test bench from 4 January 2016. Low mass flow"
  extends IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
    T_start_out=15.0,
    T_start_in=17.9,
    m_flowIni=0.2494,
    final nCol = 6,
    final filNam = Modelica.Utilities.Files.loadResource(
  "modelica://IBPSA/Resources/Data/Fluid/FixedResistances/Validation/PlugFlowPipes/PipeDataULg160104_2.mos"));
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
end PipeDataULg160104_2;
