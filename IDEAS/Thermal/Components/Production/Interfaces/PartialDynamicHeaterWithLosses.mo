within IDEAS.Thermal.Components.Production.Interfaces;
model PartialDynamicHeaterWithLosses
  "Partial heater model incl dynamics and environmental losses"

  import IDEAS.Thermal.Components.Production.BaseClasses.HeaterType;
  parameter HeaterType heaterType
    "Type of the heater, is used mainly for post processing";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of the water and dry mass";
  parameter Modelica.SIunits.Power QNom "Nominal power";
  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
    "Medium in the component";

  Modelica.SIunits.Power PFuel "Fuel consumption";
  parameter Modelica.SIunits.Time tauHeatLoss=7200
    "Time constant of environmental heat losses";
  parameter Modelica.SIunits.Mass mWater=5 "Mass of water in the condensor";
  parameter Modelica.SIunits.HeatCapacity cDry=4800
    "Capacity of dry material lumped to condensor";

  final parameter Modelica.SIunits.ThermalConductance UALoss=(cDry + mWater*
      medium.cp)/tauHeatLoss;

  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort heatedFluid(
    medium=medium,
    m=mWater,
    TInitial=TInitial) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-10,0})));

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(final medium=medium, h(
        min=1140947, max=1558647)) "Fluid inlet " annotation (Placement(
        transformation(extent={{90,-48},{110,-28}}), iconTransformation(extent=
            {{90,-48},{110,-28}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(final medium=medium, h(
        min=1140947, max=1558647)) "Fluid outlet"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mDry(C=cDry, T(start=
          TInitial)) "Lumped dry mass subject to heat exchange/accumulation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=
        UALoss) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-70})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "heatPort for thermal losses to environment" annotation (Placement(
        transformation(extent={{-40,-110},{-20,-90}}), iconTransformation(
          extent={{-40,-110},{-20,-90}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Temperature setpoint, acts as on/off signal too" annotation (Placement(
        transformation(extent={{-126,-20},{-86,20}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,120})));
  Modelica.Blocks.Interfaces.RealOutput PEl "Electrical consumption"
    annotation (Placement(transformation(extent={{-252,10},{-232,30}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-74,-100})));
equation

  connect(flowPort_a, heatedFluid.flowPort_a) annotation (Line(
      points={{100,-38},{-10,-38},{-10,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedFluid.flowPort_b, flowPort_b) annotation (Line(
      points={{-10,10},{-10,20},{100,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mDry.port, heatedFluid.heatPort) annotation (Line(
      points={{-30,-30},{-30,6.12323e-016},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mDry.port, thermalLosses.port_a) annotation (Line(
      points={{-30,-30},{-30,-30},{-30,-60},{-30,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalLosses.port_b, heatPort) annotation (Line(
      points={{-30,-80},{-30,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,120}},
          preserveAspectRatio=false), graphics),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}}, preserveAspectRatio=
            false), graphics),
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
</html>"));
end PartialDynamicHeaterWithLosses;
