within IDEAS.Buildings.Validation.Data.Constructions;
record LightFloor "BESTEST Light floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=2,
    incLastLay = IDEAS.Types.Tilt.Floor,
    final mats={
      insulationType,
      IDEAS.Buildings.Validation.Data.Materials.TimberFlooring(d=0.025)});

  annotation (Documentation(revisions="<html>
<ul>
<li>
July 19, 2016, Filip Jorissen:<br/>
Corrected wrong value in implementation.
</li>
</ul>
</html>"));
end LightFloor;
