within IDEAS.Thermal.Components.Emission.Auxiliaries;
partial model Partial_Emission
  "Partial emission system for both radiators and floor heating"

  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  parameter EmissionType emissionType = EmissionType.RadiatorsAndFloorHeating
    "Type of the heat emission system";

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

// Interfaces ////////////////////////////////////////////////////////////////////////////////////////
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortCon if
      (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "convective heat transfer from radiators"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortRad if
      (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "radiation heat transfer from radiators"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortEmb if
      (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "Port to the core of a floor heating/concrete activation"
    annotation (Placement(transformation(extent={{-96,90},{-76,110}})));
// General parameters for the design (nominal) conditions /////////////////////////////////////////////

// Other parameters//////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all state variables";
  replaceable parameter Thermal.Components.Emission.FH_Characteristics FHChars if (
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
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Thermal.Components.Interfaces.FlowPort_b flowPort_b(h(start=TInitial*medium.cp,
        fixed=false), medium=medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
initial equation
  //der(flowPort_a.h) = 0;
  annotation(Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.HorizontalCylinder), Rectangle(
          extent={{100,-100},{-102,0}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None)}),
      Diagram(graphics));
end Partial_Emission;
