within IDEAS.Climate.Meteo.Files;
model min1 "1-minute data"
  extends IDEAS.Climate.Meteo.Detail(filNam="..\\Inputs\\" + locNam + "_1.txt",
      timestep=60);
end min1;
