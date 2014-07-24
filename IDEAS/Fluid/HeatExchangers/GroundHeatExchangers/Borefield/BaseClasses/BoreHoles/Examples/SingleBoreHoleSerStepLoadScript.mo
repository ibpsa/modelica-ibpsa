within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples;
model SingleBoreHoleSerStepLoadScript "SingleBoreHoleSer with step input load "
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

   parameter Data.StepResponse.example steRes "generic step load parameter"
     annotation (Placement(transformation(extent={{-18,-46},{-8,-36}})));
   parameter Data.Advanced.example adv "Advanced parameters"
     annotation (Placement(transformation(extent={{-2,-46},{8,-36}})));
   parameter Data.SoilData.example soi
     annotation (Placement(transformation(extent={{14,-46},{24,-36}})));
   parameter Data.FillingData.example fil
    "Thermal properties of the filling material"
     annotation (Placement(transformation(extent={{30,-46},{40,-36}})));
   parameter Data.GeometricData.example geo
    "Geometric charachteristic of the borehole"
     annotation (Placement(transformation(extent={{46,-46},{56,-36}})));

  BoreHoles.SingleBoreHolesInSerie borHolSer(
    redeclare each package Medium = Medium,
    soi=soi,
    fil=fil,
    geo=geo,
    adv=adv,
    dp_nominal=10000,
    m_flow_nominal=steRes.m_flow,
    T_start=steRes.T_ini) "Borehole heat exchanger" annotation (Placement(
        transformation(extent={{-12,-20},{12,4}},   rotation=0)));

  IDEAS.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=2) "Sink"
    annotation (Placement(transformation(extent={{22,-2},{34,10}})));

  Modelica.Blocks.Sources.Step step(height=1)
    annotation (Placement(transformation(extent={{58,12},{46,24}})));

  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-46,6},{-34,18}})));
  IDEAS.Fluid.Movers.Pump                               pum(
    redeclare package Medium = Medium,
    m_flow_nominal=steRes.m_flow,
    m_flow(start=steRes.m_flow),
    T_start=steRes.T_ini,
    useInput=true)
    annotation (Placement(transformation(extent={{-12,40},{-32,20}})));

  IDEAS.Fluid.HeatExchangers.HeaterCoolerPrescribed                                hea(
    redeclare package Medium = Medium,
    m_flow_nominal=steRes.m_flow,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow(start=steRes.m_flow),
    T_start=steRes.T_ini,
    Q_flow_nominal=steRes.q_ste*geo.hBor*geo.nbSer,
    p_start=100000)
    annotation (Placement(transformation(extent={{30,40},{10,20}})));
  Sensors.TemperatureTwoPort TSen_bor_in(
    redeclare package Medium = Medium,
    tau=60,
    m_flow_nominal=steRes.m_flow,
    T_start=steRes.T_ini) "temperature at the inlet of the borefield"
    annotation (Placement(transformation(extent={{-48,-16},{-32,0}})));
  Sensors.TemperatureTwoPort TSen_bor_out(
    redeclare package Medium = Medium,
    tau=60,
    m_flow_nominal=steRes.m_flow,
    T_start=steRes.T_ini) "temperature at the outlet of the borefield"
    annotation (Placement(transformation(extent={{40,-16},{56,0}})));
equation
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{30,30},{66,30},{66,5.2},{34,5.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a,hea. port_b) annotation (Line(
      points={{-12,30},{10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, hea.u) annotation (Line(
      points={{45.4,18},{40,18},{40,24},{32,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flowSet) annotation (Line(
      points={{-33.4,12},{-22,12},{-22,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_b, TSen_bor_in.port_a) annotation (Line(
      points={{-32,30},{-58,30},{-58,-8},{-48,-8}},
      color={0,127,255},
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
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),graphics),
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
      StopTime=3.1536e+007,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
        graphics));
end SingleBoreHoleSerStepLoadScript;
