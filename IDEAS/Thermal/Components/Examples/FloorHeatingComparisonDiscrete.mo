within IDEAS.Thermal.Components.Examples;
model FloorHeatingComparisonDiscrete "test with instantiated test models"

  extends Modelica.Icons.Example;

  //  FloorHeatingTester discDyn2(redeclare Components.Emission.TabsDiscretized
  //                                                                                tabs(
  //    n=22,
  //    redeclare parameter TME.FHF.Components.HeatEmission.FH_Standard2  FHCharsDiscretized))
  //    annotation (Placement(transformation(extent={{-40,48},{-20,68}})));
  //

  FloorHeatingTester discDyn3(redeclare Components.Emission.TabsDiscretized
      tabs(n=3, redeclare parameter
        IDEAS.Thermal.Components.Emission.BaseClasses.FH_Standard2
        FHCharsDiscretized))
    annotation (Placement(transformation(extent={{-40,26},{-20,46}})));

  FloorHeatingTester discDyn20(redeclare Components.Emission.TabsDiscretized
      tabs(n=20, redeclare parameter
        IDEAS.Thermal.Components.Emission.BaseClasses.FH_Standard2
        FHCharsDiscretized))
    annotation (Placement(transformation(extent={{-40,-24},{-20,-4}})));

  FloorHeatingTester nonDiscDyn(redeclare Components.Emission.Tabs tabs)
    annotation (Placement(transformation(extent={{-40,76},{-20,96}})));
end FloorHeatingComparisonDiscrete;
