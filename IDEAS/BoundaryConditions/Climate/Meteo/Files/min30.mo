within IDEAS.BoundaryConditions.Climate.Meteo.Files;
model min30 "30-minute data"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Detail(filNam="_30.txt",
      timestep=1800);
end min30;
