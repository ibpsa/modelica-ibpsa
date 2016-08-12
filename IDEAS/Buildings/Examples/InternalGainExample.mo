within IDEAS.Buildings.Examples;
model InternalGainExample
  "Example model with and without internal gains model"
  extends Modelica.Icons.Example;
  inner BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  IDEAS.Buildings.Validation.Cases.Case900 case900_default
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  IDEAS.Buildings.Validation.Cases.Case900 case900_gains(building(gF(redeclare
          Components.OccupancyType.OfficeWork occTyp, redeclare
          Components.InternalGains.Simple intGai)))
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Constant occ(k=1) "Occupancy: connected in code"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
equation
  // connection for setting number of zone occupants
  connect(occ.y, case900_gains.building.gF.nOcc);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Model demonstrating the use of the comfort evaluation model.</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Examples/InternalGainExample.mos"
        "Simulate and plot"));
end InternalGainExample;
