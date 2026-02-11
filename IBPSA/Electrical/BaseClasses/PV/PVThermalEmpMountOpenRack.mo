within IBPSA.Electrical.BaseClasses.PV;
model PVThermalEmpMountOpenRack
  "Empirical thermal model for PV cell with open rack mounting (tilt >= 10 deg)"
  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp;

  final parameter Modelica.Units.SI.Temperature TDryBul0=293.15
    "Reference ambient temperature";
  final parameter Real coeTranAbs=0.9
    "Module specific coefficient as a product of transmission and absorption. It is usually unknown and set to 0.9 in literature";

  parameter Real a_0(unit = "s/m") = 3.8 "Coefficient a0 for empirical relation";

equation
  TCel = TDryBul + (TNOCT - TDryBul0)*HGloTil/HNOCT*9.5/(5.7 + a_0*winVel)*
        (1 - eta/coeTranAbs);

annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Model for determining the cell temperature of a PV module mounted on an open rack
under operating conditions and under consideration of the wind velocity.
</p>
<p>
Added parameters a_i to obtain correct units.
</p>
<h4>References</h4>
<p>
Duffie, John A. and Beckman, W. A. Solar engineering of thermal processes.
John Wiley &amp; Sons, Inc. 2013.
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
