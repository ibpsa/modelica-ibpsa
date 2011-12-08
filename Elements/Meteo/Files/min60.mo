within IDEAS.Elements.Meteo.Files;
model min60 "60-minute data"
  extends IDEAS.Elements.Meteo.Detail(filNam="..\\Inputs\\" + LocNam +
        "_60.txt", timestep=3600);
end min60;
