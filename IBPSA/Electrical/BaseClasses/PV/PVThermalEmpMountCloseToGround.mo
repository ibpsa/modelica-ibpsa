within IBPSA.Electrical.BaseClasses.PV;
model PVThermalEmpMountCloseToGround
  "Empirical thermal model for PV cell with back close to ground (0 deg < til < 10 deg)"
extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp;

parameter Real a_0(unit = "K.m2/W") = 1.0 "Coefficient a0 for empirical relation";
parameter Real a_1 = 2.98 "Coefficient a1 for empirical relation";
parameter Real a_2(unit = "s/m") = 0.0471 "Coefficient a2 for empirical relation";
parameter Real a_3(unit = "m2/W") = 1.0 "Coefficient a3 for empirical relation";


equation

 TCel = a_0*HGloTil*(exp(-a_1-a_2*winVel))+(TDryBul)+a_3*HGloTil/1000;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model for determining the cell temperature of a PV module mounted on an open rack under operating conditions and under consideration of the wind velocity. </p>
<p>Added parameters a_i to obtain correct units.</p>
<p><br><h4>References</h4></p>
<p>Duffie, John A. and Beckman, W. A. Solar engineering of thermal processes. John Wiley &amp; Sons, Inc. 2013. </p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVThermalEmpMountCloseToGround;
