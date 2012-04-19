within IDEAS.Thermal.HeatingSystems;
partial model Partial_HeatingSystem "Most generic partial heating system"

  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  parameter EmissionType emissionType = EmissionType.RadiatorsAndFloorHeating
    "Type of the heat emission system";

// Interfaces ////////////////////////////////////////////////////////////////////////////////////////
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[n_C] heatPortConv if
      (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "convective heat transfer from radiators"
    annotation (Placement(transformation(extent={{-62,90},{-42,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[n_C] heatPortRad if
      (emissionType == EmissionType.Radiators or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "radiation heat transfer from radiators"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[n_C] heatPortFH if
      (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating)
    "Port to the core of a floor heating/concrete activation"
    annotation (Placement(transformation(extent={{-96,90},{-76,110}})));
  Modelica.Blocks.Interfaces.RealInput[n_C] TOp
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,96})));
  Modelica.Blocks.Interfaces.RealInput[n_C] TOpAsked
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,96})));
  Modelica.Blocks.Interfaces.RealOutput P "Total active power, consumption > 0"
                                                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={206,-60})));
  Modelica.Blocks.Interfaces.RealOutput Q
    "Total reactive power, consumption > 0"                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={206,-20})));
  outer IDEAS.Climate.SimInfoManager sim
    annotation (Placement(transformation(extent={{-138,64},{-118,84}})));
Modelica.Blocks.Interfaces.RealOutput QHeatTotal
    "Total  thermal power (heating + DHW)"                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={206,60})));
// General parameters for the design (nominal) conditions /////////////////////////////////////////////

  parameter Modelica.SIunits.Power[n_C] QNom(each min=0)
    "Nominal power, can be seen as the max power of the EMISSION system";

// parameters DHW ///////////////////////////////////////////////////////////////////////////////////////
  parameter Integer nOcc = 2
    "number of occupants for determination of DHW consumption";

// Building parameters /////////////////////////////////////////////////////////////////////////////////
  parameter Integer n_C( min = 1)
    "number (n) of conditioned (C) zones for simulation";
  parameter Real[n_C] V_C "conditioned (C) volumes (V) of the zones";
  parameter Modelica.SIunits.HeatCapacity[n_C] C = 1012*1.204*V_C*5
    "Heat capacity of the conditioned zones";

// Other parameters//////////////////////////////////////////////////////////////////////////////////////

// Variables ///////////////////////////////////////////////////////////////////////////////////////////

// General outputs

  annotation(Icon(
      coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},{200,100}}),
                  Bitmap(extent=[-90,90; 90,-90], name="HeatIdeal.tif"),
        graphics={Text(
          extent={{-94,-102},{98,-142}},
          lineColor={0,0,255},
          textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},{
            200,100}}),
              graphics));
end Partial_HeatingSystem;
