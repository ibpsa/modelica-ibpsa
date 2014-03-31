within IDEAS.Controls.Control_fixme;
function Hysteresis_NoEvent "function for hysteresis without event"
  input Real u;
  input Real y_pre;
  input Real uLow;
  input Real uHigh;
  output Real y;
  // protected

  output Real y2;

algorithm
  if noEvent(u >= uLow) then
    if noEvent(y_pre < 0.5) then
      y := 0;
      y2 := 4;
    else
      y := 1;
      y2 := 3;
    end if;
  end if;

  if noEvent(u > uHigh) then
    y := 1;
    y2 := 1;
  end if;

  if noEvent(u < uLow) then
    y := 0;
    y2 := 2;
  end if;

end Hysteresis_NoEvent;
