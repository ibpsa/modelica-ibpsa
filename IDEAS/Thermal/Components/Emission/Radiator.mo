within IDEAS.Thermal.Components.Emission;
model Radiator "Simple 1-node radiator model according to EN 442"

  extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Emission(final
      floorHeating=false, final radiators=true);

  parameter Modelica.SIunits.Temperature TInNom=75 + 273.15
    "Nominal inlet temperature";
  parameter Modelica.SIunits.Temperature TOutNom=65 + 273.15
    "Nominal outlet temperature";
  parameter Modelica.SIunits.Temperature TZoneNom=20 + 273.15
    "Nominal room temperature";

  parameter Modelica.SIunits.Power QNom=1000
    "Nominal thermal power at the specified conditions";
  parameter Real fraRad=0.35 "Fraction of radiation at Nominal power";
  parameter Real n=1.3 "Radiator coefficient according to EN 442-2";

  parameter Real powerFactor=1 "Size increase compared to design at 75/65/20";
  // For reference: 45/35/20 is 3.37; 50/40/20 is 2.5:
  // Source: http://www.radson.com/be/producten/paneelradiatoren/radson-compact.htm, accessed on 15/06/2011
  parameter Modelica.SIunits.Mass mMedium(start=1) = 0.0038*QNom*powerFactor
    "Mass of medium (water) in the radiator";
  parameter Modelica.SIunits.Mass mDry(start=1) = 0.018*QNom*powerFactor
    "Mass of dry material (steel/aluminium) in the radiator";
  // cpDry for steel: based on carbon steel, Polytechnisch zakboekje, E1/8
  parameter Modelica.SIunits.SpecificHeatCapacity cpDry=480
    "Specific heat capacity of the dry material, default is for steel";

  final parameter Real UA=QNom/((TInNom + TOutNom)/2 - TZoneNom)^n;

  Modelica.SIunits.HeatFlowRate QTotal(start=0)
    "Total heat emission of the radiator";
  Modelica.SIunits.TemperatureDifference dTRadRoo;
  Modelica.SIunits.Power QHeatTotal=-heatPortCon.Q_flow - heatPortRad.Q_flow;

protected
  parameter Modelica.SIunits.MassFlowRate mFlowNom=QNom/medium.cp/(TInNom -
      TOutNom) "nominal mass flowrate";

