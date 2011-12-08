within IDEAS.Elements.Meteo.Files;
model min5 "5-minute data"
  extends IDEAS.Elements.Meteo.Detail(filNam="..\\Inputs\\" + LocNam + "_5.txt",
      timestep=300);
end min5;
