within IDEAS.HeatingSystems;
model Heating_Radiators
  "Basic hydraulic heating (with heating curve) with radiators. No TES, no DHW"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;

  extends Interfaces.Partial_HydraulicHeatingSystem(
    radiators=true,
    floorHeating=false,
    final nLoads=1);

  Thermal.Components.BaseClasses.Pump[nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m=1) annotation (Placement(transformation(extent={{56,46},{80,22}})));

  IDEAS.Thermal.Components.Emission.Radiator[nZones] emission(
    each medium=medium,
    each TInNom=TSupNom,
    each TOutNom=TSupNom - dTSupRetNom,
    TZoneNom=TRoomNom,
    QNom=QNom,
    each powerFactor=3.37)
    annotation (Placement(transformation(extent={{88,18},{118,38}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-52,8})));

  replaceable Controls.ControlHeating.Ctrl_Heating ctrl_Heating(
    heatingCurve(timeFilter=timeFilter),
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom,
    THeaterSet(start=293.15)) constrainedby
    Controls.ControlHeating.Interfaces.Partial_Ctrl_Heating(
    heatingCurve(timeFilter=timeFilter),
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom) "Controller for the heater"
    annotation (Placement(transformation(extent={{-164,38},{-144,58}})));

  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Components.BaseClasses.Thermostatic3WayValve idealMixer(mFlowMin=0.01)
    annotation (Placement(transformation(extent={{28,22},{50,46}})));
  Components.BaseClasses.Pipe_Insulated pipeReturn(
    medium=medium,
    m=1,
    UA=10) annotation (Placement(transformation(extent={{4,-28},{-16,-36}})));

  Components.BaseClasses.Pipe_Insulated pipeSupply(
    medium=medium,
    m=1,
    UA=10) annotation (Placement(transformation(extent={{-16,30},{4,38}})));
  Components.BaseClasses.Pipe_Insulated[nZones] pipeReturnEmission(
    each medium=medium,
    each m=1,
    each UA=10)
    annotation (Placement(transformation(extent={{116,-28},{96,-36}})));
  Components.BaseClasses.AbsolutePressure absolutePressure
    annotation (Placement(transformation(extent={{-94,-42},{-114,-22}})));
equation
  QHeatTotal = -sum(emission.heatPortCon.Q_flow) - sum(emission.heatPortRad.Q_flow);
  heatingControl.uHigh = TSet + 0.5*ones(nZones);
  THeaterSet = ctrl_Heating.THeaterSet;
  P[1] = heater.PEl + sum(pumpRad.PEl);
  Q[1] = 0;

  TEmissionIn = idealMixer.flowPortMixed.h/medium.cp;
  TEmissionOut = emission.TOut;
  m_flowEmission = emission.flowPort_a.m_flow;

  // connections that are function of the number of circuits
  for i in 1:nZones loop
    connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a) annotation (Line(
        points={{50,34},{56,34}},
        color={0,128,255},
        smooth=Smooth.None));
    connect(pipeReturnEmission[i].flowPort_b, pipeReturn.flowPort_a)
      annotation (Line(
        points={{96,-32},{4,-32}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(pipeReturnEmission[i].heatPort, fixedTemperature.port) annotation (
        Line(
        points={{106,-28},{106,-4},{-52,-4},{-52,2}},
        color={191,0,0},
        smooth=Smooth.None));
  end for;

  // general connections for any configuration

  connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{106.75,38},{106.75,66},{-178,66},{-178,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{111.75,38},{114,60},{114,68},{-180,68},{-180,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b, emission.flowPort_a) annotation (Line(
      points={{80,34},{83,34},{83,21.75},{88,21.75}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{40.2222,-70},{68,-70},{68,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-104},{0,-62.5},{20.2222,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-52,2},{-52,-4},{-103,-4},{-103,14}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{94.25,37.75},{90,37.75},{90,70},{-200,70},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-204,-60},{-122,-60},{-122,-72.5},{20.2222,-72.5}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(heater.flowPort_b, pipeSupply.flowPort_a) annotation (Line(
      points={{-90,24.9091},{-76,24.9091},{-76,34},{-16,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeSupply.flowPort_b, idealMixer.flowPortHot) annotation (Line(
      points={{4,34},{28,34}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeReturn.heatPort, heater.heatPort) annotation (Line(
      points={{-6,-28},{-6,-4},{-103,-4},{-103,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeSupply.heatPort, heater.heatPort) annotation (Line(
      points={{-6,30},{-6,-4},{-103,-4},{-103,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeReturn.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-16,-32},{-76,-32},{-76,19.6364},{-90,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeReturn.flowPort_a, idealMixer.flowPortCold) annotation (Line(
      points={{4,-32},{39,-32},{39,22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(emission.flowPort_b, pipeReturnEmission.flowPort_a) annotation (Line(
      points={{118,34.25},{122,34.25},{122,34},{130,34},{130,-32},{116,-32}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(ctrl_Heating.THeaterSet, heater.TSet) annotation (Line(
      points={{-143.556,48},{-101,48},{-101,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-143.556,53},{39,53},{39,46}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(absolutePressure.flowPort, heater.flowPort_a) annotation (Line(
      points={{-94,-32},{-76,-32},{-76,19.6364},{-90,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            200,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}})),
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
<li>Connect the heating system to the corresponding heatPorts of a <a href=\"modelica://IDEAS.Interfaces.BaseClasses.Structure\">structure</a>. </li>
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
end Heating_Radiators;
