within IBPSA.Electrical.Data.PV;
record Generic "Basic record of a PV cell"
  extends Modelica.Icons.Record;

  parameter Integer nSer "Number of cells connected in series on the PV panel"
    annotation(Dialog(group="General"));
  parameter Integer nPar "Number of parallel cell circuits on the PV panel"
    annotation(Dialog(group="General"));
  parameter Modelica.Units.SI.Area ACel
    "Area of a single cell"
    annotation (Dialog(group="Cell specific: Geometrical data"));
  parameter Modelica.Units.SI.Area APan=ACel*nSer*nPar
    "Area of one Panel, must not be confused with area of the whole module"
    annotation (Dialog(group="Cell specific: Geometrical data"));
  parameter Modelica.Units.SI.Area AMod "Area of one module (housing)"
    annotation (Dialog(group="Cell specific: Geometrical data"));
  parameter Modelica.Units.SI.Temperature TNOCT
    "Cell temperature under NOCT conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Energy Eg0
    "Band gap energy under standard conditions. For Si: 1.79604e-19 J or 1.121 eV";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),Documentation(info="<html>
<p>
This is a base record containing the base information for PV models.
</p>
</html>",
        revisions="<html>
<ul>
<li>
Oct 6, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
