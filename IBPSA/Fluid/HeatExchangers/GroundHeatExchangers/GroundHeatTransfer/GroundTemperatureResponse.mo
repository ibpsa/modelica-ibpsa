within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer;
model GroundTemperatureResponse "Model calculating discrete load aggregation"
  parameter Modelica.SIunits.Time tLoaAgg=3600 "Time resolution of load aggregation";
  parameter Integer p_max(min=1)=5 "Number of cells per aggregation level";
  parameter Boolean forceGFunCalc = false
    "Set to true to force the thermal response to be calculated at the start instead of checking whether this has been pre-computed";
  parameter
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat
    "Record containing all the parameters of the borefield model" annotation (
     choicesAllMatching=true, Placement(transformation(extent={{-100,-100},{-80,
            -80}})));

  Modelica.Blocks.Interfaces.RealInput Tg
    "Temperature input for undisturbed ground conditions"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tb
    "Heat port for resulting borehole wall conditions"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  parameter Integer nbTimSho = 26 "Number of time steps in short time region";
  parameter Integer nbTimLon = 50 "Number of time steps in long time region";
  parameter Real ttsMax = exp(5) "Maximum adimensional time for gfunc calculation";
  parameter String SHAgfun=ThermalResponseFactors.shaGFunction(
      nbBor=borFieDat.conDat.nbBh,
      cooBor=borFieDat.conDat.cooBh,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      alpha=borFieDat.soiDat.alp,
      nbSeg=12,
      nbTimSho=26,
      nbTimLon=50,
      relTol=0.02,
      ttsMax=exp(5)) "String with encrypted g-function arguments";
  parameter Integer nrow = nbTimSho+nbTimLon-1
    "Length of g-function matrix";
  parameter Real lvlBas = 2 "Base for exponential cell growth between levels";
  parameter Modelica.SIunits.Time timFin=
    (borFieDat.conDat.hBor^2/(9*borFieDat.soiDat.alp))*ttsMax;
  parameter Integer i=LoadAggregation.countAggPts(
      lvlBas=lvlBas,
      p_max=p_max,
      timFin=timFin,
      lenAggSte=tLoaAgg) "Number of aggregation points";
  parameter Real timSer[nrow + 1,2]=LoadAggregation.timSerMat(
      nbBor=borFieDat.conDat.nbBh,
      cooBor=borFieDat.conDat.cooBh,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      as=borFieDat.soiDat.alp,
      ks=borFieDat.soiDat.k,
      nrow=nrow,
      sha=SHAgfun,
      forceGFunCalc=forceGFunCalc,
      nbTimSho=nbTimSho,
      nbTimLon=nbTimLon,
      ttsMax=ttsMax)
    "g-function input from mat, with the second column as temperature Tstep";

  final parameter Modelica.SIunits.Time t0(fixed=false) "Simulation start time";
  final parameter Modelica.SIunits.Time[i] nu(fixed=false)
    "Time vector for load aggregation";
  final parameter Real[i] kappa(fixed=false)
    "Weight factor for each aggregation cell";
  final parameter Real[i] rCel(fixed=false) "Cell widths";
  Modelica.SIunits.HeatFlowRate[i] Q_i "Q_bar vector of size i";
  Modelica.SIunits.HeatFlowRate[i] Q_shift
    "Shifted Q_bar vector of size i";
  Integer curCel "Current occupied cell";
  Modelica.SIunits.TemperatureDifference deltaTb "Tb-Tg";
  Real delTbs "Wall temperature change from previous time steps";
  Real derDelTbs
    "Derivative of wall temperature change from previous time steps";
  Real delTbOld "Tb-Tg at previous time step";
  final parameter Real dhdt(fixed=false)
    "Time derivative of g/(2*pi*H*ks) within most recent cell";
protected
  Modelica.SIunits.HeatFlowRate QTot = Tb.Q_flow*borFieDat.conDat.nbBh "Totat heat flow from all boreholes";
  Modelica.SIunits.Heat U "Accumulated heat flow from all boreholes";
  discrete Modelica.SIunits.Heat UOld "Accumulated heat flow from all boreholes at last aggregation step";
initial equation
  Q_i = zeros(i);
  curCel = 1;
  deltaTb = 0;
  Q_shift = Q_i;
  delTbs = 0;
  U = 0;
  UOld = 0;

  (nu,rCel) = LoadAggregation.timAgg(
    i=i,
    lvlBas=lvlBas,
    p_max=p_max,
    lenAggSte=tLoaAgg,
    timFin=timFin);

  t0 = time;

  kappa = LoadAggregation.kapAgg(
    i=i,
    nrow=nrow,
    TStep=timSer,
    nu=nu);

  dhdt = kappa[1]/tLoaAgg;

equation
  der(deltaTb) = dhdt*QTot + derDelTbs;
  deltaTb = Tb.T-Tg;
  der(U) = QTot;

  when (sample(t0, tLoaAgg)) then
    (curCel,Q_shift) = LoadAggregation.nextTimeStep(
      i=i,
      Q_i=Q_i,
      rCel=rCel,
      nu=nu,
      curTim=(time - t0));

    UOld = U;
    Q_i = LoadAggregation.setCurLoa(
      i=i,
      Qb=(U-pre(UOld))/tLoaAgg,
      Q_shift=pre(Q_shift));

    delTbs = LoadAggregation.tempSuperposition(
      i=i,
      Q_i=Q_shift,
      kappa=kappa,
      curCel=curCel);

    delTbOld = Tb.T-Tg;

    derDelTbs = (delTbs-delTbOld)/tLoaAgg;
  end when;

  assert((time - t0) <= timFin,
    "The g-function input file does not cover the entire simulation length.");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,30},{58,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{72,-4},{-66,-4}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{94,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
            textString="%name")}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GroundTemperatureResponse;
