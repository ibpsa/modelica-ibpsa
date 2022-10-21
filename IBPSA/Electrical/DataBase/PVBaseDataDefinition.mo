within IBPSA.Electrical.DataBase;
record PVBaseDataDefinition "Basic record of a PV module"
 extends Modelica.Icons.Record;

parameter Modelica.Units.SI.Efficiency eta_0
  "Efficiency under standard conditions. 
  If not found in data sheet, use eta_0 = ((V_mp0*I_mp0)/(1000*A_cel*n_ser))"
  annotation (Dialog(group="General"));
 parameter Real n_ser
    "Number of cells connected in series on the PV panel"
    annotation(Dialog(group="General"));
 parameter Real n_par
    "Number of parallel cell circuits on the PV panel"
    annotation(Dialog(group="General"));
parameter Modelica.Units.SI.Area A_cel
  "Area of a single cell. 
  If not found in data sheet, use A_cel = ((V_mp0*I_mp0)/(1000*eta_0))/n_ser"
  annotation (Dialog(group="Cell specific: Geometrical data"));
parameter Modelica.Units.SI.Area A_pan=A_cel*n_ser*n_par
  "Area of one Panel, must not be confused with area of the whole module"
  annotation (Dialog(group="Cell specific: Geometrical data"));
parameter Modelica.Units.SI.Area A_mod "Area of one module (housing)"
  annotation (Dialog(group="Cell specific: Geometrical data"));
parameter Modelica.Units.SI.Temperature T_NOCT
  "Cell temperature under NOCT conditions"
  annotation (Dialog(group="Cell specific: Electrical characteristics"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end PVBaseDataDefinition;
