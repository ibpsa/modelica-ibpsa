within IDEAS.Elements.Meteo.Files;
model min30 "30-minute data"
  extends IDEAS.Elements.Meteo.Detail(filNam="..\\Inputs\\" + LocNam +
        "_30.txt", timestep=1800);
end min30;
