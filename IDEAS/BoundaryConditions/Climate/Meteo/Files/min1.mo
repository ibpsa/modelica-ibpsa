within IDEAS.BoundaryConditions.Climate.Meteo.Files;
model min1 "1-minute data"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Detail(filNam="_1.txt",
      timestep=60);
end min1;
