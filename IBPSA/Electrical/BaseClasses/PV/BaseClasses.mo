within IBPSA.Electrical.BaseClasses.PV;
package BaseClasses "Package with base classes for IBPSA.Electrical"
  extends Modelica.Icons.BasesPackage;
  package Icons
    partial model partialPVIcon "Partial model for basic PV model icon"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                 Text(extent={{-38,-64},{46,-98}},lineColor={0,0,255},textString= "%name"),
        Rectangle(extent={{-50,90},{50,-68}},lineColor={215,215,215},fillColor={215,215,215},
                fillPattern =                                                                              FillPattern.Solid),
        Rectangle(extent={{-46,28},{-18,0}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-14,28},{14,0}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                    FillPattern.Solid),
        Rectangle(extent={{18,28},{46,0}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                   FillPattern.Solid),
        Rectangle(extent={{-46,-4},{-18,-32}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                       FillPattern.Solid),
        Rectangle(extent={{-14,-4},{14,-32}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
        Rectangle(extent={{18,-4},{46,-32}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-46,-36},{-18,-64}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                        FillPattern.Solid),
        Rectangle(extent={{-14,60},{14,32}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{18,60},{46,32}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                    FillPattern.Solid),
        Rectangle(extent={{-46,60},{-18,32}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
        Rectangle(extent={{-14,-36},{14,-64}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                       FillPattern.Solid),
        Rectangle(extent={{18,-36},{46,-64}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid)}),
          Diagram(coordinateSystem(preserveAspectRatio=false)));
    end partialPVIcon;
  end Icons;

  function lambertWSimple
    "Simple approximation for Lambert W function for x >= 2, should only
be used for large input values as error decreases for increasing input values"

     input Real x(min=2);
     output Real W;

  algorithm
    W:= log(x)*(1-log(log(x))/(log(x)+1));
    annotation (Documentation(info="<html>
<p><span style=\"font-family: Roboto; color: #202124; background-color: #ffffff;\">The Lambert W function solves mathematical equations in which the unknown is both inside and outside of an exponential function or a logarithm.</span></p>
<p>This function is a simple approximation for Lambert W function following Baetzelis, 2016:</p>
</html>",   revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
  end lambertWSimple;

  partial model PartialPVElectrical
    "Partial electrical model for PV module model"

    replaceable parameter IBPSA.Electrical.Data.PV.Generic data constrainedby
      IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
      annotation (choicesAllMatching);
    Modelica.Blocks.Interfaces.RealInput TCel(final unit="K") "Cell temperature"
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
       Rectangle(
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-100,100},{100,-100}}),
          Line(
            points={{-66,-64},{-66,88}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled},
            thickness=0.5),
          Line(
            points={{-66,-64},{64,-64}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled},
            thickness=0.5),
          Text(
            extent={{-72,80},{-102,68}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="I"),
          Text(
            extent={{80,-80},{50,-92}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="U"),
          Line(
            points={{-66,54},{-66,54},{-6,54},{12,50},{22,42},{32,28},{38,8},{
                42,-14},{44,-44},{44,-64}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.Bezier)}),                               Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
    <p>This is a partial model for the electrical surrogate models of a photovoltaic model.</p>
</html>",   revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));

  end PartialPVElectrical;

  partial model PartialPVElectricalSingleDiode
    "Partial electrical model for PV module model following the single diode approach"
    extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical(
        redeclare IBPSA.Electrical.Data.PV.SingleDiodeData data);

    replaceable parameter IBPSA.Electrical.Data.PV.SingleDiodeData data
      constrainedby IBPSA.Electrical.Data.PV.SingleDiodeData
      "PV Panel data definition" annotation (choicesAllMatching);

  // Adjustable parameters

   parameter Integer n_mod "Number of connected PV modules"
      annotation ();

  // Parameters from module data sheet

  protected
  final parameter Modelica.Units.SI.Efficiency eta_0=data.eta_0
    "Efficiency under standard conditions";

   final parameter Real n_ser=data.n_ser
      "Number of cells connected in series on the PV panel";

  final parameter Modelica.Units.SI.Area A_pan=data.A_pan
    "Area of one Panel, must not be confused with area of the whole module";

  final parameter Modelica.Units.SI.Area A_mod=data.A_mod
    "Area of one module (housing)";

  final parameter Modelica.Units.SI.Voltage V_oc0=data.V_oc0
    "Open circuit voltage under standard conditions";

  final parameter Modelica.Units.SI.ElectricCurrent I_sc0=data.I_sc0
    "Short circuit current under standard conditions";

  final parameter Modelica.Units.SI.Voltage V_mp0=data.V_mp0
    "MPP voltage under standard conditions";

  final parameter Modelica.Units.SI.ElectricCurrent I_mp0=data.I_mp0
    "MPP current under standard conditions";

  final parameter Modelica.Units.SI.Power P_Max=data.P_mp0*1.05
    "Maximal power of one PV module under standard conditions. P_MPP with 5 % tolerance. This is used to limit DCOutputPower.";

   final parameter Real TCoeff_Isc(unit = "A/K")=data.TCoeff_Isc
      "Temperature coefficient for short circuit current, >0";

   final parameter Real TCoeff_Voc(unit = "V/K")=data.TCoeff_Voc
      "Temperature coefficient for open circuit voltage, <0";

  final parameter Modelica.Units.SI.LinearTemperatureCoefficient alpha_Isc=data.alpha_Isc
    "Normalized temperature coefficient for short circuit current, >0";

  final parameter Modelica.Units.SI.LinearTemperatureCoefficient beta_Voc=data.beta_Voc
    "Normalized temperature coefficient for open circuit voltage, <0";

  final parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma_Pmp=data.gamma_Pmp
    "Normalized temperature coefficient for power at MPP";

  final parameter Modelica.Units.SI.Temperature TCel0= 25 + 273.15
    "Thermodynamic cell temperature under standard conditions";

    Modelica.Blocks.Interfaces.RealInput absRadRat(final unit="1")
      "Ratio of absorbed radiation under operating conditions to standard conditions"
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
    Modelica.Blocks.Interfaces.RealInput radTil(final unit="W/m2")
      "Total solar irradiance on the tilted surface"
      annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
    Modelica.Blocks.Interfaces.RealOutput P(final unit="W") "DC power output"
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput eta(final unit="1")
      "Efficiency of the PV module under operating conditions"
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
       Rectangle(
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-100,100},{100,-100}}),
          Line(
            points={{-66,-64},{-66,88}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled},
            thickness=0.5),
          Line(
            points={{-66,-64},{64,-64}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled},
            thickness=0.5),
          Text(
            extent={{-72,80},{-102,68}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="I"),
          Text(
            extent={{80,-80},{50,-92}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="U"),
          Line(
            points={{-66,54},{-66,54},{-6,54},{12,50},{22,42},{32,28},{38,8},{
                42,-14},{44,-44},{44,-64}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.Bezier)}),                               Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
        <p>This is a partial model for the electrical surrogate model of a photovoltaic model modeled as a single diode circuit.</p>
</html>",   revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PartialPVElectricalSingleDiode;

  partial model PartialPVElectricalTwoDiodes
    "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
    extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical;
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

    input Modelica.Blocks.Interfaces.RealInput ITot(
      final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2",
      displayUnit="W/m2")
      "Effective total solar irradiation on solar cell"
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
                                                                          iconTransformation(extent={{-120,
              -50},{-100,-30}})));
    output Modelica.Blocks.Interfaces.RealOutput P(
      final quantity="Power",
      final unit="W",
      displayUnit="W")
      "Module power"
      annotation (Placement(transformation(extent={{100,40},{120,60}}),
                                                                      iconTransformation(extent={{100,40},
              {120,60}})));
    output Modelica.Blocks.Interfaces.RealOutput I(unit="A", start = 0.0)
      "Module current"
      annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
                                                                        iconTransformation(extent={{100,-60},
              {120,-40}})));
    Modelica.Units.SI.Voltage Ut "Temperature voltage";
  protected
    final constant Real e(unit = "A.s") = Modelica.Constants.F/Modelica.Constants.N_A
      "Elementary charge";
    final constant Real k(unit = "J/K") = Modelica.Constants.R/Modelica.Constants.N_A
      "Boltzmann constant";
  equation
    Ut =k*TCel/e;

    IPho =(c1 + c2*0.001*TCel)*ITot;

    ISat1 =cs1*TCel*TCel*TCel*Modelica.Math.exp(-(Eg*e)/(k*T));

    ISat2 =cs2*sqrt(TCel*TCel*TCel*TCel*TCel)*Modelica.Math.exp(-(Eg*e)/(2.0*
      k*TCel));

      annotation (
    Documentation(info="<html>
  <p>
  This is a partial 2 diodes electrical model of a PV module.
  </p>
  </html>",   revisions="<html>
  <ul>
  <li>
  October 11, 2022 by Christoph Nytsch-Geusen:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
  end PartialPVElectricalTwoDiodes;

  partial model PartialPVThermal
   "Partial model for computing the cell temperature of a PV moduleConnector 
  for PV record data"
    replaceable parameter IBPSA.Electrical.Data.PV.Generic data constrainedby
      IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
      annotation (choicesAllMatching);
    Modelica.Blocks.Interfaces.RealOutput TCel "Cell temperature"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealInput TDryBul "Ambient temperature (dry bulb)"
      annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
    Modelica.Blocks.Interfaces.RealInput winVel "Wind velocity"
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput HGloTil
      "Total solar irradiance on the tilted surface"
      annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
    Modelica.Blocks.Interfaces.RealInput eta
      "Efficiency of the PV module under operating conditions"
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Text(extent={{-40,-68},{44,-102}},
                                                                lineColor={0,0,255},textString= "%name"),
      Rectangle(extent={{-94,86},{6,-72}}, lineColor={215,215,215},fillColor={215,215,215},
              fillPattern =                                                                              FillPattern.Solid),
      Rectangle(extent={{-90,24},{-62,-4}},
                                          lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-58,24},{-30,-4}},
                                         lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-26,24},{2,-4}},
                                        lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                   FillPattern.Solid),
      Rectangle(extent={{-90,-8},{-62,-36}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-58,-8},{-30,-36}},
                                           lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-26,-8},{2,-36}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-90,-40},{-62,-68}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                        FillPattern.Solid),
      Rectangle(extent={{-58,56},{-30,28}},
                                          lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-26,56},{2,28}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-90,56},{-62,28}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-58,-40},{-30,-68}},
                                            lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-26,-40},{2,-68}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
          Ellipse(
            extent={{46,-90},{86,-52}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{54,48},{78,-60}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{54,48},{54,88},{56,94},{60,96},{66,98},{72,96},{76,94},{78,
                88},{78,48},{54,48}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{54,48},{54,-56}},
            thickness=0.5),
          Line(
            points={{78,48},{78,-56}},
            thickness=0.5),
          Text(
            extent={{92,4},{-28,-26}},
            lineColor={0,0,0},
            textString="T")}),                                     Diagram(
          coordinateSystem(preserveAspectRatio=false)),
              Documentation(info="<html>
        <p>This is a partial model for the thermal surrogate model of a photovoltaic modelt.</p>
</html>",   revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PartialPVThermal;

  partial model PartialPVThermalEmp
    "Empirical thermal models for PV cells to calculate cell temperature"
    extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermal;

    final parameter Modelica.Units.SI.Efficiency eta_0=data.eta_0
      "Efficiency under standard conditions";

    final parameter Modelica.Units.SI.Temperature T_NOCT=data.T_NOCT
      "Cell temperature under NOCT conditions";

    final parameter Real HNOCT(final quantity="Irradiance",
      final unit="W/m2")= 800
      "Irradiance under NOCT conditions";

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Text(extent={{-40,-68},{44,-102}},
                                                                lineColor={0,0,255},textString= "%name"),
      Rectangle(extent={{-94,86},{6,-72}}, lineColor={215,215,215},fillColor={215,215,215},
              fillPattern =                                                                              FillPattern.Solid),
      Rectangle(extent={{-90,24},{-62,-4}},
                                          lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-58,24},{-30,-4}},
                                         lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-26,24},{2,-4}},
                                        lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                   FillPattern.Solid),
      Rectangle(extent={{-90,-8},{-62,-36}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-58,-8},{-30,-36}},
                                           lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-26,-8},{2,-36}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-90,-40},{-62,-68}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                        FillPattern.Solid),
      Rectangle(extent={{-58,56},{-30,28}},
                                          lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-26,56},{2,28}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-90,56},{-62,28}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-58,-40},{-30,-68}},
                                            lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-26,-40},{2,-68}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
          Ellipse(
            extent={{46,-90},{86,-52}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{54,48},{78,-60}},
            lineColor={191,0,0},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{54,48},{54,88},{56,94},{60,96},{66,98},{72,96},{76,94},{78,
                88},{78,48},{54,48}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{54,48},{54,-56}},
            thickness=0.5),
          Line(
            points={{78,48},{78,-56}},
            thickness=0.5),
          Text(
            extent={{92,4},{-28,-26}},
            lineColor={0,0,0},
            textString="T")}),                                     Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
        <p>This is a partial model for the thermal surrogate model of a photovoltaic model based on empirical descriptions.</p>
</html>",   revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PartialPVThermalEmp;

  partial model PartialPVOptical
    Modelica.Blocks.Interfaces.RealInput HGloHor annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}),iconTransformation(
            extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput absRadRat
      "Ratio of absorbed radiation under operating conditions to standard conditions"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Ellipse(
            extent={{-78,76},{-22,24}},
            lineColor={0,0,0},
            fillColor={244,125,35},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{12,-34},{42,22},{96,10},{68,-48},{12,-34}},
            lineColor={0,0,0},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-26,32},{44,-14},{-34,-56}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled})}),                    Diagram(
          coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
        <p>This is a partial model for the optical surrogate model of a photovoltaic model.</p>
</html>",   revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PartialPVOptical;
end BaseClasses;
