within IDEAS.Thermal.Components.Emission;
package Interfaces

extends Modelica.Icons.InterfacesPackage;

  partial model Partial_Emission
    "Partial emission system for both radiators and floor heating"

    import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;
    parameter IDEAS.Thermal.Components.Emission.Interfaces.EmissionType
                           emissionType = EmissionType.RadiatorsAndFloorHeating
      "Type of the heat emission system";

    parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water()
      "Medium in the emission system";

  // Interfaces ////////////////////////////////////////////////////////////////////////////////////////
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon if
        (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
      "convective heat transfer from radiators"
      annotation (Placement(transformation(extent={{40,50},{60,70}}),
          iconTransformation(extent={{40,50},{60,70}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad if
        (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
      "radiation heat transfer from radiators"
      annotation (Placement(transformation(extent={{80,50},{100,70}}),
          iconTransformation(extent={{80,50},{100,70}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPortEmb if
        (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
      "Port to the core of a floor heating/concrete activation"
      annotation (Placement(transformation(extent={{-60,48},{-40,68}}),
          iconTransformation(extent={{-60,48},{-40,68}})));
  // General parameters for the design (nominal) conditions /////////////////////////////////////////////

  // Other parameters//////////////////////////////////////////////////////////////////////////////////////
    parameter Modelica.SIunits.Temperature TInitial=293.15
      "Initial temperature of all state variables";
    replaceable parameter
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics            FHChars if (
      emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
      "Properties of the floor heating or TABS, if present"                                                                                                     annotation (choicesAllMatching=true);

  // Variables ///////////////////////////////////////////////////////////////////////////////////////////
    Modelica.SIunits.Temperature TMean(start=TInitial, fixed=false)
      "Mean water temperature";
    Modelica.SIunits.Temperature TIn(start=TInitial, fixed=false)
      "Temperature of medium inflow through flowPort_a";
    Modelica.SIunits.Temperature TOut(start=TInitial, fixed=false)
      "Temperature of medium outflow through flowPort_b";

  // General outputs

    Thermal.Components.Interfaces.FlowPort_a flowPort_a(h(start=TInitial*medium.cp,
          fixed=false), medium=medium) "Fluid inlet"
      annotation (Placement(transformation(extent={{-110,-80},{-90,-60}}),
          iconTransformation(extent={{-110,-80},{-90,-60}})));
    Thermal.Components.Interfaces.FlowPort_b flowPort_b(h(start=TInitial*medium.cp,
          fixed=false), medium=medium) "Fluid outlet"
      annotation (Placement(transformation(extent={{130,20},{150,40}}),
          iconTransformation(extent={{130,20},{150,40}})));
  initial equation
    //der(flowPort_a.h) = 0;
    annotation(Icon(coordinateSystem(extent={{-100,-100},{140,60}},
            preserveAspectRatio=true),
                    graphics={
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
        Diagram(coordinateSystem(extent={{-100,-100},{140,60}},
            preserveAspectRatio=true),
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
</html>",   revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
  end Partial_Emission;

  model Partial_EmbeddedPipe "Partial for the embedded pipe model"
    import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;
    extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Emission(
                             final emissionType = EmissionType.FloorHeating);

    parameter Modelica.SIunits.MassFlowRate m_flowMin
      "Minimal flowrate when in operation";

    annotation (Icon(graphics={
          Line(
            points={{-60,-70},{-40,-70}},
            color={0,128,255},
            smooth=Smooth.None),
          Line(
            points={{100,30},{80,30}},
            color={0,128,255},
            smooth=Smooth.None),
          Line(
            points={{-40,-70},{-40,56},{-20,56},{-20,-98},{-2,-98},{-2,56},{20,
                56},{20,-98},{40,-98},{40,56},{62,56},{62,-98},{80,-98},{80,30}},
            color={0,128,255},
            smooth=Smooth.None),
          Line(
            points={{-60,-80},{-60,-60}},
            color={0,128,255},
            smooth=Smooth.None),
          Line(
            points={{100,20},{100,40}},
            color={0,128,255},
            smooth=Smooth.None)}), Documentation(info="<html>
<p>This model fixes the emissionType (to <code>EmissionType.FloorHeating)</code>and specifies a minimum flow rate.  </p>
<p>And it creates a nice icon for the embedded pipe models :-) </p>
</html>"));
  end Partial_EmbeddedPipe;

  partial model Partial_Tabs "Partial tabs model"

    replaceable parameter
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics            FHChars(A_Floor=
          A_Floor) constrainedby
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
        A_Floor=A_Floor)                                                    annotation (choicesAllMatching = true);

    parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
      "Medium in the component";
    parameter Modelica.SIunits.MassFlowRate m_flowMin
      "Minimal flowrate when in operation";
    parameter Modelica.SIunits.Area A_Floor=1 "Total Surface of the TABS";

    Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium)
      annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
    Thermal.Components.Interfaces.FlowPort_b flowPort_b(medium=medium)
      annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
      annotation (Placement(transformation(extent={{-10,90},{10,110}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
      annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));

    annotation (Diagram(graphics), Documentation(info="<html>
<p>This partial model mainly specifies the interfaces of a TABS:</p>
<p>- two flowPorts, for the fluid connections (in and out)</p>
<p>- two heatPorts, for heat transfer to the upper and lower side. By not connecting a heatPort, no heat transfer through that port wil occur (=perfectly insulated).</p>
<p>Furthermore, it specifies a Floor area and the floor characteristics.</p>
<p>It takes two models to create a full TABS: an embedded pipe and a naked tabs.  Actually, the embedded pipe components are often used together with a building component, and in that case the naked tabs model and this partial model are not needed: the embedded heatPort of the EmbeddedPipe is connected to the corresponding layer in the building model. </p>
</html>"));

  end Partial_Tabs;

  type EmissionType = enumeration(
      Radiators "Radiators",
      FloorHeating "Floor heating",
      RadiatorsAndFloorHeating "Both radiators and floor heating")
    "Type of the emission system: radiarors or floor heating";
end Interfaces;
