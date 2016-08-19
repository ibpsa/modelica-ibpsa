within IDEAS.Buildings.Components.Interfaces;
expandable connector WindowBus
  "Bus containing inputs/outputs for linear window model"
  extends Modelica.Icons.SignalBus;
  parameter Integer nLay = 3 "Number of window layers";

  Real[nLay] AbsQFlow(start=fill(100,nLay)) annotation ();
  Real iSolDir(start=100) annotation ();
  Real iSolDif(start=100) annotation ();

  annotation (Documentation(revisions="<html>
<ul>
<li>
March, 2015 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"));
end WindowBus;
