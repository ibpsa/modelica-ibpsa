within IDEAS.Fluid.Storage;
model StorageTank "1D multinode stratified storage tank"

  replaceable package Medium = IDEAS.Media.Water.Simple constrainedby
    Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
  //Tank geometry and composition
  parameter Integer nbrNodes(min=1) = 10 "Number of nodes";
  parameter Modelica.SIunits.Volume volumeTank(min=0)
    "Total volume of the tank";
  parameter Modelica.SIunits.Length heightTank(min=0)
    "Total height of the tank";
  final parameter Modelica.SIunits.Mass mNode=volumeTank*Medium.density(state_default)/nbrNodes
    "Mass of each node";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer UIns(min=0) = 0.4
    "Average heat loss coefficient for insulation per m2 of tank surface";
  parameter Modelica.SIunits.ThermalConductance UACon(min=0) = 0.5
    "Additional thermal conductance for connection losses and imperfect insulation";
  parameter Modelica.SIunits.Temperature[nbrNodes] T_start={293.15 for i in 1:
      nbrNodes} "Initial temperature of all Temperature states";
  parameter SI.MassFlowRate m_flow_nominal=0.1 "Nominal mass flow rate";

  /* 
  A validation excercise has shown that TO BE COMPLETED. //fixme
    */

  parameter Boolean preventNaturalDestratification=true
    "if true, this automatically increases the insulation of the top layer";

    //fixme: change to mixingvolumes?
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort[nbrNodes] nodes(
    redeclare each package Medium=Medium,
    each m_flow_nominal=m_flow_nominal,
    each m=mNode,
    T_start=T_start) "Array of nodes";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Upper port, connected to node[1]"
    annotation (Placement(transformation(extent={{10,10},{30,30}}),
        iconTransformation(extent={{74,74},{86,86}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Lower port, connected to node[nbrNodes]"
                                                  annotation (Placement(
        transformation(extent={{10,-30},{30,-10}}),
                                                  iconTransformation(extent={{
            74,-146},{86,-134}})));
  Modelica.Fluid.Interfaces.FluidPorts_a[nbrNodes + 1] ports(
    redeclare package Medium = Medium)
    "Array of nbrNodes+1 ports. ports[i] is connected to the upper port of node i"
    annotation (Placement(transformation(extent={{-26,-50},{-12,6}}),
        iconTransformation(extent={{74,20},{86,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatExchEnv
    "HeatPort for conduction between tank and environment" annotation (
      Placement(transformation(extent={{-10,70},{10,90}}), iconTransformation(
          extent={{44,-46},{56,-34}})));

  replaceable IDEAS.Fluid.Storage.BaseClasses.Buoyancy_powexp buoyancy(
    powBuo=24,
    nbrNodes=nbrNodes,
    surCroSec=volumeTank/heightTank,
    h=heightTank)
  constrainedby IDEAS.Fluid.Storage.BaseClasses.Partial_Buoyancy(
    nbrNodes=nbrNodes,
    surCroSec=volumeTank/heightTank,
    h=heightTank)
    "buoyancy model to mix nodes in case of inversed temperature stratification";

  //fixme: documentation: only for liquids
protected
  constant Medium.ThermodynamicState state_default = Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default);
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes] lossNodes(
      G=UACon/nbrNodes*ones(nbrNodes) + UIns*
        BaseClasses.areaCalculation(
        volumeTank,
        heightTank,
        nbrNodes,
        preventNaturalDestratification))
    "Array of conduction loss components to the environment";

public
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nbrNodes - 1]
    conductionWater(each G=(volumeTank/heightTank)/(heightTank/nbrNodes)*Medium.thermalConductivity(state_default))
    "Conduction heat transfer between the layers";
  Modelica.Blocks.Interfaces.RealOutput[nbrNodes] T=nodes.heatPort.T
    annotation (Placement(transformation(extent={{70,-10},{90,10}}),
        iconTransformation(extent={{70,-10},{90,10}})));

equation
  // Connection of upper and lower node to external ports
  connect(port_a, nodes[1].port_a);
  connect(port_b, nodes[nbrNodes].port_b);

  // Interconnection of nodes
  if nbrNodes > 1 then
    for i in 2:nbrNodes loop
      connect(nodes[i - 1].port_b, nodes[i].port_a);
      connect(nodes[i - 1].heatPort, conductionWater[i - 1].port_a);
      connect(nodes[i].heatPort, conductionWater[i - 1].port_b);
    end for;
  end if;

  // Connection of environmental heat losses to the nodes
  connect(lossNodes.port_a, nodes.heatPort);
  for i in 1:nbrNodes loop
    connect(heatExchEnv, lossNodes[i].port_b);
  end for;

  // Connection of ports to the nodes
  connect(ports[1:end - 1], nodes.port_a);
  connect(ports[end], nodes[end].port_b);

  // Connection of buoyancy model
  connect(buoyancy.heatPort, nodes.heatPort);
  annotation (
    Icon(coordinateSystem(extent={{-100,-160},{80,100}}, preserveAspectRatio=false),
                   graphics={
        Polygon(
          points={{-70,74},{-68,82},{-62,88},{-52,94},{-38,98},{-22,100},{4,100},
              {18,98},{34,94},{42,88},{48,82},{50,74},{50,-134},{48,-142},{42,-148},
              {32,-154},{18,-158},{4,-160},{-24,-160},{-38,-158},{-52,-154},{-62,
              -148},{-68,-142},{-70,-134},{-70,74}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          lineThickness=0.5),
        Line(
          points={{80,80},{64,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,70},{64,90}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,70},{60,90}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-36},{-10,80},{60,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{26,46},{38,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{60,40},{32,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,30},{60,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,30},{64,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,40},{64,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{38,0},{80,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Rectangle(extent={{18,10},{38,-10}}, lineColor={100,100,100}),
        Text(
          extent={{18,10},{38,-10}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{-10,-140},{-10,-126}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,-140},{-10,-140}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,-150},{60,-130}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{64,-150},{64,-130}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,-140},{64,-140}},
          color={0,0,127},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(extent={{-100,-160},{80,100}}, preserveAspectRatio=false),
                                                             graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>1-dimensional thermal energy storage (TES) tank model for stratified water tanks. For a model with internal heat exchanger, see <a href=\"modelica://IDEAS.Thermal.Components.Storage.StorageTank_OneIntHX\">here</a>.</p>
<p>This model is composed of <i>nbrNodes</i><a href=\"modelica://IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort\"> Pipe_HeatPort</a> elements as an array nodes[nbrNodes]. The following heat transfer phenomena are modelled:</p>
<p><ul>
<li>thermal conduction between the nodes through the water </li>
<li>heat losses by conduction to the environment through the tank envelope (based on UIns and UACon)</li>
<li>forced convection due to inlet and outlet mass flows (can be at any node thanks to array <i>ports[nrbNodes+1]</i>. </li>
<li>natural convection due to buoyancy effects at moments of temperature inversion</li>
</ul></p>
<p>The tank can be modelled with <i>preventNaturalDestratification</i> = true. This will make sure that the top node is insulated more than the other nodes in order to avoid a faster cooling down of the top node than the second node and consequent temperature inversion. This stablizes the tank simulation. Additional insulation of the top node is often present but the current tank model does not foresee a variable insulation thickness as a function of node number. </p>
<p>In combination with a <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.StratifiedInlet\">StratifiedInlet</a> , a fully stratified inlet can be obtained. This means that the inlet flow rate will be entering between the nodes that have corresponding temperatures. </p>
<p>The buoyancy model is a replaceable model, but the only <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.Buoyancy_powexp\">validated buoyancy model</a> is configured by default.</p>
<p><br/>An overview of the nodal energy balance is given below:</p>
<p><br/><img src=\"modelica://IDEAS/../Specifications/Thermal/images/TESNodeEnergyBalance_low.png\"/></p>
<p><br/>(note that in this model, QHX,i = 0 because there is no internal heat exchanger. )</p>
<p><br/>The model and it&apos;s validation is explained in more detail in De Coninck et al. (2013).</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>This is a 1-D TES tank model, it is subject to the typical modelling errors in 1-D representations of complex 3-D phenomena.</li>
<li>This model is for vertical cylindrical tanks only.</li>
<li>All nodes have the same volume and geometry</li>
<li>Every node has a uniform temperature</li>
<li>Node numbering starts at the top (upper node = 1)</li>
<li>Additional thermal conduction between the nodes through the tank wall or (if present) immersed heat exchangers or stratification devices is NOT modelled.</li>
<li>One single heatPort available at the interface for heat exchange with environment</li>
<li>Besides <i>port_a</i> and <i>port_b</i>, there is an array <i>ports</i> for connections between every node. </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Set the obvious tank parameters (geometry and insulation properties). </li>
<li>The diameter of the tank is computed from volume and height</li>
<li>Set the number of nodes. It is not adviced to go below 10 nodes, whereas more than 40 nodes will not be useful either for most cases. </li>
<li>If the tank is substantially different from the Viesmann Vitocell100V 390 liter (Viessmann, 2011), adapt the buoyancy model parameters <i>powBuo</i> and <i>expNodes. </i>The default values are 24 and 1.5 respectively, they ware identified according to De Coninck et al. (2013).</li>
<li>If needed, choose a different <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.Partial_Buoyancy\">Buoyancy</a> model.</li>
<li>If a <a href=\"modelica://IDEAS.Thermal.Components.Storage.BaseClasses.StratifiedInlet\">stratified inlet</a> is desired, add this seperately to your model and connect the two arrays of <i>ports</i>. </li>
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
<p>Different example models use a storage tank. A basic setup with a thermostatic valve and only discharging can be found in<a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageWithThermostaticMixing\"> IDEAS.Thermal.Components.Examples.StorageWithThermostaticMixing</a>. </p>
<p>Other examples include a model to illustrate the<a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_Losses\"> thermal losses</a>, the use of a <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_StratifiedInlet\">stratified inlet</a> and a <a href=\"modelica://IDEAS.Thermal.Components.Examples.StorageTank_DHW_HP\">full DHW system including heat pump</a>. </p>
<p>The validation models for the calibration of the buoyancy and other parameters are found <a href=\"modelica://IDEAS.Thermal.Components.Storage.Examples\">here</a>.</p>
<p><h4>References</h4></p>
<p>De Coninck et al. (2013) - De Coninck, R., Baetens, R., Saelens, D., Woyte, A., &AMP; Helsen, L. (2013). Rule-based demand side management of domestic hot water production with heat pumps in zero energy neighbourhoods. Journal of Building Performance Simulation (accepted). </p>
<p>Viessmann. 2011. Vitocell- 100-V, 390 liter, Datenblatt. Accessed April 21, 2013. <a href=\"http://tinyurl.com/cdpv8rr\">http://tinyurl.com/cdpv8rr</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen: implemented IDEAS baseclasses</li>
<li>2013 June, Roel De Coninck: documentation.</li>
<li>2012 October, Roel De Coninck: better buoyancy models</li>
<li>2012 September, Roel De Coninck: added conduction between nodes</li>
<li>2011, Roel De Coninck: first implementation.</li>
</ul></p>
</html>"));
end StorageTank;