equation
  dTRadRoo = max(0, TMean - heatPortCon.T);
  // mass balance
  flowPort_a.m_flow + flowPort_b.m_flow = 0;

  // no pressure drop
  flowPort_a.p = flowPort_b.p;

  // fixing temperatures
  if noEvent(flowPort_a.m_flow > mFlowNom/10) then
    TIn = flowPort_a.h/medium.cp;
    TOut = max(heatPortCon.T, 2*TMean - TIn);
  else
    TIn = TMean;
    TOut = TMean;
  end if;

  // radiator equation
  QTotal = -UA*(dTRadRoo)^n;
  // negative for heat emission!
  heatPortCon.Q_flow = QTotal*(1 - fraRad);
  heatPortRad.Q_flow = QTotal*fraRad;

  // energy balance
  // the mass is lumped to TMean!  TOut can be DIFFERENT from TMean (when there is a flowrate)
  flowPort_a.H_flow + flowPort_b.H_flow + QTotal = (mMedium*medium.cp + mDry*
    cpDry)*der(TMean);

  // massflow a->b mixing rule at a, energy flow at b defined by medium's temperature
  // massflow b->a mixing rule at b, energy flow at a defined by medium's temperature
  flowPort_a.H_flow = semiLinear(
    flowPort_a.m_flow,
    flowPort_a.h,
    TOut*medium.cp);
  flowPort_b.H_flow = semiLinear(
    flowPort_b.m_flow,
    flowPort_b.h,
    TOut*medium.cp);
  annotation (Documentation(info="<html>
<p><b>Description</b> </p>
<p>Simplified dynamic radiator model, not discretized, based on EN&nbsp;442-2. </p>
<p>The <u>thermal emission</u> of the radiator is based on three equations:</p>
<p><code>&nbsp;QTotal&nbsp;=&nbsp;-&nbsp;UA&nbsp;*&nbsp;(dTRadRoo)^n;<font style=\"color: #006400; \">&nbsp;//&nbsp;negative&nbsp;for&nbsp;heat&nbsp;emission!</font></code></p>
<pre> heatPortCon.Q_flow&nbsp;=&nbsp;QTotal&nbsp;*&nbsp;(1-fraRad);
&nbsp;heatPortRad.Q_flow&nbsp;=&nbsp;QTotal&nbsp;*&nbsp;fraRad;</pre>
<p>In these equations, the temperature difference between radiator and room is based on TMean, while the outlet temperature TOut can be different. When there is no flow rate, all temperatures are equal and follow TMean. The first equation is the so-called radiator equation according&nbsp;to&nbsp;EN&nbsp;442-2, with n the radiator exponent (~ 1.3 for normal radiators).</p>
<p>The&nbsp;<u>capacity&nbsp;of&nbsp;the&nbsp;radiator</u>&nbsp;is&nbsp;based&nbsp;on&nbsp;a&nbsp;calculation&nbsp;for&nbsp;one&nbsp;type&nbsp;of&nbsp;radiator&nbsp;from&nbsp;Radson.&nbsp;&nbsp;The&nbsp;headlines&nbsp;of&nbsp;the&nbsp;calculation:</p>
<p>&nbsp;&nbsp;-&nbsp;we&nbsp;suppose&nbsp;the&nbsp;normative&nbsp;75/65/20&nbsp;design&nbsp;conditions&nbsp;(this&nbsp;is&nbsp;a&nbsp;crucial&nbsp;parameter: InletTemperature/OutletTemperature/AmbientTemperature!!!) </p>
<p>&nbsp;&nbsp;-&nbsp;we&nbsp;take&nbsp;a&nbsp;type&nbsp;22&nbsp;radiator&nbsp;from&nbsp;the&nbsp;Radson&nbsp;Compact&nbsp;or&nbsp;Integra&nbsp;series</p>
<p>&nbsp;&nbsp;-&nbsp;we&nbsp;take&nbsp;a&nbsp;length&nbsp;of&nbsp;1.05m,&nbsp;height&nbsp;0.6m</p>
<p>&nbsp;&nbsp;-&nbsp;we&nbsp;get&nbsp;a&nbsp;power&nbsp;of&nbsp;1924W,&nbsp;a&nbsp;water&nbsp;content&nbsp;of&nbsp;7.24&nbsp;l&nbsp;and&nbsp;a&nbsp;steel&nbsp;weight&nbsp;of&nbsp;35.52&nbsp;kg</p>
<p>&nbsp;&nbsp;-&nbsp;water&nbsp;content:&nbsp;0.0038&nbsp;l/W&nbsp;</p>
<p>&nbsp;&nbsp;-&nbsp;steel&nbsp;weight:&nbsp;0.018&nbsp;kg/W</p>
<p>&nbsp;&nbsp;Resulting&nbsp;capacity:&nbsp;24.6&nbsp;J/K&nbsp;per&nbsp;Watt&nbsp;of&nbsp;nominal&nbsp;power</p>
<p>&nbsp;&nbsp;Redo&nbsp;this&nbsp;calculation&nbsp;for&nbsp;other&nbsp;design&nbsp;conditions. &nbsp;Example:&nbsp;for&nbsp;45/35/20&nbsp;we&nbsp;would&nbsp;get&nbsp;3.37&nbsp;times&nbsp;less&nbsp;power,&nbsp;&nbsp;so&nbsp;we&nbsp;have&nbsp;to&nbsp;increase&nbsp;the&nbsp;volume&nbsp;and&nbsp;weight&nbsp;per&nbsp;Watt&nbsp;by&nbsp;3.37</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Simplified model based on normed radiator equation</li>
<li>No discretization (use an array of Radiators to obtain discretization)</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set all the parameters specifying the nominal power of the radiator (temperatures, Nominal heating power, radiator coefficient n, ...)</li>
<li>Set the parameters specifying the inertia (water content and dry mass). First, the powerFactor is set according to the design temperatures (for&nbsp;reference:&nbsp;45/35/20&nbsp;is&nbsp;3.37;&nbsp;50/40/20&nbsp;is&nbsp;2.5; Source:&nbsp;http://www.radson.com/be/producten/paneelradiatoren/compact.htm,&nbsp;accessed&nbsp;on&nbsp;15/06/2011). In most cases, this will be sufficient. The default computation for mMedium and mDry can be overwritten if a specific design is known. </li>
<li>Connect<u><b> both the heatPortCon and heatPortRad, </b></u>connection only one of them will lead to WRONG RESULTS.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>Validation has not been performed, but different verification models have been made to verify the properties under different operating conditions.</p>
<p><ul>
<li>the energy balance is checked for different operating conditions in <a href=\"modelica://IDEAS.Thermal.Components.Examples.Radiator_EnergyBalance\">IDEAS.Thermal.Components.Examples.Radiator_EnergyBalance</a></li>
<li>cooling down behaviour is tested in<a href=\"modelica://IDEAS.Thermal.Components.Examples.Radiator_CoolingDown\"> IDEAS.Thermal.Components.Examples.Radiator_CoolingDown</a></li>
</ul></p>
<p><h4>Example (optional) </h4></p>
<p>Besides the validation models, an example of the use of the radiator can be found in <a href=\"modelica://IDEAS.Thermal.Components.Examples.RadiatorWithMixingValve\">IDEAS.Thermal.Components.Examples.RadiatorWithMixingValve</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2012 April, Roel De Coninck: rebasing on common Partial_Emission</li>
<li>2011, Roel De Coninck: first version</li>
</ul></p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {140,60}}), graphics={
        Rectangle(extent={{-64,-100},{-42,60}}, lineColor={135,135,135}),
        Rectangle(extent={{-34,-100},{-12,60}}, lineColor={135,135,135}),
        Rectangle(extent={{-4,-100},{18,60}}, lineColor={135,135,135}),
        Rectangle(extent={{26,-100},{48,60}}, lineColor={135,135,135}),
        Rectangle(extent={{54,-100},{76,60}}, lineColor={135,135,135}),
        Rectangle(extent={{82,-100},{104,60}}, lineColor={135,135,135})}));
end Radiator;
