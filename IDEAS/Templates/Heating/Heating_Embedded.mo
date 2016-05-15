within IDEAS.Templates.Heating;
model Heating_Embedded
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar[nEmbPorts] RadSlaCha constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar
    "Properties of the floor heating or TABS, if present";
  parameter Modelica.SIunits.Area AEmb[nEmbPorts]
    "surface of each embedded circuit";
  extends IDEAS.Templates.Heating.Interfaces.Partial_HydraulicHeating(
    final isHea=true,
    final isCoo=false,
    nConvPorts=nZones,
    nRadPorts=nZones,
    nTemSen=nZones,
    nEmbPorts=nZones,
    nLoads=1,
    nZones=1,
    minSup=true,
    TSupMin=273.15 + 25,
    redeclare IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emission[
      nEmbPorts](
      redeclare each package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      m_flowMin=m_flow_nominal/3,
      RadSlaCha=RadSlaCha,
      A_floor=AEmb,
      each nParCir=1));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow[
    nConvPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-164,10},{-184,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow1[
    nRadPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-162,-30},{-182,-10}})));
equation
  QHeaSys = -sum(emission.heatPortEmb.Q_flow);
  P[1] = heater.PEl + sum(pumpRad.PEl);
  Q[1] = 0;
  connect(emission[:].heatPortEmb[1], heatPortEmb[:]) annotation (Line(
      points={{135,44},{136,44},{136,98},{-176,98},{-176,60},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatPortCon) annotation (Line(
      points={{-184,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port, heatPortRad) annotation (Line(
      points={{-182,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            200,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,100}})),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Multi-zone Hydraulic heating system with <a href=\"modelica://IDEAS.Thermal.Components.Emission.Radiator\">radiators</a>. Except for the emission system, this model is identical to <a href=\"modelica://IDEAS.Thermal.HeatingSystems.Heating_Embedded\">Heating_Embedded</a>. There is no thermal energy storage tank and no domestic hot water system. A schematic hydraulic scheme is given below:</p>
<p><img src=\"modelica://IDEAS/../Specifications/Thermal/images/HydraulicScheme_Heating_Emisision_low.png\"/></p>
<p><br/>For multizone systems, the components <i>pumpRad</i>, <i>emission</i> and <i>pipeReturn</i> are arrays of size <i>nZones</i>. In this model, the <i>emission</i> is a radiator, the <i>heater</i> is a replaceable component and can be a boiler or heat pump or anything that extends from <a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\">PartialDynamicHeaterWithLosses</a>.</p>
<p>There are two controllers in the model (not represented in the hydraulic scheme): one for the heater set temperature (<a href=\"modelica://IDEAS.Thermal.Control.Ctrl_Heating\">Ctrl_Heating</a>), and another one for the on/off signal of <i>pumpRad</i> (= thermostat). The system is controlled based on a temperature measurement in each zone, a set temperature for each zone, and a general heating curve (not per zone). The heater will produce hot water at a temperature slightly above the heating curve, and the <i>idealMixer</i> will mix it with return water to reach the heating curve set point. Right after the <i>idealMixer</i>, the flow is splitted in <i>nZones</i> flows and each <i>pumpRad</i> will set the flowrate in the zonal distribution circuit based on the zone temperature and set point. </p>
<p>The heat losses of the heater and all the pipes are connected to a central fix temperature. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Controllers try to limit or avoid events for faster simulation</li>
<li>Single heating curve for all zones</li>
<li>Heat emitted through <i>heatPortRad</i> and <i>heatPortCon</i> </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Connect the heating system to the corresponding heatPorts of a <a href=\"modelica://IDEAS.Templates.Interfaces.BaseClasses.Structure\">structure</a>. </li>
<li>Connect <i>TSet</i> and <i>TSensor</i> </li>
<li>Connect <i>plugLoad </i>to an inhome grid. A<a href=\"modelica://IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder\"> dummy inhome grid like this</a> has to be used if no inhome grid is to be modelled. </li>
<li>Set all parameters that are required. </li>
<li>Not all parameters of the sublevel components are ported to the uppermost level. Therefore, it might be required to modify these components deeper down the hierarchy. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This is a system level model, no validation performed.</p>
<p><h4>Example </h4></p>
<p>An example of the use of this model can be found in <a href=\"modelica://IDEAS.Thermal.HeatingSystems.Examples.Heating_Radiators\">IDEAS.Thermal.HeatingSystems.Examples.Heating_Radiators</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: first version</li>
</ul></p>
</html>"));
end Heating_Embedded;
