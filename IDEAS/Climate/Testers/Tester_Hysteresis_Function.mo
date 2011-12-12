within IDEAS.Climate.Testers;
model Tester_Hysteresis_Function
  constant Modelica.SIunits.Temperature TStart=300;
  constant Modelica.SIunits.Temperature TStep=100;
  parameter Modelica.SIunits.Temperature TEnd=TStart + TStep*(1 - exp(-1));
  Real y(start = 0);
equation
  y = IDEAS.Climate.General.Hysteresis_NoEvent(
    355,
    1,
    TStart + TStep/2,
    TEnd);

end Tester_Hysteresis_Function;
