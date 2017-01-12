within IDEAS.Examples.TwinHouses;
model BuildingN2_Exp2 "Model for simulation of experiment2 for the N2 building"
  extends BuildingN2_Exp1(
    bui=1,
    exp=2);

  annotation (
    experiment(
      StartTime=9.7e+006,
      StopTime=1.23e+007,
      Interval=900,
      Tolerance=1e-006,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/Twinhouses/BuildingN2_Exp2.mos"
        "Simulate and plot"));
end BuildingN2_Exp2;
