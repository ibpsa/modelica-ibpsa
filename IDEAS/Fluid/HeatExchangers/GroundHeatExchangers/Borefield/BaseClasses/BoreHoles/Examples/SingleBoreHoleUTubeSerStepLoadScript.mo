within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples;
model SingleBoreHoleUTubeSerStepLoadScript
  "SingleBoreHoleSer with step input load "
  extends Modelica.Icons.Example;

  package Medium = IDEAS.Media.Water.Simple;

  replaceable parameter Data.SoilData.WetSand_validation
                                    soi
     annotation (Placement(transformation(extent={{14,-46},{24,-36}})));
  replaceable parameter Data.FillingData.Bentonite_validation
                                        fil
    "Thermal properties of the filling material"
     annotation (Placement(transformation(extent={{30,-46},{40,-36}})));
  replaceable parameter Data.GeneralData.SandBox_validation
                                                     gen
    "General charachteristic of the borehole"
    annotation (Placement(transformation(extent={{46,-46},{56,-36}})));

  replaceable SingleBoreHolesUTubeInSerie borHolSer(
    redeclare each package Medium = Medium,
    soi=soi,
    fil=fil,
    gen=gen) "Borehole heat exchanger"
                              annotation (Placement(transformation(extent={{-12,
            -20},{12,4}}, rotation=0)));

  IDEAS.Fluid.Sources.Boundary_ph sin(redeclare package Medium =
        Medium, nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{22,-2},{34,10}})));

  Modelica.Blocks.Sources.Step step(height=1)
    annotation (Placement(transformation(extent={{58,12},{46,24}})));

  IDEAS.Fluid.HeatExchangers.HeaterCooler_u                                hea(
    redeclare package Medium = Medium,
    m_flow_nominal=gen.m_flow_nominal_bh,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow(start=gen.m_flow_nominal_bh),
    T_start=gen.T_start,
    Q_flow_nominal=gen.q_ste*gen.hBor*gen.nbSer,
    p_start=100000)
    annotation (Placement(transformation(extent={{30,40},{10,20}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSen_bor_in(
    redeclare package Medium = Medium,
    tau=60,
    m_flow_nominal=gen.m_flow_nominal_bh,
    T_start=gen.T_start) "Temperature at the inlet of the borefield"
    annotation (Placement(transformation(extent={{-48,-16},{-32,0}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TSen_bor_out(
    redeclare package Medium = Medium,
    tau=60,
    m_flow_nominal=gen.m_flow_nominal_bh,
    T_start=gen.T_start) "Temperature at the outlet of the borefield"
    annotation (Placement(transformation(extent={{40,-16},{56,0}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  IDEAS.Fluid.Movers.FlowMachine_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=gen.m_flow_nominal_bh,
    dynamicBalance=false,
    T_start=gen.T_start,
    motorCooledByFluid=false,
    addPowerToMedium=false,
    filteredSpeed=false)
    annotation (Placement(transformation(extent={{-26,44},{-46,24}})));
  Modelica.Blocks.Sources.Constant mFlo(k=gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{-62,6},{-50,18}})));

  Real Rb_sim = ((TSen_bor_out.T + TSen_bor_in.T)/2 - borHolSer.TWallAve)/gen.q_ste;
equation
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{30,30},{66,30},{66,4},{34,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, hea.u) annotation (Line(
      points={{45.4,18},{40,18},{40,24},{32,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSen_bor_in.port_b, borHolSer.port_a) annotation (Line(
      points={{-32,-8},{-12,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, TSen_bor_out.port_b) annotation (Line(
      points={{30,30},{66,30},{66,-8},{56,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_bor_out.port_a, borHolSer.port_b) annotation (Line(
      points={{40,-8},{12,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-49.4,12},{-35.8,12},{-35.8,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-26,34},{-8,34},{-8,30},{10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, TSen_bor_in.port_a) annotation (Line(
      points={{-46,34},{-76,34},{-76,-8},{-48,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://IDEAS/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
<p>

</p>
</html>", revisions="<html>
<ul>
</ul>
</html>"),
    experiment(
      StopTime=360000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
        graphics));
end SingleBoreHoleUTubeSerStepLoadScript;
