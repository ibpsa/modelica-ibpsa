within IBPSA.Fluid.Movers.Validation;
model ComparePowerInput
  "Compare power estimation with different input signal"
  extends Modelica.Icons.Example;
  extends IBPSA.Fluid.Movers.Validation.BaseClasses.ComparePower(
    redeclare IBPSA.Fluid.Movers.Data.Fans.Greenheck.BIDW15 per(
      etaMotMet=IBPSA.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0}, eta={0.7})),
    mov1(per=per),
    redeclare IBPSA.Fluid.Movers.FlowControlled_dp mov2(
      redeclare final package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      per=per,
      addPowerToMedium=false,
      use_inputFilter=false,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal),
    redeclare IBPSA.Fluid.Movers.FlowControlled_m_flow mov3(
      redeclare final package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      per=per,
      addPowerToMedium=false,
      use_inputFilter=false,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal),
    ramDam(height=-0.5));
equation
  connect(relPre.p_rel, mov2.dp_in)
    annotation (Line(points={{-30,1},{-30,-18}}, color={0,0,127}));
  connect(masFloRat.m_flow, mov3.m_flow_in) annotation (Line(points={{10,51},{10,
          54},{-10,54},{-10,-52},{-30,-52},{-30,-58}}, color={0,0,127}));
  connect(ramDam.y, damExp2.y) annotation (Line(points={{21,80},{30,80},{30,-10},
          {50,-10},{50,-18}}, color={0,0,127}));
  connect(ramDam.y, damExp3.y) annotation (Line(points={{21,80},{30,80},{30,-50},
          {50,-50},{50,-58}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Movers/Validation/ComparePowerInput.mos"
        "Simulate and plot"));
end ComparePowerInput;
