within IDEAS.Electric.Batteries;
model BatterySystemGeneral
  extends BatterySystem;

  // Variables
  Modelica.SIunits.Power Pnet;

  // Models
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin[
    numPha] annotation (Placement(transformation(extent={{-106,-10},{-86,10}},
          rotation=0)));

  IDEAS.Electric.Batteries.BatteryCtrlGeneral batteryCtrlGeneral(
    numPha=numPha,
    DOD_max=DOD_max,
    EBat=EBat,
    eta_out=technology.eta_out,
    eta_in=technology.eta_in,
    eta_c=technology.eta_c,
    eta_d=technology.eta_d,
    e_c=technology.e_c,
    e_d=technology.e_d,
    P=Pnet) annotation (Placement(transformation(extent={{20,0},{40,20}})));

equation
  connect(wattsLaw.vi, pin) annotation (Line(
      points={{-20,30},{-14,30},{-14,0},{-96,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(batteryCtrlGeneral.PFinal, wattsLaw.P) annotation (Line(
      points={{20,13},{10,20},{0,20},{0,46},{-48,46},{-48,34},{-40,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(batteryCtrlGeneral.QFinal, wattsLaw.Q) annotation (Line(
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
end BatterySystemGeneral;
