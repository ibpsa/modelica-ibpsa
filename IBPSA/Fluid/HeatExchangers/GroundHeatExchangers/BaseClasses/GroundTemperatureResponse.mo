within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses;
model GroundTemperatureResponse "Model calculating discrete load aggregation"
  parameter String filNam "Filename for g-function data";
  parameter Integer p_max(min=1) "Number of cells per aggregation level";

  replaceable parameter
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records.BorefieldData
    bfData constrainedby
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records.BorefieldData
    "Record containing all the parameters of the borefield model" annotation (
     choicesAllMatching=true, Placement(transformation(extent={{-90,-88},{-70,
            -68}})));

  Modelica.Blocks.Interfaces.RealInput Tg
    "Temperature input for undisturbed ground conditions"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tb
    "Heat port for resulting borehole wall conditions"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  parameter Integer nrow = Modelica.Utilities.Streams.countLines(filNam)
    "Number of lines in g-function input file";
  parameter Real lvlBas = 2 "Base for exponential cell growth between levels";
  parameter Modelica.SIunits.Time timFin = LoadAggregation.timSerFin(
    nrow=nrow,
    filNam=filNam,
    as=bfData.soi.alp,
    H=bfData.gen.hBor) "Final time in g-function input file";
  parameter Integer i = LoadAggregation.countAggPts(
    lvlBas=lvlBas,
    p_max=p_max,
    timFin=timFin,
    lenAggSte=bfData.gen.tStep) "Number of aggregation points";
  parameter Real timSer[nrow+1, 2]=
    LoadAggregation.timSerTxt(
      filNam=filNam,
      as=bfData.soi.alp,
      ks=bfData.soi.k,
      H=bfData.gen.hBor,
      nrow=nrow)
      "g-function input from file, with the second column being Tstep";

  Modelica.SIunits.Time t0 "Simulation start time";
  Modelica.SIunits.Time nu[i] "Time vector for load aggregation";
  Real kappa[i]
    "Weight factor for each aggregation cell";
  Real rCel[i] "Cell widths";
  Modelica.SIunits.HeatFlowRate Q_i[i] "Q_bar vector of size i";
  Modelica.SIunits.HeatFlowRate Q_shift[i]
    "Shifted Q_bar vector of size i";
  Integer curCel "Current occupied cell";
  Modelica.SIunits.TemperatureDifference deltaTb "Tb-Tg";
  Real delTbs "Wall temperature change from previous time steps";
  Real derDelTbs
    "Derivative of wall temperature change from previous time steps";
  Real delTbOld "Tb-Tg at previous time step";
  Real dhdt "Time derivative of g/(2*pi*H*ks) within most recent cell";

initial equation
  Q_i = zeros(i);
  curCel = 1;
  deltaTb = 0;
  Q_shift = Q_i;
  delTbs = 0;

equation
  when (initial()) then
    t0 = time;

    (nu,rCel) = LoadAggregation.timAgg(
      i=i,
      lvlBas=lvlBas,
      p_max=p_max,
      lenAggSte=bfData.gen.tStep,
      timFin=timFin);

    kappa = LoadAggregation.kapAgg(
      i=i,
      nrow=nrow,
      TStep=timSer,
      nu=nu);

    dhdt = kappa[1]/bfData.gen.tStep;
  end when;

  der(deltaTb) = dhdt*Tb.Q_flow + derDelTbs;
  deltaTb = Tb.T-Tg;

  when (sample(t0, bfData.gen.tStep)) then
    (curCel,Q_shift) = LoadAggregation.nextTimeStep(
      i=i,
      Q_i=pre(Q_i),
      rCel=rCel,
      nu=nu,
      curTim=(time - t0));

    Q_i = LoadAggregation.setCurLoa(
      i=i,
      Qb=Tb.Q_flow,
      Q_shift=Q_shift);

    delTbs = LoadAggregation.tempSuperposition(
      i=i,
      Q_i=Q_shift,
      kappa=kappa,
      curCel=curCel);

    delTbOld = Tb.T-Tg;

    derDelTbs = (delTbs-delTbOld)/bfData.gen.tStep;
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
