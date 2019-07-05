within IBPSA.Utilities.IO.SignalExchange.SignalTypes;
type SignalsForKPIs = enumeration(
    None
      "Not used for KPI",
    AirZoneTemperature
      "Air zone temperature",
    RadiativeZoneTemperature
      "Radiative zone temperature",
    OperativeZoneTemperature
      "Operative zone temperature",
    RelativeHumidity
      "Relative humidity",
    CO2Concentration
      "CO2 Concentration",
    ElectricPower
      "Electric power from grid",
    DistrictHeatingPower
      "Thermal power from district heating",
    GasPower
      "Thermal power from natural gas",
    BiomassPower
      "Thermal power from biomass",
    SolarThermalPower
      "Thermal power from solar thermal",
    FreshWaterFlowRate
      "FreshWaterFlowRate") "Signals used for the calculation of key performance indicators";
