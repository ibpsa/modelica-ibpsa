within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVElectricalTwoDiodes
  "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical(
      redeclare IBPSA.Electrical.Data.PV.TwoDiodesData data);

  replaceable parameter IBPSA.Electrical.Data.PV.TwoDiodesData data
    constrainedby IBPSA.Electrical.Data.PV.TwoDiodesData
    "PV Panel data definition" annotation (choicesAllMatching);

  // Parameters from module data sheet
  final parameter Modelica.Units.SI.Area A_mod=data.A_mod
    "Area of one module (housing)";
  final parameter Integer n_par = data.n_par
    "Number of parallel connected cells within the PV module";
  final parameter Integer n_ser = data.n_ser
    "Number of serial connected cells within the PV module";
  final parameter Real Eg(
    unit = "eV") = data.Eg
    "Band gap";
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
  final parameter Real RPar(
    unit = "V/A") = data.RPar
    "Parallel resistance";
  final parameter Real RSer(
    unit = "V/A") = data.RSer
    "Serial resistance";
  Modelica.Units.SI.ElectricCurrent IPho
    "Photo current";
  Modelica.Units.SI.ElectricCurrent ISat1
    "Saturation current diode 1";
  Modelica.Units.SI.ElectricCurrent ISat2
    "Saturation current diode 2";

  output Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W",
    displayUnit="W")
    "Module power"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
      iconTransformation(extent={{100,40},{120,60}})));
  output Modelica.Blocks.Interfaces.RealOutput I(
    unit="A", start = 0.0)
    "Module current"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
      iconTransformation(extent={{100,-60},{120,-40}})));
  Modelica.Units.SI.Voltage Ut
    "Temperature voltage";

  Modelica.Blocks.Interfaces.RealOutput eta(final unit="1")
    "Efficiency of the PV module under operating conditions"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  Modelica.Blocks.Interfaces.RealInput absRadRat(
    final unit="1")
    "Ratio of absorbed radiation under operating conditions to standard conditions"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput radTil(
    final unit="W/m2")
    "Total solar irradiance on the tilted surface"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
protected
  final constant Real e(unit = "A.s") = Modelica.Constants.F/Modelica.Constants.N_A
    "Elementary charge";
  final constant Real k(unit = "J/K") = Modelica.Constants.R/Modelica.Constants.N_A
    "Boltzmann constant";
equation
  Ut =k*TCel/e;

  IPho =(c1 + c2*0.001*TCel)*radTil;

  ISat1 =cs1*TCel*TCel*TCel*Modelica.Math.exp(-(Eg*e)/(k*TCel));

  ISat2 =cs2*sqrt(TCel*TCel*TCel*TCel*TCel)*Modelica.Math.exp(-(Eg*e)/(2.0*k*TCel));

  eta= if noEvent(radTil <= Modelica.Constants.eps*10) then 0 else P/(radTil*A_mod);

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
