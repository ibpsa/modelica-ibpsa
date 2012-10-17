within IDEAS.Thermal.HeatingSystems;
partial model Partial_HydraulicHeatingSystem
  "Partial heating system for hydraulic heating systems"

  extends IDEAS.Interfaces.HeatingSystem;
  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  import IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType;
  parameter HeaterType heaterType = heater.heaterType;

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

// Interfaces ////////////////////////////////////////////////////////////////////////////////////////
// see IDEAS.Interfaces.HeatingSystem;
// General parameters for the design (nominal) conditions /////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TSupNom=273.15 + 45
    "Nominal supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal DT in the heating system";
  final parameter Modelica.SIunits.MassFlowRate[nZones] m_flowNom=QNom/(
      medium.cp*dTSupRetNom);
  parameter Modelica.SIunits.Temperature[nZones] TRoomNom={294.15 for i in 1:
      nZones} "Nominal room temperature";

// parameters DHW ///////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TDHWSet=273.15 + 45
    "Set temperature for the domestic hot water";
  parameter Modelica.SIunits.Temperature TDHWCold=283.15
    "Fixed temperature for the domestic COLD water";

// Building parameters /////////////////////////////////////////////////////////////////////////////////
// see Partial_HeatingSystem;
// Other parameters//////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Time timeFilter=43200;
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all state variables";
  replaceable parameter IDEAS.Thermal.Components.Emission.FH_Characteristics[
                                                                       nZones] FHChars if
    (emissionType == EmissionType.FloorHeating or emissionType == EmissionType.RadiatorsAndFloorHeating) annotation (choicesAllMatching=true);

// Variables ///////////////////////////////////////////////////////////////////////////////////////////
  Modelica.SIunits.Temperature THeaterSet;

// General outputs
  Real COP = heater.COP if (
    heater.heaterType ==IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_AW or
    heater.heaterType ==IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_BW or
    heater.heaterType ==IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_BW_Collective);
  Real eta = heater.eta if heater.heaterType ==IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.Boiler;
  Modelica.SIunits.Power PFuel=if (heater.heaterType == IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.Boiler)
       then heater.PFuel else 0;
  Modelica.SIunits.Temperature THeaterOut=heater.heatedFluid.T;
  Modelica.SIunits.Temperature THeaterIn=heater.flowPort_a.h/
      medium.cp;
  Modelica.SIunits.Temperature TDHW;
  Modelica.SIunits.Temperature TEmissionIn;
  Modelica.SIunits.Temperature[nZones] TEmissionOut;
  Modelica.SIunits.MassFlowRate m_flowHeater=heater.flowPort_a.m_flow;
  Modelica.SIunits.MassFlowRate[nZones] m_flowEmission;
  Real modulation = heater.heatSource.modulation;
  Modelica.SIunits.Power QHeaterNet=medium.cp*m_flowHeater*(
      THeaterOut - THeaterIn);
  Modelica.SIunits.Power[nZones] QHeaEmiIn=m_flowEmission .* (medium.cp
       .* (TEmissionIn .- TEmissionOut));
  // not possible since conditional objects can only be used in connections
  //output SI.Power[nZones] QHeaEmiOut = if emissionType == EmissionType.FloorHeating then -heatPortFH.Q_flow else -heatPortConv.Q_flow - heatPortRad.Q_flow;

  replaceable IDEAS.Thermal.Components.Production.Boiler
                                                       heater(
    TInitial=TInitial,
    QNom=sum(QNom),
    medium=medium) constrainedby
    IDEAS.Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
    TInitial=TInitial,
    QNom=sum(QNom),
    medium=medium)
    annotation (choicesAllMatching = true, Placement(transformation(extent={{-110,
            -12},{-90,8}})));

  annotation(Icon,
      Diagram(graphics));
end Partial_HydraulicHeatingSystem;
