within IDEAS.Examples.TwinHouses.BaseClasses;
model ClosedBlinds "ClosedBlinds"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
                                                             final controlled=false);
parameter Real shaCorr=0.24 "Shortwave transmittance of shortwave radiation";
equation
iSolDir = 0;
  iSolDif =  solDif*shaCorr + solDir*shaCorr;

  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-16,-50},{-16,-50},{40,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
Cleaned up implementation and documentation.
</li>
</ul>
</html>", info="<html>
<p>Use this model if you want no solar shading to be computed.</p>
</html>"));
end ClosedBlinds;
