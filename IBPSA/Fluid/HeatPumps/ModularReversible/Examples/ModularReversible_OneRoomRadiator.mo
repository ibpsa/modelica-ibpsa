within IBPSA.Fluid.HeatPumps.ModularReversible.Examples;
model ModularReversible_OneRoomRadiator
  "Modular reversible heat pump connected to a simple room model with radiator"
  extends Modelica.Icons.Example;
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=modRevHeaPum.mEva_flow_nominal,
    mCon_flow_nominal=modRevHeaPum.mCon_flow_nominal,
                                             sin(nPorts=1), booToReaPumEva(
        realTrue=modRevHeaPum.mEva_flow_nominal));
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible modRevHeaPum(
    redeclare package MediumCon = MediumWat,
    redeclare package MediumEva = MediumWat,
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    dTCon_nominal=TRadSup_nominal - TRadRet_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    use_conCap=true,
    CCon=3000,
    GConOut=100,
    GConIns=1000,
    cpCon=4184,
    TEva_nominal=sou.T,
    dTEva_nominal=2,
    dpEva_nominal(displayUnit="Pa") = 2000,
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    cpEva=4184,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade
        (
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        useAirForCon=false,
        useAirForEva=false,
        TAppCon_nominal=0,
        TAppEva_nominal=0),
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal, datTab=
            IBPSA.Fluid.Chillers.ModularReversible.Data.EuropeanNorm2D.EN14511.Vitocal200AWO201()),
    redeclare IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar(
      use_TUseOut=true,
      use_TNotUseOut=false,
      use_antFre=true,
      TAntFre=275.15)) "Modular reversible heat pump"
    annotation (Placement(transformation(extent={{20,-160},{0,-136}})));

  Modelica.Blocks.Sources.Constant temAmbBas(final k=273.15 + 18)
    "Ambient temperature in basement of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-190})));
equation
  connect(modRevHeaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,-154},
          {38,-154},{38,-200},{60,-200}}, color={0,127,255}));
  connect(modRevHeaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(points={{0,
          -154},{-30,-154},{-30,-170}}, color={0,127,255}));
  connect(modRevHeaPum.port_b1, pumHeaPum.port_a) annotation (Line(points={{0,-142},
          {-70,-142},{-70,-120}}, color={0,127,255}));
  connect(modRevHeaPum.port_a1, temRet.port_b) annotation (Line(points={{20,-142},
          {60,-142},{60,-30}}, color={0,127,255}));
  connect(temAmbBas.y, modRevHeaPum.TConAmb) annotation (Line(points={{10,-179},
          {10,-162},{-1,-162},{-1,-138}}, color={0,0,127}));
  connect(modRevHeaPum.hea, oneRooRadHeaPumCtr.hea) annotation (Line(points={{21.6,
          -157},{24,-157},{24,-152},{26,-152},{26,-92},{-132,-92},{-132,-76},{-139,
          -76}}, color={255,0,255}));
  connect(oneRooRadHeaPumCtr.ySet, modRevHeaPum.ySet) annotation (Line(points={
          {-139,-66},{30,-66},{30,-146},{21.6,-146}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  This example demonstrates how to use the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a>
  heat pump model directly. Please check the associated documentation for
  further information.
</p>
<p>
  Correct replacement of the replaceable submodels
  and, thus, flexible aggregation to a new model
  approach is demonstrated.
</p>
<p>
  Please check the documentation of
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator</a>
  for further information on the example.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"),
   __Dymola_Commands(file=
     "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/ModularReversible_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08));
end ModularReversible_OneRoomRadiator;
