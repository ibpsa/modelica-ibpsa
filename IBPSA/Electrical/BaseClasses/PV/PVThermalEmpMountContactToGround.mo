within IBPSA.Electrical.BaseClasses.PV;
model PVThermalEmpMountContactToGround
  "Empirical thermal model for PV cell with back in contact with ground"
extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp;

parameter Real a_0(unit = "K.m2/W") = 1.0 "Coefficient a0 for empirical relation";

equation

 TCel = a_0*HGloTil*(exp(-2.81-0.0455*winVel))+TDryBul;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model for determining the cell temperature of a PV module mounted on an open rack under operating conditions and under consideration of the wind velocity. </p>
<p>Added parameters a_i to obtain correct units. </p>
<br><h4>References</h4>
<p>Duffie, John A. and Beckman, W. A. Solar engineering of thermal processes. John Wiley &amp; Sons, Inc. 2013. </p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVThermalEmpMountContactToGround;
