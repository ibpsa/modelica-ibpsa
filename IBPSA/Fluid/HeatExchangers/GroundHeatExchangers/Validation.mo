within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers;
package Validation
  extends Modelica.Icons.ExamplesPackage;
  model SandboxValidation
    extends Modelica.Icons.Example;
    package Medium = IBPSA.Media.Water;

    BorefieldOneUTube borHol(redeclare package Medium = Medium, borFieDat=
          borFieDat,
      tLoaAgg=60)            "Borehole"
      annotation (Placement(transformation(extent={{-12,-76},{14,-44}})));
    IBPSA.Fluid.Movers.FlowControlled_m_flow
                                          pum(
      redeclare package Medium = Medium,
      m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      T_start=borFieDat.conDat.T_start,
      addPowerToMedium=false,
      use_inputFilter=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
      annotation (Placement(transformation(extent={{-20,60},{-40,40}})));
    Sensors.TemperatureTwoPort TBorFieIn(redeclare package Medium = Medium,
        m_flow_nominal=borFieDat.conDat.m_flow_nominal,
      T_start=borFieDat.conDat.T_start)
      "Inlet temperature of the borefield"
      annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
    Sensors.TemperatureTwoPort TBorFieOut(redeclare package Medium = Medium,
        m_flow_nominal=borFieDat.conDat.m_flow_nominal,
      T_start=borFieDat.conDat.T_start)
      "Outlet temperature of the borefield"
      annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
    Data.BorefieldData.SandBox_validation borFieDat "Borefield data"
      annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
    IDEAS.Fluid.Sources.Boundary_ph sin(redeclare package Medium =
          Medium, nPorts=1) "Sink"
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    Modelica.Blocks.Sources.Constant mFlo(k=borFieDat.conDat.m_flow_nominal_bh)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Modelica.Blocks.Sources.CombiTimeTable sandBoxMea(
      tableOnFile=true,
      tableName="data",
      fileName=
          Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/ValidationData/SpitlerCstLoad_Time_Tsup_Tret_deltaT.txt"),
      offset={0,0,0},
      columns={2,3,4})
      annotation (Placement(transformation(extent={{-10,70},{10,90}})));
    Modelica.Blocks.Sources.Constant T_start(k=borFieDat.conDat.T_start)
      annotation (Placement(transformation(extent={{10,-40},{-10,-20}})));
    IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
      redeclare package Medium = Medium,
      dp_nominal=10000,
      show_T=true,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      m_flow_nominal=borFieDat.conDat.m_flow_nominal_bh,
      m_flow(start=borFieDat.conDat.m_flow_nominal_bh),
      T_start=borFieDat.conDat.T_start,
      p_start=100000,
      Q_flow_nominal=1056)
      annotation (Placement(transformation(extent={{40,60},{20,40}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=sandBoxMea.y[3])
      annotation (Placement(transformation(extent={{20,10},{40,30}})));
  equation
    connect(TBorFieIn.port_b, borHol.port_a)
      annotation (Line(points={{-40,-60},{-12,-60}}, color={0,127,255}));
    connect(borHol.port_b, TBorFieOut.port_a)
      annotation (Line(points={{14,-60},{40,-60}},          color={0,127,255}));
    connect(pum.port_b, TBorFieIn.port_a) annotation (Line(points={{-40,50},{-62,50},
            {-80,50},{-80,-60},{-60,-60}}, color={0,127,255}));
    connect(sin.ports[1], TBorFieOut.port_b) annotation (Line(points={{60,-30},{80,
            -30},{80,-60},{60,-60}},color={0,127,255}));
    connect(mFlo.y, pum.m_flow_in)
      annotation (Line(points={{-39,10},{-30,10},{-30,38}}, color={0,0,127}));
    connect(T_start.y, borHol.TGro) annotation (Line(points={{-11,-30},{-30,-30},{
            -30,-50.4},{-14.6,-50.4}}, color={0,0,127}));
    connect(hea.port_b, pum.port_a)
      annotation (Line(points={{20,50},{2,50},{-20,50}}, color={0,127,255}));
    connect(hea.port_a, TBorFieOut.port_b) annotation (Line(points={{40,50},{40,50},
            {80,50},{80,-60},{60,-60}}, color={0,127,255}));
    connect(realExpression.y, hea.u) annotation (Line(points={{41,20},{60,20},{
            60,44},{42,44}}, color={0,0,127}));
    annotation (__Dymola_Commands(file=
            "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Validation/SandboxValidation.mos"
          "Simulate and Plot"));
  end SandboxValidation;
end Validation;
