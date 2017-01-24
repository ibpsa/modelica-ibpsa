within IDEAS.Examples.TwinHouses;
model BuildingN2_Exp1
  "Model for simulation of experiment 1 for the N2 building"
  extends Modelica.Icons.Example;
  extends IDEAS.Examples.TwinHouses.Interfaces.PartialTwinHouse(
    bui=1,
    exp=1,
    redeclare replaceable BaseClasses.Structures.TwinhouseN2 struct);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=1.5e+007,
      StopTime=2.35872e+007,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/Twinhouses/BuildingN2_Exp1.mos"
        "Simulate and plot"));
end BuildingN2_Exp1;
