within IDEAS.BoundaryConditions.Climate;
package Files

extends Modelica.Icons.Package;

  model min1 "1-minute data"
    extends IDEAS.BoundaryConditions.Climate.Files.Detail(filNam="_1.txt",
        timestep=60);
  end min1;

  model min10 "10-minute data"
    extends IDEAS.BoundaryConditions.Climate.Files.Detail(filNam="_10.txt",
        timestep=600);
  end min10;

  model min15 "15-minute data"
    extends IDEAS.BoundaryConditions.Climate.Files.Detail(filNam="_15.txt",
        timestep=900);
  end min15;

  model min30 "30-minute data"
    extends IDEAS.BoundaryConditions.Climate.Files.Detail(filNam="_30.txt",
        timestep=1800);
  end min30;

  model min5 "5-minute data"
    extends IDEAS.BoundaryConditions.Climate.Files.Detail(filNam="_5.txt",
        timestep=300);
  end min5;

  model min60 "60-minute data"
    extends IDEAS.BoundaryConditions.Climate.Files.Detail(filNam="_60.txt",
        timestep=3600);
  end min60;

  model Detail

    parameter String filNam;
    parameter Modelica.SIunits.Time timestep;

  end Detail;
end Files;
