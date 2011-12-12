within IDEAS.Climate.Meteo.Files;
model min30 "30-minute data"
  extends IDEAS.Climate.Meteo.Detail(filNam="..\\Inputs\\" + LocNam + "_30.txt",
      timestep=1800);
end min30;
