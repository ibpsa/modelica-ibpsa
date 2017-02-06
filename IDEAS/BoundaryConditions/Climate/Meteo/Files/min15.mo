within IDEAS.BoundaryConditions.Climate.Meteo.Files;
model min15 "15-minute data"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Detail(filNam="_15.txt",
      timestep=900);
end min15;
