within IDEAS.Climate.Meteo.Files;
model min15 "15-minute data"
  extends IDEAS.Climate.Meteo.Detail(filNam="_15.txt", timestep=900);
end min15;
