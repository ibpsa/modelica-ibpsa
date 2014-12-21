within IDEAS.Electric.Batteries;
partial model BatterySystem
  // Will be further 'extended' for a battery storage system and EV
  replaceable parameter IDEAS.Electric.Data.Interfaces.BatteryType technology
    "Choose a battery type" annotation (choicesAllMatching=true);

  parameter Integer numPha=1 "Number of phases simulated" annotation (choices(
      choice=1 "Single Phase",
      choice=3 "Three Phase",
      __Dymola_radioButtons=true));

  // Individual parameters
  parameter Modelica.SIunits.Conversions.NonSIunits.Energy_kWh EBat=1
    "Total battery capacity in [kW.h]";
  parameter Modelica.SIunits.Efficiency SoC_start=0.2
    "How full is the battery at the start? [%/100]";
  parameter Modelica.SIunits.Efficiency DOD_max=0.80
    "Maximum discharge [%/100]";

  IDEAS.Electric.BaseClasses.WattsLaw wattsLaw(numPha=numPha) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,30})));

  IDEAS.Electric.Batteries.Battery battery(
    delta_sd=technology.delta_sd,
    SoC_start=SoC_start,
    EBat=EBat,
    eta_out=technology.eta_out,
    eta_in=technology.eta_in,
    eta_c=technology.eta_c,
    eta_d=technology.eta_d)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  annotation (Icon, Diagram(graphics));
end BatterySystem;
