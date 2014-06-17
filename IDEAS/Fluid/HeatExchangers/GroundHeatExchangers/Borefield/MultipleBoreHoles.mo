within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield;
model MultipleBoreHoles
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  // FIXME:
  //  1) make it possible to run model without pre-compilation of g-function (short term)
  //  2) make it possible to run model with full pre-compilation of g-fuction (short and long term)
  //  3) Make the enthalpy a differentiable function (look at if statement)

  // Medium in borefield
  extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(m_flow_nominal = bfData.m_flow_nominal, redeclare
      package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater, final allowFlowReversal=false);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true, dp_nominal = 0);

  // General parameters of borefield
  replaceable parameter Borefield.Data.Records.BorefieldData bfData
    constrainedby Data.Records.BorefieldData
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-90,-88},
            {-70,-68}})));

  //General parameters of aggregation
  parameter Integer p_max=5
    "maximum number of cells for each aggreagation level";

  parameter Integer lenSim=3600*24*100
    "Simulation length ([s]). By default = 100 days";
  parameter Boolean homotopyInitialization=true "= true, use homotopy method";
  final parameter Integer q_max=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbOfLevelAgg(
      n_max=integer(lenSim/bfData.steRes.tStep), p_max=p_max)
    "number of aggregation levels";

  final parameter Modelica.SIunits.Temperature TSteSta=
      Borefield.BaseClasses.GroundHX.HeatCarrierFluidStepTemperature(
            steRes=bfData.steRes,
            geo=bfData.geo,
            soi=bfData.soi,
            shoTerRes=bfData.shoTerRes,
            t_d=bfData.steRes.tSteSta_d);

  final parameter Real R_ss=TSteSta/(bfData.steRes.q_ste*bfData.geo.hBor
      *bfData.geo.nbBh) "steady state resistance";

  // Load of borefield
  Modelica.SIunits.HeatFlowRate QAve_flow
    "Average heat flux over a time period";

protected
  Medium.ThermodynamicState sta_hcf
    "thermodynamic state for heat carrier fluid at temperature T_ft";

  Modelica.SIunits.Temperature T_out_val
    "Temperature of the medium exiting the borefield";

  final parameter Integer[q_max] rArr=
      Borefield.BaseClasses.Aggregation.BaseClasses.cellWidth(
      q_max=q_max, p_max=p_max) "width of aggregation cell for each level";
  final parameter Integer[q_max,p_max] nuMat=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbPulseAtEndEachLevel(
            q_max=q_max,
            p_max=p_max,
            rArr=rArr)
    "nb of aggregated pulse at end of each aggregation cells";
  final parameter Real[q_max,p_max] kappaMat=
      Borefield.BaseClasses.Aggregation.transientFrac(
            q_max=q_max,
            p_max=p_max,
            steRes=bfData.steRes,
            geo=bfData.geo,
            soi=bfData.soi,
            shoTerRes=bfData.shoTerRes,
            nuMat=nuMat,
            TSteSta=TSteSta)
    "transient thermal resistance of each aggregation cells";

  final parameter Integer nbOfAggPulse=nuMat[end, end]
    "number of aggregated pulse";

//Load
  Real[q_max,p_max] QMat
    "aggregation of load vector. Every discrete time step it is updated.";

//Utilities
  Integer iSam(min=1)
    "Counter for how many time the model was sampled. Defined as iSam=1 when called at t=0";
  Modelica.SIunits.Energy UOld "Internal energy at the previous period";
  Modelica.SIunits.Energy U
    "Current internal energy, defined as U=0 for t=tStart";
  Modelica.SIunits.Time startTime "Start time of the simulation";

