within IDEAS.BoundaryConditions.Climate.Meteo.Files;
model min10 "10-minute data"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Detail(filNam="_10.txt",
      timestep=600);
end min10;
