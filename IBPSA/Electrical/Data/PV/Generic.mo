within IBPSA.Electrical.Data.PV;
record Generic "Basic record of a PV cell"
  extends Modelica.Icons.Record;

  parameter Integer n_ser
    "Number of cells connected in series on the PV panel"
    annotation(Dialog(group="General"));
  parameter Integer n_par
    "Number of parallel cell circuits on the PV panel"
    annotation(Dialog(group="General"));
  parameter Modelica.Units.SI.Area A_cel
    "Area of a single cell. If not found in data sheet, use A_cel = ((V_mp0*I_mp0)/(1000*eta_0))/n_ser"
    annotation (Dialog(group="Cell specific: Geometrical data"));
  parameter Modelica.Units.SI.Area A_pan=A_cel*n_ser*n_par
    "Area of one Panel, must not be confused with area of the whole module"
    annotation (Dialog(group="Cell specific: Geometrical data"));
  parameter Modelica.Units.SI.Area A_mod "Area of one module (housing)"
    annotation (Dialog(group="Cell specific: Geometrical data"));
  parameter Modelica.Units.SI.Temperature T_NOCT
    "Cell temperature under NOCT conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Real Eg0(unit = "eV")
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
