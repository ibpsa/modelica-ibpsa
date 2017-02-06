within IDEAS.BoundaryConditions.Climate.Meteo.Files;
model min5 "5-minute data"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Detail(filNam="_5.txt",
      timestep=300);
end min5;
