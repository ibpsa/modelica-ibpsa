within IDEAS.Buildings.Examples;
model InternalGainExample
  "Example model with and without internal gains model"
  extends Modelica.Icons.Example;
  inner BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  package MediumAir = IDEAS.Media.Air(extraPropertiesNames={"CO2"}, C_nominal={400*44/29/1e6});
  IDEAS.Buildings.Validation.Cases.Case900 case900_default(redeclare package MediumAir = MediumAir)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  IDEAS.Buildings.Validation.Cases.Case900 case900_gains(
    redeclare package MediumAir = MediumAir,
    building(gF(
        redeclare Components.OccupancyType.OfficeWork occTyp,
        redeclare Components.InternalGains.Simple intGai)))
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Pulse    occ(
    amplitude=1,
    period=3600*24,
    startTime=6*3600)                       "Occupancy: connected in code"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Modelica.Blocks.Sources.RealExpression ppm(y=case900_gains.building.gF.airModel.port_a.C_outflow[
        1]*29/44*1e6)
    annotation (Placement(transformation(extent={{-4,-54},{16,-34}})));
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
        "Simulate and plot"),
    experiment(StopTime=1e+06));
end InternalGainExample;
