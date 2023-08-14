within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVElectricalTwoDiodes
  "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical(
      redeclare IBPSA.Electrical.Data.PV.TwoDiodesData data);

  replaceable parameter IBPSA.Electrical.Data.PV.TwoDiodesData data
    constrainedby IBPSA.Electrical.Data.PV.TwoDiodesData
    "PV Panel data definition" annotation (choicesAllMatching);

  // Parameters from module data sheet

  final parameter Real c1(
    unit = "m2/V") = data.c1
    "1st coefficient IPho";

  final parameter Real c2(
    unit = "m2/(kV.K)") = data.c2
    "2nd coefficient IPho";

  final parameter Real cs1(
    unit = "A/K3") = data.cs1
    "1st coefficient ISat1";

  final parameter Real cs2(
    unit = "A/K5") = data.cs2
    "2nd coefficient ISat2";

  final parameter Real R_sh(
    unit = "V/A") = data.R_sh
    "Parallel resistance";

  final parameter Real R_s(
    unit = "V/A") = data.R_s
    "Serial resistance";

  Modelica.Units.SI.ElectricCurrent I_s1
    "Saturation current diode 1";

  Modelica.Units.SI.ElectricCurrent I_s2
    "Saturation current diode 2";

  Modelica.Units.SI.Voltage Ut
    "Temperature voltage";

  output Modelica.Blocks.Interfaces.RealOutput I(
    unit="A", start = 0.0)
    "Module current"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
      iconTransformation(extent={{100,-60},{120,-40}})));

equation
  Ut =k*TCel/e;

  I_ph =(c1 + c2*0.001*TCel)*HGloTil;

  I_s1 =cs1*TCel*TCel*TCel*Modelica.Math.exp(-(Eg0*e)/(k*TCel));

  I_s2 =cs2*sqrt(TCel*TCel*TCel*TCel*TCel)*Modelica.Math.exp(-(Eg0*e)/(2.0*k*TCel));

  eta=if noEvent(HGloTil <= Modelica.Constants.eps*10) then 0 else P/(HGloTil*
    A_mod*n_mod);
    annotation (
  Documentation(info="<html>
  <p>
  This is a partial 2 diodes electrical model of a PV module.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  October 11, 2022 by Christoph Nytsch-Geusen:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end PartialPVElectricalTwoDiodes;
