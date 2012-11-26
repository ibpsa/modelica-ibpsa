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
                  graphics),
      Diagram(coordinateSystem(extent={{-100,-100},{140,60}},
          preserveAspectRatio=true),
              graphics));
end Partial_Emission;
