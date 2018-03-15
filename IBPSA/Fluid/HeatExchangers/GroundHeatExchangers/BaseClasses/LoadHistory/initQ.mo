within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadHistory;
function initQ "Initializes Q_i with previous load history, if applicable"
  extends Modelica.Icons.Function;

  input String prevQFilNam "File path to where matrix data is stored";
  input Integer prevQnrow "Number of lines in file";
  input Boolean prevQfromFile "Whether or not load history is used";
  input Integer i "Number of aggregation points";
  input Modelica.SIunits.Time nu[i] "Time vector for load aggregation";
  input Real rCel[i] "Cell widths";
  input Real kappa[i] "Weight factor for each aggregation cell";
  input Modelica.SIunits.Time prevTim "Aggregation time at start of simulation";
  input Modelica.SIunits.Time prevStart "First time value in load history";
  input Modelica.SIunits.Time lenAggSte "Load aggregation step (e.g. 3600 if every hour)";
  input Integer iCur "Number of aggregation points in load history";

  output Modelica.SIunits.HeatFlowRate Q_i[i] "Q_bar vector of size i";
  output Integer curCel "Current occupied cell";
  output Modelica.SIunits.TemperatureDifference deltaTb "Tb-Tg";

protected
  Modelica.SIunits.Time lBound, uBound;
  Real fq[iCur];

algorithm
  Q_i := zeros(i);
  curCel := 1;

  if prevQfromFile and prevQFilNam<>"NoName"
    and not Modelica.Utilities.Strings.isEmpty(prevQFilNam)
    and prevQnrow>1 then
      if nu[iCur]==prevTim then
        curCel:=iCur+1;
      else
        curCel:=iCur;
      end if;

    fq := interpolFile(
      filNam=prevQFilNam,
      nrow=prevQnrow,
      prevTim=prevTim,
      prevStart=prevStart,
      nu=nu,
      i=i,
      iCur=iCur);

      uBound := fq[1];
      if iCur>1 then
        for j in 1:(iCur-1) loop
          lBound := fq[j+1];

          Q_i[j] := (uBound-lBound)/(lenAggSte*rCel[j]);

          uBound := lBound;
        end for;
      end if;

      Q_i[iCur] := uBound/(lenAggSte*rCel[iCur]);
  end if;

  deltaTb :=
    LoadAggregation.tempSuperposition(
    i=i,
    Q_i=Q_i,
    kappa=kappa,
    curCel=curCel);
end initQ;
