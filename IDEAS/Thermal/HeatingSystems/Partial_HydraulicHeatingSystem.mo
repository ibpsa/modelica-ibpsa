within IDEAS.Thermal.HeatingSystems;
partial model Partial_HydraulicHeatingSystem
  "Partial heating system for hydraulic heating systems"
  extends Partial_HeatingSystem;

  import IDEAS.Thermal.Components.HeatEmission.Auxiliaries.EmissionType;
  import IDEAS.Thermal.Components.HeatProduction.Auxiliaries.HeaterType;
  parameter HeaterType heaterType = heater.heaterType;

  parameter TME.FHF.Interfaces.Medium
                                 medium = TME.FHF.Media.Water();

// Interfaces ////////////////////////////////////////////////////////////////////////////////////////
// see Partial_HeatingSystem;
// General parameters for the design (nominal) conditions /////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TSupNom=273.15 + 45
    "Nominal supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal DT in the heating system";
  final parameter Modelica.SIunits.MassFlowRate[n_C] m_flowNom=QNom/(medium.cp*
      dTSupRetNom);
  parameter Modelica.SIunits.Temperature[n_C] TRoomNom={294.15 for i in 1:n_C}
    "Nominal room temperature";

// parameters DHW ///////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TDHWSet=273.15 + 45
    "Set temperature for the domestic hot water";
  parameter Modelica.SIunits.Temperature TDHWCold=283.15
    "Fixed temperature for the domestic COLD water";

// Building parameters /////////////////////////////////////////////////////////////////////////////////
// see Partial_HeatingSystem;
// Other parameters//////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Time timeFilter=86400;
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all state variables";
  replaceable parameter
    IDEAS.Thermal.Components.HeatEmission.FH_Characteristics[              n_C] FHChars if
    (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating) annotation (choicesAllMatching=true);

// Variables ///////////////////////////////////////////////////////////////////////////////////////////
  Modelica.SIunits.Temperature THeaterSet;

// General outputs
  output Real COP = heater.COP if (
    heater.heaterType ==IDEAS.Thermal.Components.HeatProduction.Auxiliaries.HeaterType.HP_AW
                                                                                        or
    heater.heaterType ==IDEAS.Thermal.Components.HeatProduction.Auxiliaries.HeaterType.HP_BW
                                                                                        or
    heater.heaterType ==IDEAS.Thermal.Components.HeatProduction.Auxiliaries.HeaterType.HP_BW_Collective);
  output Real eta = heater.eta if heater.heaterType ==IDEAS.Thermal.Components.HeatProduction.Auxiliaries.HeaterType.Boiler;
  output Modelica.SIunits.Power PFuel=if (heater.heaterType == IDEAS.Thermal.Components.HeatProduction.Auxiliaries.HeaterType.Boiler)
       then heater.PFuel else 0;
  output Modelica.SIunits.Temperature THeaterOut=heater.heatedFluid.T;
  output Modelica.SIunits.Temperature THeaterIn=heater.flowPort_a.h/medium.cp;
  output Modelica.SIunits.Temperature TDHW;
  output Modelica.SIunits.Temperature TEmissionIn;
  output Modelica.SIunits.Temperature[n_C] TEmissionOut;
  output Modelica.SIunits.MassFlowRate m_flowHeater=heater.flowPort_a.m_flow;
  output Modelica.SIunits.MassFlowRate[n_C] m_flowEmission;
  output Real modulation = heater.heatSource.modulation;
  output Modelica.SIunits.Power QHeaterNet=medium.cp*m_flowHeater*(THeaterOut
       - THeaterIn);
  output Modelica.SIunits.Power[n_C] QHeaEmiIn=m_flowEmission .* (medium.cp .*
      (TEmissionIn .- TEmissionOut));
  // not possible since conditional objects can only be used in connections
  //output SI.Power[n_C] QHeaEmiOut = if emissionType == EmissionType.FloorHeating then -heatPortFH.Q_flow else -heatPortConv.Q_flow - heatPortRad.Q_flow;

  replaceable IDEAS.Thermal.Components.HeatProduction.Boiler
                                                       heater(
    TInitial=TInitial,
    QNom=sum(QNom),
    medium=medium) constrainedby
    IDEAS.Thermal.Components.HeatProduction.Auxiliaries.PartialDynamicHeaterWithLosses(
    TInitial=TInitial,
    QNom=sum(QNom),
    medium=medium)
    annotation (choicesAllMatching = true, Placement(transformation(extent={{-92,-12},
            {-72,8}})));

  annotation(Icon(Bitmap(extent=[-90,90; 90,-90], name="HeatIdeal.tif")),
      Diagram(graphics));
end Partial_HydraulicHeatingSystem;
