within IDEAS.Climate.Meteo.Files;
model min60 "60-minute data"
  extends IDEAS.Climate.Meteo.Detail(filNam="_60.txt", timestep=3600);
end min60;
