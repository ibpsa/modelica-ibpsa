within IDEAS.Examples.TwinHouses;
model BuildingN2_Exp2 "Model for simulation of experiment2 for the N2 building"
  extends BuildingN2_Exp1(
    inputSolTTH(fileName=
          "C:/Users/glenn/Documents/1_Git/IDEAS/IDEAS/Inputs/weatherinputExp2.txt"),

    sim(filNam="weatherinputExp2.txt"),
    struct(Exp=2, filename="bc_TTH_Exp2.txt"),
    vent(filename="bc_TTH_Exp2.txt"),
    heaSys(Exp=2, scheduleExp1_1(
        Schedule={8467200,10198800,11494800,12013200},
        Tinit2=303.15,
        filename="meas_TTH_Exp2.txt")));
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
      OutputFlatModelica=false));
end BuildingN2_Exp2;
