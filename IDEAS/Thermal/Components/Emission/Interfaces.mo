within IDEAS.Thermal.Components.Emission;
package Interfaces

extends Modelica.Icons.InterfacesPackage;

  partial model Partial_Emission
    "Partial emission system for both radiators and floor heating"

    import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;
    parameter IDEAS.Thermal.Components.Emission.Interfaces.EmissionType
                           emissionType = EmissionType.RadiatorsAndFloorHeating
      "Type of the heat emission system";

    parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

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
      emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating) annotation (choicesAllMatching=true);

  // Variables ///////////////////////////////////////////////////////////////////////////////////////////
    Modelica.SIunits.Temperature TMean(start=TInitial, fixed=false)
      "Mean water temperature";
    Modelica.SIunits.Temperature TIn(start=TInitial, fixed=false)
      "Temperature of medium inflow through flowPort_a";
    Modelica.SIunits.Temperature TOut(start=TInitial, fixed=false)
      "Temperature of medium outflow through flowPort_b";

  // General outputs

    Thermal.Components.Interfaces.FlowPort_a flowPort_a(h(start=TInitial*medium.cp,
          fixed=false), medium=medium)
      annotation (Placement(transformation(extent={{-110,-80},{-90,-60}}),
          iconTransformation(extent={{-110,-80},{-90,-60}})));
    Thermal.Components.Interfaces.FlowPort_b flowPort_b(h(start=TInitial*medium.cp,
          fixed=false), medium=medium)
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
                graphics));
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
            smooth=Smooth.None)}));
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

    annotation (Diagram(graphics));

  end Partial_Tabs;

  type EmissionType = enumeration(
      Radiators "Radiators",
      FloorHeating "Floor heating",
      RadiatorsAndFloorHeating "Both radiators and floor heating")
    "Type of the emission system: radiarors or floor heating";
end Interfaces;
