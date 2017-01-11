within IDEAS.Examples.TwinHouses;
model BuildingO5_Exp1
  "Model for simulation of experiment 1 for the O5 building"
 extends BuildingN2_Exp1(
    inputSolTTH(fileName="C:/Users/glenn/Documents/1_Git/IDEAS/IDEAS/Inputs/weatherinput.txt"),
    sim(filNam="weatherinput.txt"),
    redeclare BaseClasses.Structures.TwinhouseO5 struct(Exp=1, filename="bc_TTH_O5.txt"),
    redeclare BaseClasses.HeatingSystems.ElectricHeating_Twinhouse_alt heaSys(
        scheduleExp1_1(filename="meas_TTH_O5.txt")),
    redeclare BaseClasses.Ventilation.Vent_TTH vent(filename="bc_TTH_O5.txt"));

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
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/Twinhouses/BuildingO5_Exp1.mos"
        "Simulate and plot"));
end BuildingO5_Exp1;
