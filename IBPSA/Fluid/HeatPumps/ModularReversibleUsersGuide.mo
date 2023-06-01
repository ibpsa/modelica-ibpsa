within IBPSA.Fluid.HeatPumps;
package ModularReversibleUsersGuide
  "User's Guide for modular reversible heat pump and chiller models"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
  Model of a reversible, modular heat pump. 
  You can combine any of the avaiable model approaches 
  for refrigerant for heating and cooling, add inertias, 
  heat losses, and safety controls. 
  All features are optional.
</p>
<p>
  Adding to the partial model (
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleRefrigerantMachine\">
  IBPSA.Fluid.HeatPumps.BaseClasses.PartialReversibleRefrigerantMachine</a>), 
  this model adds the <code>hea</code> signal to choose 
  the operation type of the heat pump:
</p>
<ul>
<li><code>hea = true</code>: Main operation mode (heat pump: heating) </li>
<li><code>hea = false</code>: Reversible operation mode (heat pump: cooling) </li>
</ul>
<p>
  For guidance on how to use this model, please check pre-configured approaches here:</p>
<ul>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.LargeScaleWaterToWater\">IBPSA.Fluid.HeatPumps.LargeScaleWaterToWater</a></li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D\">IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D</a></li>
<li><a href=\"modelica://IBPSA.Fluid.HeatPumps.ReversibleCarnotWithLosses\">IBPSA.Fluid.HeatPumps.ReversibleCarnotWithLosses</a></li>
</ul>

<p>
  This partial model for a generic grey-box refrigerant machine 
  (heat pump or chiller) uses empirical data or equations to model 
  the refrigerant cycle. The modelling of system inertias and heat 
  losses allow the simulation of transient states.
</p>
<p>
  Resulting in the chosen model structure, 
  several configurations are possible:
</p>
<ol>
<li>Compressor type: on/off or inverter controlled </li>
<li>Reversible operation / only main operation </li>
<li>Source/Sink: Any combination of mediums is possible </li>
<li>
  Generic: Losses and inertias can be switched on or off. 
  The modeling approach of the refrigerant cycle is modular, 
  enabling various modeling approaches.
</li>
</ol>
<h4>Concept</h4>
<p>
  To model both on/off and inverter controlled refrigerant machines, 
  the compressor speed is normalizd to a relative value between 0 and 1.
</p>
<p>
  Possible icing of the evaporator is modelled in the 
  replaceable refrigerant cyle models with a value between 0 and 1.
</p>
<p>
  Using an expandable bus connector, all relevant signals are aggregated. 
  In order to control both chillers and heat pumps, 
  both flow and return temperature are relevant.
</p>
<p>
  The model structure is as follows. 
  To understand each submodel, please have a look at 
  the corresponding model information:
</p>
<ol>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle\">
  IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.PartialHeatPumpRefrigerantCycle</a>: 
  Here, users can select between several refrigerant cycle models or 
  create their own model. Please look at the model documentation for more info.
</li>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias\">
  IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias</a>:
  An n-order delay element may be used (or any other SISO model) to model 
  system inertias (mass and thermal) of components inside the 
  refrigerant cycle (compressor, pipes, expansion valve, fluid, etc.)
</li>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity\">
  IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity</a>: 
  This model adds thermal interias and heat losses in a heat exchanger. 
  Please look at the model description for more info.
</li>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl\">
  IBPSA.Fluid.HeatPumps.SafetyControls.SafetyControl</a>: 
  Refrigerant machines contain internal safety controls, 
  prohibiting operations in possibly unsafe points. 
  This model account for such typical controls. 
  All options can be disabled, if required. 
  Please look at the model description for more info.
</li>
</ol>
<h4>Assumptions</h4>
<p>
  Several assumptions were made in order to model the refrigerant machine. 
  For a detailed description see the corresponding model.
</p>
<ol>
<li>
  <b>Inertia</b>: The default value of the n-th order element is set to 3. 
  This follows comparisons with experimental data. 
  Previous models are using n = 1 as a default. 
  However, it was pointed out that a higher order element fits 
  a real heat pump better in internal experiments.
  At the same time, higher-order elements require more computational 
  time.
</li>
<li>
  <b>Scaling factor</b>: A scaling facor 
  <code>scaFac</code> is implemented for scaling of the thermal power 
  and capacity. The factor scales the parameters 
  <code>V</code>, <code>m_flow_nominal</code>, 
  <code>C</code>, <code>GIns</code>, 
  <code>GOut</code> and <code>dp_nominal</code>. 
  As a result, the refrigerant machine can supply more heat with 
  the COP staying nearly constant. However, one has to make sure 
  that the movers in use also scale with this factor.
</li>
</ol>
<h4>Known Limitations</h4>
<ul>
<li>
  Reversing the mode: A normal 4-way-exchange valve suffers 
  from heat losses and irreversibilities due to switching from 
  one mode to another. Theses losses are not taken into account.
</li>
<li>
  Transient interactions between refrigerant and 
  source / sink sides are neglected.
</li>
</ul>
<h4>References</h4>
<ul>
<li>F. Wuellhorst et al., A Modular Model of Reversible Heat 
Pumps and Chillers for System Applications, 
https://doi.org/10.3384/ecp21181561
</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
  <i>May 31, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));

end ModularReversibleUsersGuide;
