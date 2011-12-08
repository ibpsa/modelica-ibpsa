within IDEAS.Elements.Meteo.Files;
model min1 "1-minute data"
  extends IDEAS.Elements.Meteo.Detail(filNam="..\\Inputs\\" + LocNam + "_1.txt",
      timestep=60);
end min1;
