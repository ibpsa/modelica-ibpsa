within IBPSA.Electrical.BaseClasses.PV;
model PVThermalEmpMountCloseToGround
  "Empirical thermal model for PV cell with back close to ground ~(0 deg < til < 10 deg)"
extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp;

equation

 TCel = if noEvent(HGloTil >= Modelica.Constants.eps) then
 HGloTil*(exp(-2.98-0.0471*winVel))+(TDryBul)+HGloTil/1000*1
 else
 (TDryBul);

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
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVThermalEmpMountCloseToGround;
