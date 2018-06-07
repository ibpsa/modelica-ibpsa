within IDEAS.Buildings.Validation.BaseClasses;
model SimInfoManagerBestest "Siminfomanager for BESTEST cases"
  extends IDEAS.BoundaryConditions.SimInfoManager(
    final lat=0.69464104229374,
    final lon=-1.8308503853421,
    final timZonSta=-7*3600,
    filNam="BESTEST.TMY",
    linIntRad=false,
    linExtRad=false,
    Tsky = Te - (23.8 - 0.2025*(Te - 273.15)*(1 - 0.87*Fc)),
    Fc = 0.2,
    Va = 2.5);
  annotation (
    defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.BoundaryConditions.SimInfoManager into your model.",
    Icon(graphics={Text(
          extent={{-98,106},{30,70}},
          lineColor={28,108,200},
          textString="BESTEST")}),
    Documentation(revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
First implementation for 
<a href=\"https://github.com/open-ideas/IDEAS/issues/838\">#838</a>.
</li>
</ul>
</html>"));
end SimInfoManagerBestest;
