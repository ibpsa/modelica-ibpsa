within IDEAS.HeatingSystems.Interfaces;
partial model Partial_HydraulicHeatingSystem
  "Partial heating system for hydraulic heating systems"

  extends IDEAS.Interfaces.BaseClasses.HeatingSystem;
//  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;
  import IDEAS.Fluid.Production.BaseClasses.HeaterType;
  parameter HeaterType heaterType = heater.heaterType;

  // Interfaces ////////////////////////////////////////////////////////////////////////////////////////
  // see IDEAS.Interfaces.HeatingSystem;
  // General parameters for the design (nominal) conditions /////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TSupNom=273.15 + 45
    "Nominal supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal DT in the heating system";
  final parameter Modelica.SIunits.MassFlowRate[nZones] m_flowNom = QNom/(4.1806*dTSupRetNom)
    "Nominal mass flow rates";
  parameter Modelica.SIunits.Temperature[nZones] TRoomNom={294.15 for i in 1:
      nZones} "Nominal room temperature";

  // parameters DHW ///////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Temperature TDHWSet=273.15 + 45
    "Set temperature for the domestic hot water";
  parameter Modelica.SIunits.Temperature TDHWCold=283.15
    "Fixed temperature for the domestic COLD water";

  // Building parameters /////////////////////////////////////////////////////////////////////////////////
  // Other parameters//////////////////////////////////////////////////////////////////////////////////////
  parameter Modelica.SIunits.Time timeFilter=43200
    "Time constant for the filter of ambient temperature for computation of heating curve";
  parameter Modelica.SIunits.Temperature TInitial=293.15
    "Initial temperature of all state variables";
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar[
     nZones] FHChars if floorHeating constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar;

  // Variables ///////////////////////////////////////////////////////////////////////////////////////////
  Modelica.SIunits.Temperature THeaterSet;

  // General outputs
//  Real COP=heater.COP if (heater.heaterType == IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_AW
//     or heater.heaterType == IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_BW
//     or heater.heaterType == IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_BW_Collective);
//  Real eta=heater.eta if heater.heaterType == IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler;
//  Modelica.SIunits.Power PFuel=if (heater.heaterType == IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler)
//       then heater.PFuel else 0;
//  Modelica.SIunits.Temperature THeaterOut=heater.heatedFluid.T;
//  Modelica.SIunits.Temperature THeaterIn = heater.port_a.h/medium.cp;

  Modelica.SIunits.Temperature TEmissionIn;
  Modelica.SIunits.Temperature[nZones] TEmissionOut;
//  Modelica.SIunits.MassFlowRate m_flowHeater=heater.port_a.m_flow;
  Modelica.SIunits.MassFlowRate[nZones] m_flowEmission;
  Real modulation=heater.heatSource.modulation;
//  Modelica.SIunits.Power QHeaterNet=medium.cp*m_flowHeater*(THeaterOut -
//      THeaterIn);
//  Modelica.SIunits.Power[nZones] QHeaEmiIn=m_flowEmission .* (medium.cp .* (
//      TEmissionIn .- TEmissionOut));

  // not possible since conditional objects can only be used in connections
  //output SI.Power[nZones] QHeaEmiOut = if emissionType == EmissionType.FloorHeating then -heatPortFH.Q_flow else -heatPortConv.Q_flow - heatPortRad.Q_flow;

  replaceable IDEAS.Fluid.Production.Boiler heater(
    QNom=sum(QNom)) constrainedby
    IDEAS.Fluid.Production.Interfaces.PartialDynamicHeaterWithLosses(
    QNom=sum(QNom)) "Heater (boiler, heat pump, ...)"
    annotation (Placement(transformation(extent={{-110,14},{-90,34}})));

  annotation (
    Icon,
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}}), graphics),
    Documentation(revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: minor edits and documentation</li>
<li>2012-2013, Roel De Coninck: many minor and major revisions</li>
<li>2011, Roel De Coninck: first version</li>
</ul></p>
</html>"));
end Partial_HydraulicHeatingSystem;
