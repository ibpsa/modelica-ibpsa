within IDEAS.Thermal.Control;
model testControlMarijke
  input Real TInput;
  parameter Real TMax = 60;
  parameter Real dT = 10;
  Real onOff( start=1);
equation
  if TInput >= TMax then
    onOff = 0;
  elseif TInput >= TMax-dT and onOff < 0.5 then
    onOff = 0;
  else
    onOff = 1;
  end if;

end testControlMarijke;
