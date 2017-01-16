within IDEAS.Examples.TwinHouses.BaseClasses.Data.Validation;
model SolarValidation
  extends Modelica.Icons.Example;
  ValidationDataN2Exp1 validationDataN2Exp1(bui=1)
    "Measurement data for validation purposes"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  IDEAS.Examples.TwinHouses.BaseClasses.TwinHouseInfoManager sim(
    exp=1,
    bui=1,
    radSol(rho=0.23))
           "Sim info manager"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Components.Interfaces.WeaBus weaBus1(numSolBus=5)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Math.Add HGloHor
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Math.Add HGloS
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Math.Add HGloW
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Math.Add HGloN
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.Add HGloE
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(sim.weaBus, weaBus1) annotation (Line(
      points={{-64,92.8},{-40,92.8},{-40,92},{-40,10},{-30,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HGloHor.u1, weaBus1.solBus[1].iSolDir) annotation (Line(points={{-2,56},{
          -29.95,56},{-29.95,10.05}}, color={0,0,127}));
  connect(HGloHor.u2, weaBus1.solBus[1].iSolDif) annotation (Line(points={{-2,44},{
          -29.95,44},{-29.95,10.05}}, color={0,0,127}));
  connect(HGloS.u1, weaBus1.solBus[2].iSolDir) annotation (Line(points={{-2,36},
          {-29.95,36},{-29.95,10.05}},color={0,0,127}));
  connect(HGloS.u2, weaBus1.solBus[2].iSolDif) annotation (Line(points={{-2,24},
          {-29.95,24},{-29.95,10.05}},color={0,0,127}));
  connect(HGloW.u1, weaBus1.solBus[3].iSolDir) annotation (Line(points={{-2,16},
          {-29.95,16},{-29.95,10.05}},color={0,0,127}));
  connect(HGloW.u2, weaBus1.solBus[3].iSolDif) annotation (Line(points={{-2,4},{
          -29.95,4},{-29.95,10.05}},  color={0,0,127}));
  connect(HGloN.u1, weaBus1.solBus[4].iSolDir) annotation (Line(points={{-2,-4},
          {-29.95,-4},{-29.95,10.05}},color={0,0,127}));
  connect(HGloN.u2, weaBus1.solBus[4].iSolDif) annotation (Line(points={{-2,-16},
          {-29.95,-16},{-29.95,10.05}},
                                      color={0,0,127}));
  connect(HGloE.u1, weaBus1.solBus[5].iSolDir) annotation (Line(points={{-2,-24},
          {-29.95,-24},{-29.95,10.05}},
                                      color={0,0,127}));
  connect(HGloE.u2, weaBus1.solBus[5].iSolDif) annotation (Line(points={{-2,-36},
          {-29.95,-36},{-29.95,10.05}},
                                      color={0,0,127}));


    annotation (experiment(
      StartTime=2e+07,
      StopTime=2.35872e+07,
      Interval=600), __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/Twinhouses/BaseClasses/Data/Validation/SolarValidation.mos"
        "Simulate and plot"));
end SolarValidation;
