within IDEAS.LIDEAS.Components;
model LinRectangularZoneTemplate
  extends IDEAS.Buildings.Components.RectangularZoneTemplate(
      redeclare IDEAS.Buildings.Components.ZoneAirModels.WellMixedAir
      airModel(vol(T(stateSelect=StateSelect.prefer))),
      redeclare IDEAS.Buildings.Components.InterzonalAirFlow.n50FixedPressure interzonalAirFlow,
    redeclare LinWindow winA(indexWindow=indexWindowA),
    redeclare LinWindow winCei(indexWindow=indexWindowCei),
    redeclare LinWindow winB(indexWindow=indexWindowB),
    redeclare LinWindow winC(indexWindow=indexWindowC),
    redeclare LinWindow winD(indexWindow=indexWindowD));
  parameter Boolean linearise=sim.linearise annotation(Dialog(tab="Linearization"));
  parameter Integer indexWindowA if hasWinA "Index of this window A" annotation(Dialog(tab="Linearization",enable=hasWinA));
  parameter Integer indexWindowB if hasWinB "Index of this window B" annotation(Dialog(tab="Linearization",enable=hasWinB));
  parameter Integer indexWindowC if hasWinC "Index of this window C" annotation(Dialog(tab="Linearization",enable=hasWinC));
  parameter Integer indexWindowD if hasWinD "Index of this window D" annotation(Dialog(tab="Linearization",enable=hasWinD));
  parameter Integer indexWindowCei if hasWinCei "Index of this window Cei" annotation(Dialog(tab="Linearization",enable=hasWinCei));
equation
  assert(Medium.nX ==1, "LinZone model does not allow moist air or air with CO2 medium. Use the IDEAS.Media.Specialized.DryAir medium.");
  annotation (Documentation(info="<html>
<p>
Extension of <code>IDEAS.Buildings.Components.RectangularZoneTemplate</code> to make linearization of the zone possible.
The model is therefore pre-configured to used the well-mixed air model with the temperature as preferred state of the
mixing volume and using <code>Buildings.Components.InterzonalAirFlow.n50FixedPressure</code> for the infiltration.
</p>
<p>
An assert statement is added to ensure that the user only use the <code>IDEAS.Media.Specialized.DryAir</code> model as
the linearization does not work with other type of Media.
</p>

</html>", revisions="<html>
<ul>
<li>August 21, 2018 by Damien Picard: <br/>Remove custom air model and use 
<code>IDEAS.Buildings.Components.ZoneAirModels.WellMixedAir</code> with correct
parametrization instead.</li>
</ul>
</html>"));
end LinRectangularZoneTemplate;
