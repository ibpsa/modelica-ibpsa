within IDEAS.Buildings.Validation.BaseClasses.VentilationSystem;
model None "None"
  extends IDEAS.Templates.Ventilation.Ideal(
    final m_flow = zeros(nZones),
    final nLoads=1);
  annotation (Documentation(revisions="<html>
<ul>
<li>
June 5, 2018 by Filip Jorissen:<br/>
Cleaned up implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
</ul>
</html>"));
end None;
