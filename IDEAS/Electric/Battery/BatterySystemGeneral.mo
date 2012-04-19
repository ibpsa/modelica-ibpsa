within IDEAS.Electric.Battery;
model BatterySystemGeneral
replaceable parameter IDEAS.Electric.Data.Interfaces.BatteryType
                                                               technology
    "Choose a battery type"                                       annotation(choicesAllMatching = true);

parameter Integer numPha=1 "Number of phases: 1 or 3";

// Individual parameters
parameter Modelica.SIunits.Conversions.NonSIunits.Energy_kWh EBat=1
    "Total battery capacity in [kW.h]";
parameter Modelica.SIunits.Efficiency SoC_start=0.2
    "How full is the battery at the start? [%/100]";
parameter Modelica.SIunits.Efficiency DOD_max=0.80 "Maximum discharge [%/100]";

// Variables
Modelica.SIunits.Power Pnet;

// Models
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin[numPha] annotation (Placement(transformation(extent={{-106,
            -10},{-86,10}},                                                                               rotation=0)));

  IDEAS.Electric.Battery.BatteryCtrlGeneral
                      batteryCtrlGeneral(numPha = numPha,
  DOD_max = DOD_max,
  EBat = EBat,
  eta_out = technology.eta_out,
  eta_in = technology.eta_in,
  eta_c = technology.eta_c,
  eta_d = technology.eta_d,
  e_c = technology.e_c,
  e_d = technology.e_d,
  P = Pnet)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  IDEAS.Electric.BaseClasses.WattsLaw wattsLaw(numPha=numPha)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,30})));

  IDEAS.Electric.Battery.Battery
             battery(delta_sd = technology.delta_sd,
  SoC_start = SoC_start,
  EBat = EBat,
  eta_out = technology.eta_out,
  eta_in = technology.eta_in,
  eta_c = technology.eta_c,
  eta_d = technology.eta_d)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

equation
  connect(wattsLaw.vi, pin)       annotation (Line(
      points={{-20,30},{-14,30},{-14,0},{-96,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(batteryCtrlGeneral.PFinal, wattsLaw.P)       annotation (Line(
      points={{20,13},{10,20},{0,20},{0,46},{-48,46},{-48,34},{-40,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(batteryCtrlGeneral.QFinal, wattsLaw.Q)       annotation (Line(
      points={{20,7},{10,0},{0,0},{0,10},{-48,10},{-48,28},{-40,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(batteryCtrlGeneral.PInit, battery.PIn) annotation (Line(
      points={{40,13},{60,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(battery.SoC_out, batteryCtrlGeneral.SoC) annotation (Line(
      points={{60,7},{40,7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(Bitmap(extent=[-90,90; 90,-90], name="Battery.png")), Diagram(
        graphics));
end BatterySystemGeneral;
