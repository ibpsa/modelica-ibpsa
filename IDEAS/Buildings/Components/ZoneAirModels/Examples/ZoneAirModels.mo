within IDEAS.Buildings.Components.ZoneAirModels.Examples;
model ZoneAirModels
  extends Modelica.Icons.Example;
  Validation.BaseClasses.Structure.Bui900 wellMixedAir
    "Bestest case 900 with default well mixed air model"
    annotation (Placement(transformation(extent={{-14,60},{16,80}})));
  Validation.BaseClasses.Structure.Bui900 thermal(gF(redeclare Thermal airModel(mSenFac=0.822)),
      useFluPor=false)
    "Bestest case 900 with thermal-only air model"
    annotation (Placement(transformation(extent={{-14,-10},{16,10}})));
  Validation.BaseClasses.Structure.Bui900 none(gF(redeclare None airModel),
      useFluPor=false)
    "Bestest case 900 with no air model"
    annotation (Placement(transformation(extent={{-14,-80},{16,-60}})));
  annotation (experiment(StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
March 8, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model shows the order of magnitude difference in temperatures that 
can be expected when changing to non-default air models.
</p>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/ZoneAirModels/Examples/ZoneAirModels.mos"
        "Simulate and plot"));
end ZoneAirModels;
