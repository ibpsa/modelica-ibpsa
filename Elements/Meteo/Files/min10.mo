within IDEAS.Elements.Meteo.Files;
model min10 "10-minute data"
  extends IDEAS.Elements.Meteo.Detail(filNam="..\\Inputs\\" + LocNam +
        "_10.txt", timestep=600);
end min10;
