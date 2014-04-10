within IDEAS.Controls.Control_fixme;
block MinOffTimer_Events "MinOffTimer that works (and has events)"
  extends Modelica.Blocks.Interfaces.SISO(y(start=1));

  parameter Modelica.SIunits.Time duration=0;

  //protected
  output Modelica.SIunits.Time start(start=0);
algorithm
  if duration <= 0 then
    y := 1;
  else
    when u < 0.5 then
      if y > 0.5 then
        start := time;
        y := 0;
      else
        y := 1;
      end if;
    end when;
    when time >= start + duration then
      y := 1;
      start := 0;
    end when;
  end if;

end MinOffTimer_Events;
