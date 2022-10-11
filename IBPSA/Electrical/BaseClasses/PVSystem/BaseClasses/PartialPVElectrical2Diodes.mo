within IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses;
partial model PartialPVElectrical2Diodes
  "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical;
  parameter Integer nCelPar
      "Number of parallel connected cells within the PV module";
  parameter Integer nCelSer
    "Number of serial connected cells within the PV module";
  parameter Real Eg(unit = "eV")
    "Band gap";
  parameter Real c1(unit = "m2/V")
    "1st coefficient IPho";
  parameter Real c2(unit = "m2/(kV.K)")
    "2nd coefficient IPho";
  parameter Real cs1(unit = "A/K3")
    "1st coefficient ISat1";
  parameter Real cs2(unit = "A/K5")
    "2nd coefficient ISat2";
  parameter Real RPar(unit = "V/A")
    "Parallel resistance";
  parameter Real RSer(unit = "V/A")
    "Serial resistance";
  Modelica.Units.SI.ElectricCurrent IPho
    "Photo current";
  Modelica.Units.SI.ElectricCurrent ISat1
    "Saturation current diode 1";
  Modelica.Units.SI.ElectricCurrent ISat2
    "Saturation current diode 2";

  input Modelica.Blocks.Interfaces.RealInput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    displayUnit="degC")
    "Cell temperature"
    annotation (Placement(transformation(extent={{-100,10},{-60,50}}), iconTransformation(extent={{-80,30},{-60,50}})));
  input Modelica.Blocks.Interfaces.RealInput ITot(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2",
    displayUnit="W/m2")
    "Effective total solar irradiation on solar cell"
    annotation (Placement(transformation(extent={{-100,-70},{-60,-30}}),iconTransformation(extent={{-80,-50},{-60,-30}})));
  output Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W",
    displayUnit="W")
    "Module power"
    annotation (Placement(transformation(extent={{60,30},{80,50}}), iconTransformation(extent={{60,30},{80,50}})));
  output Modelica.Blocks.Interfaces.RealOutput I(unit="A", start = 0.0)
    "Module current"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}}), iconTransformation(extent={{60,-50},{80,-30}})));
  Modelica.Units.SI.Voltage Ut "Temperature voltage";
protected
  final constant Real e(unit = "A.s") = Modelica.Constants.F/Modelica.Constants.N_A
    "Elementary charge";
  final constant Real k(unit = "J/K") = Modelica.Constants.R/Modelica.Constants.N_A
    "Boltzmann constant";
equation
  Ut = k * T / e;

  IPho = (c1 + c2 * 0.001 * T) * ITot;

  ISat1 = cs1 * T * T * T * Modelica.Math.exp(-(Eg * e)/(k * T));

  ISat2 = cs2 * sqrt(T * T * T * T * T) * Modelica.Math.exp(-(Eg * e)/(2.0 * k * T));

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
end PartialPVElectrical2Diodes;
