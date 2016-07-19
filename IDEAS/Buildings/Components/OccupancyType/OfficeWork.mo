within IDEAS.Buildings.Components.OccupancyType;
record OfficeWork
  "Properties for typical office work. Based on Fanger and Ashrae Fundamentals"
  extends PartialOccupancyType(
    QlatPp=45,
    QsenPp=73,
    radFra=0.6,
    ICl=0.7);
  annotation (Documentation(revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
See documentation in IDEAS.Buildings.Components.OccupancyType.PartialOccupancyType.
</p>
</html>"));
end OfficeWork;
