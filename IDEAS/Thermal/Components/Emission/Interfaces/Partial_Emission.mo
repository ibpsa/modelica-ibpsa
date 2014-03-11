within IDEAS.Thermal.Components.Emission.Interfaces;
partial model Partial_Emission
  "Partial emission system for both radiators and floor heating"

  parameter Boolean floorHeating "true if the emission has a floor heating";
  parameter Boolean radiators "true if the emission has a radiator";

  // Interfaces ////////////////////////////////////////////////////////////////////////////////////////
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon if radiators
    "Convective heat transfer from radiators" annotation (Placement(
        transformation(extent={{40,50},{60,70}}), iconTransformation(extent={{
            40,50},{60,70}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad if radiators
    "Radiative heat transfer from radiators" annotation (Placement(
        transformation(extent={{80,50},{100,70}}), iconTransformation(extent={{
            80,50},{100,70}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPortEmb if floorHeating
    "Port to the core of a floor heating/concrete activation"
    annotation (Placement(transformation(extent={{-60,48},{-40,68}}),
        iconTransformation(extent={{-60,48},{-40,68}})));

  // Other parameters//////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all state variables";
  replaceable parameter IDEAS.Thermal.Components.BaseClasses.FH_Characteristics
    FHChars if floorHeating constrainedby
    IDEAS.Thermal.Components.BaseClasses.FH_Characteristics
    "Properties of the floor heating or TABS, if present"
    annotation(Dialog(enable=floorHeating));

  // Variables ///////////////////////////////////////////////////////////////////////////////////////////
  Modelica.SIunits.SpecificEnthalpy hMean(start=hInitial, fixed=false)
    "Mean water specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy hIn(start=hInitial, fixed=false)
    "Specific enthalpy of medium inflow through flowPort_a";
  Modelica.SIunits.SpecificEnthalpy hOut(start=hInitial, fixed=false)
    "Specific enthalpy of medium outflow through flowPort_b";

protected
  constant Modelica.SIunits.SpecificEnthalpy hInitial
    "Initial specific enthalpy of the states, calculated from initial temperature in initial equation";

  Thermal.Components.Interfaces.FlowPort_a flowPort_a(redeclare package Medium
      = Medium) "Fluid inlet"
                annotation (Placement(
        transformation(extent={{-110,-80},{-90,-60}}), iconTransformation(
          extent={{-110,-80},{-90,-60}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(redeclare package Medium
      = Medium) "Fluid outlet"
                 annotation (Placement(
        transformation(extent={{130,20},{150,40}}), iconTransformation(extent={
            {130,20},{150,40}})));

public
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);
initial equation
  hInitial = Medium.specificEnthalpy(Medium.setState_pTX(flowPort_a.p,TInitial,Medium.X_default));
  annotation (
    Icon(coordinateSystem(extent={{-100,-100},{140,60}}, preserveAspectRatio=
            true), graphics={
        Line(
          points={{-70,-70},{-100,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-70,-60},{-70,-80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{110,40},{110,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{110,30},{140,30}},
          color={0,0,127},
          smooth=Smooth.None)}),
    Diagram(coordinateSystem(extent={{-100,-100},{140,60}}, preserveAspectRatio=false),
                  graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Partial class for hydraulic heat emission systems. Can be used to create radiators, fan coil units etc. but also for embedded systems (or thermally activated building systems, TABS) like floor heating, wall heating, concrete core activation etc. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Defines 3 thermal ports: one for embedded systems, and two for stand-alone heat emission systems</li>
<li>Defines an inlet and outlet flowPort, but no dynamics nor equations are predefined in this partial class.</li>
<li>Defines variables TIn, TOut and TMean, the medium and the initial temperature TInitial.</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>See the extensions of this class, like the <a href=\"modelica://IDEAS.Thermal.Components.Emission.Radiator\">Radiator</a> or EmbeddedPipe models. </p>
<p>Common to all those types is that the <a href=\"modelica://IDEAS.Thermal.Components.Emission.Interfaces.EmissionType\">emissionType</a> (enumeration) is to be set and this defines the presence of the heatPorts.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
end Partial_Emission;
