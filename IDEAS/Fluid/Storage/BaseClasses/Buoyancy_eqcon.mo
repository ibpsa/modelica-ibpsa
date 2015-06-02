within IDEAS.Fluid.Storage.BaseClasses;
model Buoyancy_eqcon "Buoyancy modelled as additional thermal conductivity"

  extends IDEAS.Fluid.Storage.BaseClasses.Partial_Buoyancy;

  parameter SI.ThermalConductivity lamBuo=1 "Equivalent thermal conductivity ";

initial equation
  assert(lamBuo <> 1, "Error: lamBuo has to be set to a realistic value");

equation
  for i in 1:nbrNodes - 1 loop
    Q_flow[i] = lamBuo*surCroSec*dT[i]/(h/nbrNodes);
  end for;

  annotation (
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Buoyancy model that computes the buoyancy heat flux as an<u> equivalent additional thermal conductivity</u>.</p>
<p>This model computes a heat flow rate that can be added to fluid volumes in order to model buoyancy during a temperature inversion in a storage tank. For simplicity, this model does not compute a buoyancy induced mass flow rate, but rather a heat flow that has the same magnitude as the enthalpy flow associated with the buoyancy induced mass flow rate. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Heat flux computation instead of mass flow rates</li>
<li>The buoyancy heat flux Q_flow[i] between node i+1 and node i equals </li>
<p><br/><i>Q_flow[i]&nbsp;=&nbsp;lamBuo&nbsp;*&nbsp;surCroSec&nbsp;*&nbsp;dT[i]&nbsp;/&nbsp;(h/nbrNodes)</i></p>
<p><br/>where:</p>
<p>        <i>lamBuo</i> = equivalent thermal conductivity for buoyancy</p>
<p>        <i>surCroSec</i> = surface of the cross-section of the tank</p>
<p>        <i>dT[i]</i> = <i>max(T[i+1]-T[i],&nbsp;0)</i>, so this is the temperature&nbsp;difference&nbsp;between&nbsp;layer&nbsp;i+1&nbsp;and&nbsp;i in case of temperature inversion</p>
<p>        <i>h/nbrNodes</i> = node height</p>
<li>Connected to a storage tank through an array of heatPorts of size=nbrNodes</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>This model has been instantiated as replaceable in a storage tank model, and the appropriate subclass can be chosen directly in the parameter interface of the storage tank. </li>
<li>lamBuo, the only parameter of this model has to be specified together with the modification of the buoyancy model</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This model is not validated, and is merely as an example of how a buoyancy model can be created starting from the <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy\">Partial_Buoyancy</a> model.</p>
<p>The only validated buoyancy model is <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.Buoyancy_powexp\">Buoyancy_powexp</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 October, Roel De Coninck, modifications</li>
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
end Buoyancy_eqcon;
