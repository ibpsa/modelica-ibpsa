within IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection;
partial record HeatPumpSafetyControlBaseDataDefinition "Base data definition for heat pump safety models"
  extends Modelica.Icons.Record;
  parameter Boolean use_minRunTime
    "False if minimal runtime of HP is not considered"
  annotation (Dialog(group="HP-Security: OnOffControl"), choices(checkBox=true));
  parameter Modelica.Units.SI.Time minRunTime
    "Mimimum runtime of heat pump" annotation (Dialog(group=
          "HP-Security: OnOffControl", enable=use_minRunTime));
  parameter Boolean use_minLocTime
    "False if minimal locktime of HP is not considered"
    annotation (Dialog(group="HP-Security: OnOffControl"), choices(checkBox=true));
  parameter Modelica.Units.SI.Time minLocTime
    "Minimum lock time of heat pump" annotation (Dialog(group=
          "HP-Security: OnOffControl", enable=use_minLocTime));
  parameter Boolean use_runPerHou
    "False if maximal runs per hour HP are not considered"
    annotation (Dialog(group="HP-Security: OnOffControl"), choices(checkBox=true));
  parameter Integer maxRunPerHou   "Maximal number of on/off cycles in one hour. Source: German law"
    annotation (Dialog(group="HP-Security: OnOffControl", enable=use_runPerHou));
  parameter Boolean use_opeEnv
    "Use a the operational envelope"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv),choices(checkBox=true));
  parameter Boolean use_opeEnvFroRec
    "Use a the operational envelope given in the datasheet"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv),choices(checkBox=true));
  parameter
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition
    dataTable "Data Table of HP" annotation (Dialog(group=
          "Operational Envelope", enable=use_opeEnv and use_opeEnvFroRec),
      choicesAllMatching=true);
  parameter Real tableUpp[:,2] "Upper boundary of envelope"
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv and not use_opeEnvFroRec));
  parameter Modelica.Units.SI.TemperatureDifference dTHystOperEnv=5
    "Temperature difference used for both upper and lower hysteresis in the operational envelope."
    annotation (Dialog(group="Operational Envelope", enable=use_opeEnv));
  parameter Boolean pre_n_start=true "Start value of pre(n) at initial time"
    annotation (Dialog(group="OnOffControl", descriptionLabel=true),choices(checkBox=true));

  parameter Boolean use_deFro
    "True if defrost control should be enabled(only air-source HPs)"
    annotation (Dialog(group="Defrost"), choices(checkBox=true));
  parameter Real minIceFac "Minimal value above which no defrost is necessary"
    annotation (Dialog(group="Defrost", enable=use_deFro));
  parameter Real deltaIceFac = 0.1 "Bandwitdth for hystereses. If the icing factor is based on the duration of defrost, this value is necessary to avoid state-events." annotation (Dialog(group="Defrost", enable=use_deFro));
  parameter Boolean use_chiller=true
    "True if defrost operates by changing mode to cooling. False to use an electrical heater"
    annotation (Dialog(group="Defrost", enable=use_deFro),
                                        choices(checkBox=true));
  parameter Modelica.Units.SI.Power calcPel_deFro
    "Calculate how much eletrical energy is used to melt ice"
    annotation (Dialog(enable=not use_chiller and use_deFro, group="Defrost"));
  parameter Boolean use_antFre
    "True if anti freeze control is part of safety control"
    annotation (Dialog(group="Anti Freeze Control"), choices(checkBox=true));
  parameter Modelica.Units.SI.ThermodynamicTemperature TantFre
    "Limit temperature for anti freeze control"
    annotation (Dialog(group="Anti Freeze Control", enable=use_antFre));

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpSafetyControlBaseDataDefinition;
