within IDEAS.Fluid.Production.Interfaces;
model PartialDynamicHeaterWithLosses
  "Partial heater model incl dynamics and environmental losses"
  import IDEAS;

  import IDEAS.Fluid.Production.BaseClasses.HeaterType;
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true, dp_nominal = 0);

  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(T_start=293.15, redeclare
      replaceable package Medium =
        IDEAS.Media.Water);

public
  parameter HeaterType heaterType
    "Type of the heater, is used mainly for post processing";
  parameter Modelica.SIunits.Power QNom "Nominal power";

  Modelica.SIunits.Power PFuel "Fuel consumption in watt";
  parameter Modelica.SIunits.Time tauHeatLoss=7200
    "Time constant of environmental heat losses";
  parameter Modelica.SIunits.Mass mWater=5 "Mass of water in the condensor";
  parameter Modelica.SIunits.HeatCapacity cDry=4800
    "Capacity of dry material lumped to condensor";

  final parameter Modelica.SIunits.ThermalConductance UALoss=(cDry + mWater*
      Medium.specificHeatCapacityCp(Medium.setState_pTX(Medium.p_default, Medium.T_default,Medium.X_default)))/tauHeatLoss;

protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=
        UALoss) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-70})));

public
  Modelica.Blocks.Interfaces.RealInput TSet "Temperature setpoint"
                           annotation (Placement(
        transformation(extent={{-126,-20},{-86,20}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
  Modelica.Blocks.Interfaces.RealOutput PEl "Electrical consumption"
    annotation (Placement(transformation(extent={{-94,46},{-114,66}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-100})));
  parameter SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";
  parameter SI.Pressure dp_nominal=0 "Pressure";

protected
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    m=mWater,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    dynamicBalance=dynamicBalance,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    homotopyInitialization=homotopyInitialization,
    mSenFac= if mWater > Modelica.Constants.eps then 1 + cDry/Medium.specificHeatCapacityCp(Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))/mWater else 0)
         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-10})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Fluid inlet"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Fluid outlet"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort Tin(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Inlet temperature"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  parameter Boolean dynamicBalance=true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Dialog(tab="Flow resistance"));
  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Flow resistance"));
  IDEAS.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort for thermal losses to environment"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
equation

  connect(port_a, Tin.port_a) annotation (Line(
      points={{100,-60},{90,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.heatPort, thermalLosses.port_a) annotation (Line(
      points={{30,-10},{1.77636e-015,-10},{1.77636e-015,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tin.port_b, senMasFlo.port_a) annotation (Line(
      points={{70,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, pipe_HeatPort.port_a) annotation (Line(
      points={{50,-60},{40,-60},{40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thermalLosses.port_b, heatPort) annotation (Line(
      points={{-1.77636e-015,-80},{-1.77636e-015,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, port_b) annotation (Line(
      points={{40,0},{40,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
                             annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>This is a partial model from which most heaters (boilers, heat pumps) will extend. This model is <u>dynamic</u> (there is a water content in the heater and a dry mass lumped to it) and it has <u>thermal losses to the environment</u>. To complete this model and turn it into a heater, a <u>heatSource</u> has to be added, specifying how much heat is injected in the heatedFluid pipe, at which efficiency, if there is a maximum power, etc. HeatSource models are grouped in <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses\">IDEAS.Thermal.Components.Production.BaseClasses.</a></p>
<p>The set temperature of the model is passed as a realInput.The model has a realOutput PEl for the electricity consumption.</p>
<p>See the extensions of this model for more details.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>the temperature of the dry mass is identical as the outlet temperature of the heater </li>
<li>no pressure drop</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>Depending on the extended model, different parameters will have to be set. Common to all these extensions are the following:</p>
<p><ol>
<li>the environmental heat losses are specified by a <u>time constant</u>. Based on the water content, dry capacity and this time constant, the UA value of the heat transfer to the environment will be set</li>
<li>set the heaterType (useful in post-processing)</li>
<li>connect the set temperature to the TSet realInput connector</li>
<li>connect the flowPorts (flowPort_b is the outlet) </li>
<li>if heat losses to environment are to be considered, connect heatPort to the environment.  If this port is not connected, the dry capacity and water content will still make this a dynamic model, but without heat losses to environment,.  IN that case, the time constant is not used.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This partial model is based on physical principles and is not validated. Extensions may be validated.</p>
<p><h4>Examples</h4></p>
<p>See the extensions, like the <a href=\"modelica://IDEAS.Thermal.Components.Production.IdealHeater\">IdealHeater</a>, the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> or <a href=\"modelica://IDEAS.Thermal.Components.Production.HP_AWMod_Losses\">air-water heat pump</a></p>
</html>", revisions="<html>
<ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
</ul>
</html>"));
end PartialDynamicHeaterWithLosses;
