within IDEAS.Controls.Control_fixme;
block MinOnTimer_Events "MinOnTimer that works (and has events)"
  extends Modelica.Blocks.Interfaces.SISO(y(start=0));

  parameter Modelica.SIunits.Time duration=0;

protected
  Modelica.SIunits.Time start(start=0);
algorithm
  if duration <= 0 then
    y := 0;
  else
    when u > 0.5 then
      if y < 0.5 then
        start := time;
        y := 1;
      end if;
    elsewhen time >= start + duration then
      y := 0;
      start := 0;
    end when;
  end if;

end MinOnTimer_Events;
