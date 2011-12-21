within IDEAS.Thermal.Components.Examples;
model FloorHeatingComparisonDiscrete "test with instantiated test models"

//  FloorHeatingTester discDyn2(redeclare Components.HeatEmission.TabsDiscretized
//                                                                                tabs(
//    n=22,
//    redeclare parameter TME.FHF.Components.HeatEmission.FH_Standard2  FHCharsDiscretized))
//    annotation (Placement(transformation(extent={{-40,48},{-20,68}})));
//

    FloorHeatingTester discDyn3(redeclare
      Components.HeatEmission.TabsDiscretized                                   tabs(n=3, redeclare parameter
        IDEAS.Thermal.Components.Emission.FH_Standard2 FHCharsDiscretized))
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  FloorHeatingTester discDyn20(redeclare
      Components.HeatEmission.TabsDiscretized         tabs(n=20, redeclare parameter
        IDEAS.Thermal.Components.Emission.FH_Standard2 FHCharsDiscretized))
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  FloorHeatingTester nonDiscDyn(redeclare Components.HeatEmission.Tabs tabs)
    annotation (Placement(transformation(extent={{-40,76},{-20,96}})));
  FloorHeatingTester nonDiscFullyDyn(redeclare Components.HeatEmission.Tabs
      tabs(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch
        embeddedPipe))
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));
    FloorHeatingTester discFullDyn3(redeclare
      Components.HeatEmission.TabsDiscretized tabs(
      n=3,
      redeclare parameter IDEAS.Thermal.Components.Emission.FH_Standard2
        FHCharsDiscretized,
      tabs(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch
          embeddedPipe)))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  FloorHeatingTester discFullDyn20(redeclare
      Components.HeatEmission.TabsDiscretized tabs(
      n=20,
      redeclare parameter IDEAS.Thermal.Components.Emission.FH_Standard2
        FHCharsDiscretized,
      tabs(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch
          embeddedPipe)))
    annotation (Placement(transformation(extent={{-40,-88},{-20,-68}})));
end FloorHeatingComparisonDiscrete;
