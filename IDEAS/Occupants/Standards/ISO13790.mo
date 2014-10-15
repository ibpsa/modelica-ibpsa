within IDEAS.Occupants.Standards;
model ISO13790
  extends IDEAS.Interfaces.BaseClasses.Occupant(nZones=1, nLoads=1);

  parameter Modelica.SIunits.Area[nZones] AFloor=ones(nZones)*100
    "Floor area of different zones";

protected
  final parameter Modelica.SIunits.Time interval=3600 "Time interval";
  final parameter Modelica.SIunits.Time period=86400/interval
    "Number of intervals per repetition";
  final parameter Real[3] QDay(unit="W/m2") = {8,20,2}
    "Specific power for dayzone";
  Integer t "Time interval";

algorithm
  when sample(0, interval) then
    t := if pre(t) + 1 <= period then pre(t) + 1 else 1;
  end when;

equation
  mDHW60C = 0;
  heatPortRad.Q_flow = heatPortCon.Q_flow;
  P = {heatPortCon[1].Q_flow + heatPortRad[1].Q_flow};
  Q = {0};

  if noEvent(t <= 7 or t >= 23) then
    heatPortCon.Q_flow = -AFloor*QDay[3]*0.5;
    TSet = ones(nZones)*(18 + 273.15);
  elseif noEvent(t > 7 and t <= 17) then
    heatPortCon.Q_flow = -AFloor*QDay[1]*0.5;
    TSet = ones(nZones)*(16 + 273.15);
  else
    heatPortCon.Q_flow = -AFloor*QDay[2]*0.5;
    TSet = ones(nZones)*(21 + 273.15);
  end if;

  annotation (Diagram(graphics));
end ISO13790;
