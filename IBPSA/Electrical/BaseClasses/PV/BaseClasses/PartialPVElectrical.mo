within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVElectrical
  "Partial electrical model for PV module model"

  replaceable parameter Data.PV.Generic dat constrainedby
    IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
    annotation (choicesAllMatching);

    // Adjustable parameters

  parameter Integer nMod "Number of connected PV modules";

  final parameter Modelica.Units.SI.Area AMod=dat.AMod
    "Area of one module (housing)";

  final parameter Integer nSer=dat.nSer
    "Number of cells connected in series on the PV panel";

  final parameter Integer nPar=dat.nPar
    "Number of parallel connected cells within the PV module";

  final parameter Modelica.Units.SI.Energy Eg0 = dat.Eg0
    "Band gap energy under standard conditions";

  Modelica.Units.SI.ElectricCurrent IPh "Photo current";
  Modelica.Blocks.Interfaces.RealInput TCel(final unit="K",final displayUnit="degC")
    "Cell temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

public
  Modelica.Blocks.Interfaces.RealInput absRadRat(final unit="1")
    "Ratio of absorbed radiation under operating conditions to standard conditions"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput HGloTil(final unit="W/m2")
    "Total solar irradiance on the tilted surface"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput eta(final unit="1")
    "Efficiency of the PV module under operating conditions"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
    "DC power output"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

protected
  final constant Real e(unit = "C") = Modelica.Constants.F/Modelica.Constants.N_A
    "Elementary charge";
  final constant Real k(unit = "J/K") = Modelica.Constants.R/Modelica.Constants.N_A
    "Boltzmann constant";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {100,100}}),
   graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
    <p>
    This is a partial model for the electrical surrogate models of a photovoltaic module.
    </p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPVElectrical;
