within IDEAS.Occupants;
package Standards

  extends Modelica.Icons.Package;

model ISO13790
  extends IDEAS.Interfaces.Occupant(          nZones=2,nLoads=2);

parameter Modelica.SIunits.Area[nZones] AFloor;

  protected
final parameter Modelica.SIunits.Time interval = 3600;
final parameter Modelica.SIunits.Time period = 86400/interval;
Integer t;

final parameter Real[3] QDay(unit="W/m2") = {8,20,2};
final parameter Real[3] QNight(unit="W/m2") = {1,1,6};

algorithm
when sample(0,interval) then
  t :=if pre(t) + 1 <= period then pre(t) + 1 else 1;
end when;

equation
heatPortRad.Q_flow = heatPortCon.Q_flow;
ohmsLaw.P = heatPortCon.Q_flow + heatPortRad.Q_flow;
ohmsLaw.Q = {0,0};

if noEvent(t <= 7 or t >= 23) then
  heatPortCon.Q_flow = -AFloor.*{QDay[3],QNight[3]}*0.5;
  TSet={16,18};
elseif noEvent(t > 7 and t <=17) then
  heatPortCon.Q_flow = -AFloor.*{QDay[1],QNight[1]}*0.5;
  TSet={16,16};
else
  heatPortCon.Q_flow = -AFloor.*{QDay[2],QNight[2]}*0.5;
  TSet={21,16};
end if;

end ISO13790;

end Standards;
