within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadHistory;
function interpolFile
  "Interpolate accumulated energy in external file without storing its contents"
  extends Modelica.Icons.Function;

  input String filNam "File path to where data is stored";
  input Integer nrow "Number of lines in input file";
  input Modelica.SIunits.Time prevTim "Aggregation time at start of simulation";
  input Modelica.SIunits.Time prevStart "First time value in load history";
  input Modelica.SIunits.Time nu[i] "Time vector for load aggregation";
  input Integer i "Number of aggregation points";
  input Integer iCur "Number of points to evaluate";

  output Real interpol[iCur] "Interpolated values";

protected
  Integer curLin;
  Integer nextIndex;
  Boolean foundLin;
  String strLine1, strLine2;
  Real t1, t2, y1, y2, fq, tInterp;
  Integer nuCur;

algorithm
  curLin:=1;
  foundLin:=false;
  fq:=0;
  nuCur := iCur;

  if iCur>1 then
    tInterp:=nu[iCur-1];
  else
    tInterp:=0;
  end if;
  tInterp := (prevStart+prevTim)-tInterp;

  while curLin<nrow and not foundLin loop
    if curLin==1 then
      strLine1 := Modelica.Utilities.Streams.readLine(filNam,curLin);
      (t1, nextIndex) := Modelica.Utilities.Strings.scanReal(strLine1);
      y1 := Modelica.Utilities.Strings.scanReal(strLine1, nextIndex);
    else
      y1 := y2;
      t1 := t2;
    end if;

    //strLine2 := Modelica.Utilities.Streams.readLine(filNam,curLin+1);
    //(t2, nextIndex) := Modelica.Utilities.Strings.scanReal(strLine2);
    //y2 := Modelica.Utilities.Strings.scanReal(strLine2, nextIndex);
    (t2,y2) := readLineHistory(filNam=filNam, lin=curLin + 1);

    if t1<=tInterp and t2>=tInterp then
      interpol[nuCur] := fq + y1*(tInterp-t1);

      if nuCur>1 then
        nuCur:=nuCur-1;
        if nuCur>1 then
          tInterp:=nu[nuCur-1];
        else
          tInterp:=0;
        end if;
        tInterp := (prevStart+prevTim)-tInterp;
      else
        foundLin:=true;
      end if;
    end if;
    fq := fq+y1*(t2-t1);

    curLin:=curLin+1;
  end while;

  assert(foundLin, "Could not interpolate in range provided by load history file");
end interpolFile;
