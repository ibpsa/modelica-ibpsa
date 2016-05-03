within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
model AngleDay

Real day;
Real t;
Real N "year";

equation
N=(time-365*24*60*30)/60/60/24/365;
t=time-86400*N;
day=t/60/60/24/365.25*2*Modelica.Constants.pi-0.048869;

end AngleDay;
