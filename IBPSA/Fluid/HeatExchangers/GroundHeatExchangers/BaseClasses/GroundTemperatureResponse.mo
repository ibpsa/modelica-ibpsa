within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses;
model GroundTemperatureResponse "Model calculating discrete load aggregation"
  parameter Modelica.SIunits.ThermalConductivity ks
    "Thermal conductivity of soil";
  parameter Modelica.SIunits.ThermalDiffusivity as
    "Thermal diffusivity of soil";
  parameter Modelica.SIunits.Time lenAggSte
    "Load aggregation step (e.g. 3600 if every hour)";
  parameter String filNam "Filename for g-function data";
  parameter Integer p_max(min=1) "Number of cells per aggregation level";
  parameter Modelica.SIunits.Length H "Borehole vertical length";
  parameter Boolean prevQfromFile=false
    "= true, if external file is used to add load history prior to simulation start"
    annotation (Dialog(group="Previous load history"));
  parameter String prevQFilNam="NoName" "File where load history is stored"
    annotation (Dialog(
      group="Previous load history",
      enable=prevQfromFile,
      loadSelector(caption="Select load history file")));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tg
    "Heat port for ground conditions"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Tb
    "Heat port for resulting borehole wall conditions"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  parameter Integer prevQnrow = if prevQfromFile and prevQFilNam<>"NoName"
    and not Modelica.Utilities.Strings.isEmpty(prevQFilNam) then
      Modelica.Utilities.Streams.countLines(prevQFilNam) else 1
        "Number of lines in previous load history input file";
  parameter Integer nrow = Modelica.Utilities.Streams.countLines(filNam)
    "Number of lines in g-function input file";
  parameter Real lvlBas = 2 "Base for exponential cell growth between levels";
  parameter Modelica.SIunits.Time timFin = LoadAggregation.timSerFin(
    nrow=nrow,
    filNam=filNam,
    as=as,
    H=H) "Final time in g-function input file";
  parameter Integer i = LoadAggregation.countAggPts(
                                    lvlBas=lvlBas,
    p_max=p_max,
    timFin=timFin+prevTim,
    lenAggSte=lenAggSte) "Number of aggregation points";
  parameter Real timSer[nrow+1, 2]=
    LoadAggregation.timSerTxt(
      filNam=filNam,
      as=as,
      ks=ks,
      H=H,
      nrow=nrow)
      "g-function input from file, with the second column being Tstep";
  parameter Modelica.SIunits.Time prevTim = LoadHistory.prevQTim(
    prevQFilNam=prevQFilNam,
    prevQnrow=prevQnrow,
    prevQfromFile=prevQfromFile)
    "Aggregation time at start of simulation";
  parameter Modelica.SIunits.Time prevStart=
    if prevQfromFile and prevQFilNam<>"NoName"
    and not Modelica.Utilities.Strings.isEmpty(prevQFilNam) then
      Modelica.Utilities.Strings.scanReal(Modelica.Utilities.Streams.readLine(prevQFilNam,1))
    else 0
    "First time value in load history";

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
  Real delTbs;
  Real derDelTbs
    "Derivative of wall temperature change from previous time steps";
  Real delTbOld "Tb-Tg at previous time step";
  Real dhdt "Time derivative of g/(2*pi*H*ks) within most recent cell";
  Integer iLoaHis "Number of aggregation points in load history";

initial equation
  (Q_i, curCel, deltaTb) = LoadHistory.initQ(
    prevQFilNam=prevQFilNam,
    prevQnrow=prevQnrow,
    prevQfromFile=prevQfromFile,
    i=i,
    nu=nu,
    rCel=rCel,
    kappa=kappa,
    prevTim=prevTim,
    prevStart=prevStart,
    lenAggSte=lenAggSte,
    iCur=iLoaHis);
  Q_shift = Q_i;
  delTbs = 0;

equation
  when (initial()) then
    t0 = time;

    (nu,rCel) = LoadAggregation.timAgg(
      i=i,
      lvlBas=lvlBas,
      p_max=p_max,
      lenAggSte=lenAggSte,
      timFin=timFin);

    kappa = LoadAggregation.kapAgg(
      i=i,
      nrow=nrow,
      TStep=timSer,
      nu=nu);

    dhdt = kappa[1]/lenAggSte;

    iLoaHis = LoadHistory.loaHisPts(
      i=i,
      nu=nu,
      prevTim=prevTim);
  end when;

  Tb.Q_flow = -Tg.Q_flow;

  der(deltaTb) = dhdt*Tb.Q_flow + derDelTbs;
  deltaTb = Tb.T-Tg.T;

  when (sample(t0, lenAggSte)) then
    (curCel,Q_shift) = LoadAggregation.nextTimeStep(
      i=i,
      Q_i=pre(Q_i),
      rCel=rCel,
      nu=nu,
      curTim=(time - t0 + prevTim));

    Q_i = LoadAggregation.setCurLoa(
      i=i,
      Qb=Tb.Q_flow,
      Q_shift=Q_shift);

    delTbs = LoadAggregation.tempSuperposition(
      i=i,
      Q_i=Q_shift,
      kappa=kappa,
      curCel=curCel);

    delTbOld = Tb.T-Tg.T;

    derDelTbs = (delTbs-delTbOld)/lenAggSte;
  end when;

  assert((time - t0 + prevTim) <= timFin,
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
