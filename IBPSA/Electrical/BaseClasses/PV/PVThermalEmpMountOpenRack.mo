within IBPSA.Electrical.BaseClasses.PV;
model PVThermalEmpMountOpenRack
  "Empirical thermal model for PV cell with open rack mounting (tilt >= 10 deg)"
  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp;

 final parameter Modelica.Units.SI.Temperature TDryBul0=293.15
    "Reference ambient temperature";
  final parameter Real coeTranAbs=0.9
    "Module specific coefficient as a product of transmission and absorption. It is usually unknown and set to 0.9 in literature";

equation

 TCel =if noEvent(HGloTil >= Modelica.Constants.eps) then (TDryBul) + (TNOCT -
    TDryBul0)*HGloTil/HNOCT*9.5/(5.7 + 3.8*winVel)*(1 - eta/coeTranAbs) else (
    TDryBul);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Model for determining the cell temperature of a PV module mounted on
  an open rack under operating conditions and under consideration of
  the wind velocity.
</p>
<p>
  <br/>
</p>
<h4>
  <span style=\"color: #008000\">References</span>
</h4>
<p>
  <q>Solar engineering of thermal processes.</q> by Duffie, John A. ;
  Beckman, W. A.
</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVThermalEmpMountOpenRack;
