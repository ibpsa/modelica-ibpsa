within IDEAS.Elements.Meteo.Files;
model min15 "15-minute data"
  extends IDEAS.Elements.Meteo.Detail(filNam="..\\Inputs\\" + LocNam +
        "_15.txt", timestep=900);
end min15;
