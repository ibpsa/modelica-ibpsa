within IDEAS.BoundaryConditions.Examples;
model SimInfoManager "Unit test for SimInfoManager"
  import IDEAS;
  extends Modelica.Icons.Example;
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  annotation (
    experiment(StopTime=1e+06),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/BoundaryConditions/Examples/SimInfoManager1.mos"
        "Unit test 1", file(inherit=true) =
        "Resources/Scripts/Dymola/BoundaryConditions/Examples/SimInfoManager2.mos"
        "Unit test 2"),
    Documentation(revisions="<html>
<ul>
<li>
September 22, 2016 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimInfoManager;
