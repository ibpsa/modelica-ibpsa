within IBPSA.Fluid.Movers.Validation;
model ComparePowerHydraulic
  "Compare power estimation with hydraulic power curve"
  extends Modelica.Icons.Example;
  extends IBPSA.Fluid.Movers.Validation.BaseClasses.ComparePower(
    redeclare IBPSA.Fluid.Movers.Data.Fans.Greenheck.BIDW15 per(
      etaMotMet=IBPSA.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      motorEfficiency(V_flow={0}, eta={0.7})),
    mov1(per=per),
    mov2(per(
      powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
      pressure=per.pressure,
      power=per.power,
      etaHydMet=IBPSA.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
      etaMotMet=per.etaMotMet)),
    mov3(per(
      powerOrEfficiencyIsHydraulic=per.powerOrEfficiencyIsHydraulic,
      pressure=per.pressure,
      power=per.power,
      etaHydMet=IBPSA.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      efficiency(V_flow={per.peak.V_flow}, eta={per.peak.eta}),
      etaMotMet=per.etaMotMet)));

equation
  connect(ramSpe.y, mov2.y) annotation (Line(points={{-59,80},{-52,80},{-52,0},
          {-30,0},{-30,-8}},    color={0,0,127}));
  connect(ramSpe.y, mov3.y) annotation (Line(points={{-59,80},{-52,80},{-52,-50},
          {-30,-50},{-30,-58}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Movers/Validation/ComparePowerHydraulic.mos"
        "Simulate and plot"));
end ComparePowerHydraulic;
