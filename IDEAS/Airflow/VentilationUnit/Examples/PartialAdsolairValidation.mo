within IDEAS.Airflow.VentilationUnit.Examples;
partial model PartialAdsolairValidation
   extends Modelica.Icons.Example;
  replaceable package MediumWater =
      IDEAS.Media.Water;
  replaceable package MediumAir = IDEAS.Media.Air;

  IDEAS.Airflow.VentilationUnit.Adsolair58 menergaAdsolairValidationModel(
    redeclare package MediumAir = MediumAir,
    redeclare package MediumHeating = MediumWater,
    redeclare replaceable IDEAS.Airflow.VentilationUnit.BaseClasses.Adsolair14200 adsolairData,
    tau=60) annotation (Placement(transformation(extent={{-22,0},{2,20}})));
  IDEAS.Fluid.Sources.MassFlowSource_T environment(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=1,
    use_m_flow_in=true,
    use_X_in=true)
    annotation (Placement(transformation(extent={{38,-2},{18,18}})));
  IDEAS.Fluid.Sources.Boundary_pT sinkWater(redeclare package Medium =
        MediumWater, nPorts=2)
    annotation (Placement(transformation(extent={{-60,-18},{-40,-38}})));
  IDEAS.Fluid.Sources.MassFlowSource_T zone(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=1,
    use_m_flow_in=true,
    use_X_in=true)
    annotation (Placement(transformation(extent={{-66,2},{-46,22}})));
  IDEAS.Fluid.Sources.Boundary_pT sinkAir(redeclare package Medium = MediumAir,
      nPorts=2)
    annotation (Placement(transformation(extent={{40,-20},{20,-40}})));
  IDEAS.Airflow.VentilationUnit.BaseClasses.ToMassFlowRate mflow_VflowTop2(redeclare
      package
      Medium = MediumAir)
    annotation (Placement(transformation(extent={{-84,22},{-74,32}})));
  IDEAS.Airflow.VentilationUnit.BaseClasses.ToMassFlowRate mflow_VflowBot2(redeclare
      package
      Medium = MediumAir) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={61,19})));
  IDEAS.Utilities.Psychrometrics.X_pTphi
                                   XiEnv(use_p_in=false)
    annotation (Placement(transformation(extent={{-86,2},{-74,14}})));
equation
  connect(sinkWater.ports[1], menergaAdsolairValidationModel.heatingOut)
    annotation (Line(points={{-40,-30},{-40,-30},{-17,-30},{-17,0}},     color={
          0,127,255}));
  connect(environment.ports[1], menergaAdsolairValidationModel.freshAir)
    annotation (Line(points={{18,8},{18,7.4},{2,7.4}},color={0,127,255}));
  connect(zone.ports[1], menergaAdsolairValidationModel.extractedAir)
    annotation (Line(points={{-46,12},{-46,12},{-22,12}}, color={0,127,255}));
  connect(sinkAir.ports[1], menergaAdsolairValidationModel.injectedAir)
    annotation (Line(points={{20,-32},{-28,-32},{-28,8},{-22,8}}, color={0,127,255}));
  connect(menergaAdsolairValidationModel.dumpedAir, sinkAir.ports[2])
    annotation (Line(points={{2,12},{6,12},{6,-16},{6,-28},{20,-28}}, color={0,127,
          255}));
  connect(mflow_VflowBot2.m_flow, environment.m_flow_in) annotation (Line(
        points={{55.7,19},{46,19},{46,16},{38,16}}, color={0,0,127}));
  connect(mflow_VflowTop2.m_flow, zone.m_flow_in) annotation (Line(points={{-73.7,
          27},{-72,27},{-72,20},{-70,20},{-66,20}},      color={0,0,127}));
  connect(XiEnv.X, zone.X_in) annotation (Line(points={{-73.4,8},{-72,8},{-68,8}},
                                  color={0,0,127}));
  connect(XiEnv.T, zone.T_in) annotation (Line(points={{-87.2,8},{-90,8},{-90,16},
          {-68,16}},     color={0,0,127}));
  connect(mflow_VflowTop2.T, XiEnv.T) annotation (Line(points={{-84.3,29},{-88,29},
          {-88,28},{-90,28},{-90,8},{-87.2,8}}, color={0,0,127}));
  connect(menergaAdsolairValidationModel.heatingIn, sinkWater.ports[2])
    annotation (Line(points={{-20.8,0},{-18,0},{-18,-10},{-18,-26},{-40,-26}},
        color={0,127,255}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StartTime=500000,
      StopTime=850000,
      __Dymola_NumberOfIntervals=20000,
      __Dymola_fixedstepsize=20,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall={createPlot(
          id=1,
          position={0,0,2257,1092},
          y={"menergaAdsolairValidationModel.P","Pel_accurate.y"},
          range={500000.0,850000.0,-2000.0,12000.0},
          grid=true,
          legends={"Simulated electrical power consumption",
            "Measured electrical power consumption"},
          colors={{28,108,200},{238,46,47}}),createPlot(
          id=1,
          position={0,0,2257,268},
          y={"dataBus.FJ_bureaux2_bypass1_top",
            "dataBus.FJ_bureaux2_bypass2_top",
            "dataBus.FJ_bureaux2_bypass1_bottom",
            "dataBus.FJ_bureaux2_bypass2_bottom"},
          range={500000.0,850000.0,-0.2,1.2000000000000002},
          grid=true,
          legends={"Valve heat recovery top [1]","Valve bypass top [1]",
            "Valve heat recovery bottom [1]","Valve bypass bottom [1]"},
          subPlot=2,
          colors={{28,108,200},{238,46,47},{0,140,72},{180,56,148}}),createPlot(
          id=1,
          position={0,0,2257,269},
          y={"dataBus.FJ_p_bureaux2_rep","dataBus.FJ_p_bureaux2_pul"},
          range={500000.0,850000.0,-100.0,400.0},
          grid=true,
          legends={"Pressure return [Pa]","Pressure supply [Pa]"},
          subPlot=3,
          colors={{28,108,200},{238,46,47}}),createPlot(
          id=1,
          position={0,0,2257,268},
          y={"mflow_VflowBot2.m_flow","mflow_VflowTop2.m_flow"},
          range={500000.0,850000.0,-1.0,5.0},
          grid=true,
          legends={"Mass flow rate supply [kg/s]",
            "Mass flow rate return [kg/s]"},
          subPlot=4,
          colors={{238,46,47},{28,108,200}})} "Validation electrical power",
        file="Resources/Scripts/Dymola/Validations/Ventilation/MenergaPowerValidation.mos"
        "Unit test"),
    Documentation(info="<html>
<p>Validation of electrical power consumption for fans using known pressures and valve set points</p>
</html>", revisions="<html>
<ul>
<li>
October 11, 2016, by Filip Jorissen:<br/>
Added first implementation.
</li>
</ul>
</html>"));
end PartialAdsolairValidation;
