within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVElectricalSingleDiode
  "Partial electrical model for PV module model following the single diode approach"
  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical(
      redeclare IBPSA.Electrical.Data.PV.SingleDiodeData dat);

  replaceable parameter Data.PV.SingleDiodeData dat
    constrainedby IBPSA.Electrical.Data.PV.SingleDiodeData
    "PV Panel data definition" annotation (choicesAllMatching);

// Parameters from module data sheet

protected
  final parameter Modelica.Units.SI.Efficiency eta0=dat.eta0
    "Efficiency under standard conditions";

  final parameter Modelica.Units.SI.Area APan=dat.APan
    "Area of one Panel, must not be confused with area of the whole module";

  final parameter Modelica.Units.SI.Voltage VOC0=dat.VOC0
    "Open circuit voltage under standard conditions";

  final parameter Modelica.Units.SI.ElectricCurrent ISC0=dat.ISC0
    "Short circuit current under standard conditions";

  final parameter Modelica.Units.SI.Voltage VMP0=dat.VMP0
    "MPP voltage under standard conditions";

  final parameter Modelica.Units.SI.ElectricCurrent IMP0=dat.IMP0
    "MPP current under standard conditions";

  final parameter Modelica.Units.SI.Power PMax=dat.PMP0*1.05
    "Maximal power of one PV module under standard conditions. P_MPP with 5 perc tolerance. This is used to limit DCOutputPower.";

  final parameter Real TCoeISC(unit="A/K") = dat.TCoeISC
    "Temperature coefficient for short circuit current, >0";

  final parameter Real TCoeVOC(unit="V/K") = dat.TCoeVOC
    "Temperature coefficient for open circuit voltage, <0";

  final parameter Modelica.Units.SI.LinearTemperatureCoefficient alphaISC=dat.alphaISC
    "Normalized temperature coefficient for short circuit current, >0";

  final parameter Modelica.Units.SI.LinearTemperatureCoefficient betaVOC=dat.betaVOC
    "Normalized temperature coefficient for open circuit voltage, <0";

  final parameter Modelica.Units.SI.LinearTemperatureCoefficient gammaPMP=dat.gammaPMP
    "Normalized temperature coefficient for power at MPP";

  final parameter Modelica.Units.SI.Temperature TCel0 = 25.0 + 273.15
    "Thermodynamic cell temperature under standard conditions";
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
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="I"),
        Text(
          extent={{80,-80},{50,-92}},
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
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPVElectricalSingleDiode;
