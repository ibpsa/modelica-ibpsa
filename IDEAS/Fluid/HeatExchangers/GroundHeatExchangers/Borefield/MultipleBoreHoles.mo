within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield;
model MultipleBoreHoles
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  // FIXME:
  //  1) make it possible to run model without pre-compilation of g-function (short term)
  //  2) make it possible to run model with full pre-compilation of g-fuction (short and long term)
  //  3) Make the enthalpy a differentiable function (look at if statement)

  // Medium in borefield
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  // General parameters of borefield
  replaceable parameter Borefield.Data.Records.BorefieldData bfData
    constrainedby Data.Records.BorefieldData
    annotation (Placement(transformation(extent={{-134,-134},{-114,-114}})));

  //General parameters of aggregation
  parameter Integer p_max=5
    "maximum number of cells for each aggreagation level";

  parameter Integer lenSim=3600*24*100
    "Simulation length ([s]). By default = 100 days";

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
  Modelica.Blocks.Interfaces.RealOutput T_fts(unit="K")
  annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=-90,
        origin={2,-144}),
        iconTransformation(extent={{-18,-18},{18,18}},
        rotation=-90,
        origin={2,-144})));

protected
  Medium.ThermodynamicState sta_hcf
    "thermodynamic state for heat carrier fluid at temperature T_ft";

  Modelica.SIunits.Enthalpy h_out_val
    "Enthalpy of the medium exiting the borefield";

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
  IDEAS.Fluid.Sources.Boundary_ph out(
    redeclare package Medium = Medium,
    use_h_in=true,
    nPorts=2)
    annotation (Placement(transformation(extent={{-44,-10},{-64,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b flowPort_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-150,-40},{-130,40}}),
        iconTransformation(extent={{-150,-40},{-130,40}})));
  Modelica.Fluid.Interfaces.FluidPorts_a flowPort_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{130,-40},{150,40}}),
        iconTransformation(extent={{130,-40},{150,40}})));

    Modelica.Blocks.Sources.RealExpression h_out(y=h_out_val)
    "Enthalpy of the medium of the exiting fluid from the borefield"
    annotation (Placement(transformation(extent={{10,-6},{-10,14}})));
  Sensors.TemperatureTwoPort TSen_out(
    redeclare package Medium = Medium,
    tau=30,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=bfData.steRes.T_ini)
    "Temperature of the fluid exiting the borefield"
    annotation (Placement(transformation(extent={{-78,-12},{-102,12}})));
  Sensors.TemperatureTwoPort TSen_in(
    redeclare package Medium = Medium,
    tau=30,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=bfData.steRes.T_ini)
    "Temperature of the fluid entering the borefield"
    annotation (Placement(transformation(extent={{120,-12},{96,12}})));

  Modelica.SIunits.Power Q_flow
    "thermal power extracted or injected in the borefield";

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
  if abs(Q_flow) > 10^(-3) and TSen_in.port_a.m_flow > bfData.m_flow_nominal / 10000 then
    h_out_val = Medium.specificEnthalpy(sta_hcf) - Q_flow/TSen_in.port_a.m_flow/2;
  else
    h_out_val = Medium.specificEnthalpy(sta_hcf);
  end if;

  connect(h_out.y, out.h_in) annotation (Line(
      points={{-11,4},{-42,4}},
      color={0,0,127},
      smooth=Smooth.None));

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
  connect(TSen_in.port_a, flowPort_a) annotation (Line(
      points={{120,0},{140,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_out.port_b, flowPort_b) annotation (Line(
      points={{-102,0},{-140,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_in.port_b, out.ports[1]) annotation (Line(
      points={{96,0},{40,0},{40,40},{-70,40},{-70,2},{-64,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_out.port_a, out.ports[2]) annotation (Line(
      points={{-78,0},{-72,0},{-72,-2},{-64,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}), graphics={
        Rectangle(
          extent={{-140,140},{140,-140}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-108,114},{-30,36}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-100,106},{-38,44}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-116,40},{118,-40}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-104,-34},{-26,-112}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-96,-42},{-34,-106}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{32,112},{110,34}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{40,104},{102,42}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,-36},{114,-114}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-44},{106,-106}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}),     graphics));
end MultipleBoreHoles;
