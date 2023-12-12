within IBPSA.Electrical.BaseClasses.PV;
model PVThermalEmpMountContactToGround
  "Empirical thermal model for PV cell with back in contact with ground"
extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp;

equation

 TCel = HGloTil*(exp(-2.81-0.0455*winVel))+TDryBul;


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
<h4>References</h4>
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
end PVThermalEmpMountContactToGround;
