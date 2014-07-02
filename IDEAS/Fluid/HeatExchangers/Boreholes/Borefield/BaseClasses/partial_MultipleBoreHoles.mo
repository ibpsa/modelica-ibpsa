within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses;
partial model partial_MultipleBoreHoles
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  // FIXME:
  //  1) make it possible to run model without pre-compilation of g-function (short term)
  //  2) make it possible to run model with full pre-compilation of g-fuction (short and long term)
  //  3) reset the value of U in if-statement

// General parameters of borefield
  replaceable parameter Data.Records.BorefieldData bfData
    constrainedby Data.Records.BorefieldData
    annotation (Placement(transformation(extent={{-134,-134},{-114,-114}})));

//General parameters of aggregation
  parameter Integer p_max=5
    "maximum number of cells for each aggreagation level";

  parameter Integer lenSim=3600*24*100
    "Simulation length ([s]). By default = 100 days";

  final parameter Integer q_max=
      Aggregation.BaseClasses.nbOfLevelAgg(
      n_max=integer(lenSim/bfData.steRes.tStep), p_max=p_max)
    "number of aggregation levels";

  final parameter Modelica.SIunits.Temperature TSteSta=
      GroundHX.HeatCarrierFluidStepTemperature(
            steRes=bfData.steRes,
            geo=bfData.geo,
            soi=bfData.soi,
            shoTerRes=bfData.shoTerRes,
            t_d=bfData.steRes.tSteSta_d);

  final parameter Real R_ss=TSteSta/(bfData.steRes.q_ste*bfData.geo.hBor
      *bfData.geo.nbBh);

// Load of borefield
  Modelica.SIunits.HeatFlowRate QAve_flow
    "Average heat flux over a time period";
  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
  annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,146}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,86})));
  Modelica.Blocks.Interfaces.RealOutput T_fts(unit="K")
  annotation (Placement(transformation(extent={{-18,-18},{18,18}},
        rotation=-90,
        origin={0,-144}),
        iconTransformation(extent={{-18,-18},{18,18}},
        rotation=-90,
        origin={2,-98})));

protected
  final parameter Integer[q_max] rArr=
      Aggregation.BaseClasses.cellWidth(
      q_max=q_max, p_max=p_max) "width of aggregation cell for each level";
  final parameter Integer[q_max,p_max] nuMat=
      Aggregation.BaseClasses.nbPulseAtEndEachLevel(
            q_max=q_max,
            p_max=p_max,
            rArr=rArr)
    "nb of aggregated pulse at end of each aggregation cells";
  final parameter Real[q_max,p_max] kappaMat=
      Aggregation.transientFrac(
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

initial algorithm
  // Initialisation of the internal energy (zeros) and the load vector. Load vector have the same lenght as the number of aggregated pulse and cover lenSim
  U := 0;
  UOld := 0;
//  loaVec := zeros(nbOfAggPulse);
equation
  assert( time < lenSim, "The chosen value for lenSim is too small. It cannot cover the simulation time!");
  der(U) = Q_flow
    "integration of load to calculate below the average load/(discrete time step)";

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
    QMat := Aggregation.aggregateLoad(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr,
      nuMat=nuMat,
      QNew=QAve_flow,
      QAggOld=QMat);

    T_fts := deltaT_ft(
      q_max=q_max,
      p_max=p_max,
      QMat=QMat,
      kappaMat=kappaMat,
      R_ss=R_ss) + bfData.steRes.T_ini;

    iSam := iSam + 1; // FIXME: when I remove this, I get a T_fts = 0 for the whole simulation! ??
  end when;

  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}), graphics={
        Rectangle(
          extent={{-90,90},{90,-90}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,-10},{70,-70}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{10,70},{70,10}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-70,70},{-10,10}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-70,-10},{-10,-70}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-62,62},{-18,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{18,62},{62,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-62,-18},{-18,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{18,-18},{62,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Text(
          extent={{-76,156},{74,98}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}),     graphics));
end partial_MultipleBoreHoles;
