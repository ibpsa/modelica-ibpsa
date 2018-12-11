within IDEAS.Examples.TwinHouses;
model BuildingN2_Exp2 "Model for simulation of experiment2 for the N2 building"
  extends BuildingN2_Exp1(
    loadVal=true,
    bui=1,
    exp=2,
    struct(T_start=298));

  annotation (
    experiment(
      StartTime=8.46e+06,
      StopTime=1.2e+07,
      Interval=900,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Examples/Twinhouses/BuildingN2_Exp2.mos"
        "Simulate and plot", executeCall={createPlot(
          id=4,
          position={0,0,1309,724},
          y={"struct.W31.propsBus_a.surfRad.T",
            "validationDataExp2_1.living_window_south_IS_T"},
          range={8000000.0,12300000.0,290.0,320.0},
          autoscale=false,
          grid=true,
          colors={{28,108,200},{238,46,47}}),createPlot(
          id=4,
          position={0,0,1309,238},
          y={"validationDataExp2_1.living_window_west_IS_T",
            "struct.W32.propsBus_a.surfRad.T"},
          range={8000000.0,12300000.0,290.0,320.0},
          autoscale=false,
          grid=true,
          subPlot=2,
          colors={{28,108,200},{238,46,47}}),createPlot(
          id=4,
          position={0,0,1309,239},
          y={"validationDataExp2_1.living_h110cm_AT",
            "validationDataExp2_1.living_h010cm_AT",
            "validationDataExp2_1.living_h170cm_AT","struct.TSensor[1]"},
          range={8000000.0,12300000.0,301.0,308.0},
          autoscale=false,
          grid=true,
          subPlot=3,
          colors={{0,0,0},{238,46,47},{217,67,180},{28,108,200}},
          range2={0.45,0.75}),createPlot(
          id=4,
          position={0,0,1309,178},
          y={"validationDataExp2_1.living_westfacade_S_ES_T",
            "struct.W9.layMul.port_b.T","sim.Te"},
          range={8000000.0,12300000.0,270.0,310.0},
          autoscale=false,
          grid=true,
          subPlot=4,
          colors={{28,108,200},{238,46,47},{0,140,72}})} "Validation living",
      file="Resources/Scripts/TwinHouse/Living.mos" "Living",
      file="Resources/Scripts/TwinHouse/MeanAbsoluteTemperatureErrors.mos"
        "Mean absolute temperature errors"));
end BuildingN2_Exp2;