public
  Modelica.SIunits.Temperature T_fts
    "average of heat carrier fluid temperature between in and outlet";

  Modelica.Blocks.Sources.RealExpression T_out(y=T_out_val)
    "Enthalpy of the medium of the exiting fluid from the borefield"
    annotation (Placement(transformation(extent={{50,-44},{28,-24}})));
  Sensors.TemperatureTwoPort TSen_out(
    redeclare package Medium = Medium,
    tau=30,
    T_start=bfData.steRes.T_ini,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal)
    "Temperature of the fluid exiting the borefield"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Sensors.TemperatureTwoPort TSen_in(
    redeclare package Medium = Medium,
    tau=30,
    T_start=bfData.steRes.T_ini,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal)
    "Temperature of the fluid entering the borefield"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.SIunits.Power Q_flow
    "thermal power extracted or injected in the borefield";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature fixedTemperature
    annotation (Placement(transformation(extent={{14,-44},{-6,-24}})));
  MixingVolumes.MixingVolume             vol(
    redeclare package Medium = Medium,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    m_flow_nominal=m_flow_nominal,
    p_start=p_start,
    allowFlowReversal=allowFlowReversal,
    C_nominal=C_nominal,
    m_flow_small=m_flow_small,
    final V=m_flow_nominal*30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nPorts=2)
    annotation (Placement(transformation(extent={{-30,0},{-50,-20}})));
  FixedResistances.FixedResistanceDpM             res(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final from_dp=from_dp,
    final homotopyInitialization=homotopyInitialization,
    dp_nominal=dp_nominal,
    deltaM=deltaM,
    linearized=linearizeFlowResistance,
    final show_T=show_T,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

initial algorithm
  // Initialisation of the internal energy (zeros) and the load vector. Load vector have the same lenght as the number of aggregated pulse and cover lenSim
  U := 0;
  UOld := 0;
equation
  assert( abs(TSen_in.port_a.m_flow - bfData.m_flow_nominal) < 0.001 or abs(TSen_in.port_a.m_flow) < Modelica.Constants.eps, "This borefield model only works for fixed mass flow rate as defined in bfData.SteRes.m_flow");
  assert( time < lenSim, "The chosen value for lenSim is too small. It cannot cover the simulation time!");

 sta_hcf = Medium.setState_pTX(
    bfData.adv.p_constant,
    T_fts,
    X=Medium.X_default[1:Medium.nXi]);

  Q_flow = Medium.specificHeatCapacityCp(sta_hcf)*TSen_in.port_a.m_flow*(TSen_in.T - TSen_out.T);

  der(U) = Q_flow
    "integration of load to calculate below the average load/(discrete time step)";

  //if the heat flow is very low, the enthalpie is the same at the inlet and outlet
  if abs(Q_flow) > 10^(-3) and TSen_in.port_a.m_flow > m_flow_small then
    TSen_in.port_a.m_flow*Medium.specificHeatCapacityCp(sta_hcf) * (T_fts - T_out_val) = Q_flow/2;
  else
    T_out_val = T_fts;
  end if;

algorithm
  // Set the start time for the sampling
  when initial() then
    startTime := time;
    iSam := 1;
  end when;

  when initial() or sample(startTime, bfData.steRes.tStep) then
    QAve_flow := (U - UOld)/bfData.steRes.tStep;
    UOld := U;

    // Update of aggregated load matrix. Careful: need of inversing order of loaVec (so that [end] = most recent load). FIXME: see if you can change that.
    QMat := Borefield.BaseClasses.Aggregation.aggregateLoad(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr,
      nuMat=nuMat,
      QNew=QAve_flow,
      QAggOld=QMat);

    T_fts := Borefield.BaseClasses.deltaT_ft(
      q_max=q_max,
      p_max=p_max,
      QMat=QMat,
      kappaMat=kappaMat,
      R_ss=R_ss) + bfData.steRes.T_ini;

    iSam := iSam + 1; // FIXME: when I remove this, I get a T_fts = 0 for the whole simulation! ??
  end when;

equation
  connect(T_out.y, fixedTemperature.T) annotation (Line(
      points={{26.9,-34},{16,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, vol.heatPort) annotation (Line(
      points={{-6,-34},{-16,-34},{-16,-10},{-30,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSen_in.port_b, vol.ports[1]) annotation (Line(
      points={{-60,0},{-38,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], res.port_a) annotation (Line(
      points={{-42,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, TSen_out.port_a) annotation (Line(
      points={{40,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_out.port_b, port_b) annotation (Line(
      points={{80,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, TSen_in.port_a) annotation (Line(
      points={{-100,0},{-80,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end MultipleBoreHoles;
