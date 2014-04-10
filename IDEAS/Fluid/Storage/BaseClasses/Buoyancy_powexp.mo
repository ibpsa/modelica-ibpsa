within IDEAS.Fluid.Storage.BaseClasses;
model Buoyancy_powexp
  "Buoyancy power depends on a power of the number of nodes "

  extends IDEAS.Fluid.Storage.BaseClasses.Partial_Buoyancy;

  parameter SI.ThermalConductance powBuo=1 "Equivalent thermal conductivity "
    annotation (Evaluate=false);
  parameter Real expNodes=1.5 "Exponent for the number of nodes"
    annotation (Evaluate=false);

initial equation
  assert(powBuo <> 1, "Error: powBuo has to be set to a realistic value");

equation
  for i in 1:nbrNodes - 1 loop
    Q_flow[i] = powBuo*dT[i]*nbrNodes^expNodes;
  end for;

  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Buoyancy model that computes the buoyancy heat flux as <u>a function of the power of the number of nodes</u>.</p>
<p>This model computes a heat flow rate that can be added to fluid volumes in order to model buoyancy during a temperature inversion in a storage tank. For simplicity, this model does not compute a buoyancy induced mass flow rate, but rather a heat flow that has the same magnitude as the enthalpy flow associated with the buoyancy induced mass flow rate. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Heat flux computation instead of mass flow rates</li>
<li>The buoyancy heat flux Q_flow[i] between node i+1 and node i equals </li>
<p><br/><i>Q_flow[i]&nbsp;=&nbsp;powBuo&nbsp;*&nbsp;dT[i]&nbsp;* nbrNodes^expNodes</i></p>
<p><br/>where:</p>
<p><i>powBuo</i> = equivalent thermal conductivity for buoancy</p>
<p><i>dT[i]</i> = <i>max(T[i+1]-T[i],&nbsp;0)</i>, so this is the temperature&nbsp;difference&nbsp;between&nbsp;layer&nbsp;i+1&nbsp;and&nbsp;i in case of temperature inversion</p>
<p><i>nbrNodes</i> = number of nodes</p>
<p><i>expNodes</i> = parameter, exponent of the number of nodes</p>
<li>Connected to a storage tank through an array of heatPorts of size=nbrNodes</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>This model has been instantiated as replaceable in a storage tank model, and the appropriate subclass can be chosen directly in the parameter interface of the storage tank. </li>
<li>Set the two parameters <i>powBuo</i> and <i>expNodes</i> of this model together with the modification of the buoyancy model. The default values are 24 and 1.5 respectively, they ware identified according to De Coninck et al. (2013).</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This model has been validated to some extent by fitting powBuo and expNodes on catalogue data of a Viesmann Vitocell100V 390 liter storage tank with internal heat exchanger (Viessmann, 2011). See De Coninck et al. (2013) for more information.</p>
<p>Based on this validation exercise, it was concluded that the thermal behaviour of the storage tank was following the manufacturer data for different number of nodes for the following parameters:</p>
<p><ul>
<li>powBuo ~ 24 (for 10 nodes). For different number of nodes,the optimal value of powBuo varies slightly, as shown in the picture below (powBuo = kBuo in the picture).</li>
<li>expNodes = 1.5 </li>
</ul></p>
<p>For different manufacturer data, different parameter values can be found, so use these values with care. </p>
<p><img src=\"modelica://IDEAS/../Specifications/Thermal/images/Validation_Vitocell100V390l_powBuo_nbrNodespower1.5.png\"/></p>
<p><h4>Examples</h4></p>
<p>See the documentation of the <a href=\"modelica://IDEAS.Thermal.Components.Storage.StorageTank\">StorageTank</a> and <a href=\"modelica://IDEAS.Thermal.Components.Storage.StorageTank_OneIntHX\">StorageTank_ONeINtHX</a>.  </p>
<p>Different example models use a storage tank. A basic setup with a thermostatic valve and only discharging can be found in<a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageWithThermostaticMixing\"> IDEAS.Thermal.Components.Examples.StorageWithThermostaticMixing</a>. </p>
<p><h4>References</h4></p>
<p>De Coninck et al. (2013) - De Coninck, R., Baetens, R., Saelens, D., Woyte, A., &AMP; Helsen, L. (2013). Rule-based demand side management of domestic hot water production with heat pumps in zero energy neighbourhoods. Journal of Building Performance Simulation (accepted). </p>
<p>Viessmann. 2011. Vitocell- 100-V, 390 liter, Datenblatt. Accessed April 21, 2013. <a href=\"http://tinyurl.com/cdpv8rr\">http://tinyurl.com/cdpv8rr</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 October, Roel De Coninck: new buoyancy model. </li>
<li>2008, Michael Wetter, first implementation.</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-44,68},{36,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-44,-26},{36,-66}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{24,10},{30,-22}},
          lineColor={127,0,0},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),Polygon(
          points={{26,22},{20,10},{34,10},{34,10},{26,22}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-32,22},{-26,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),Polygon(
          points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end Buoyancy_powexp;
