within Annex60.Experimental.Benchmarks.AirFlow.Examples;
model MultipleFloorsVectors
  "Test case for air flow between multiple floors in vector design"
  extends Modelica.Icons.Example;

  parameter Integer nZones(min=1) = 4 "Number of zone elements per floor";
  parameter Integer nFloors(min=2) = 2 "Number of floors";

  parameter Modelica.SIunits.Temperature TRoom = 298.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Temperature THallway = 293.15
    "Indoor air temperature of hallway in K";
  parameter Modelica.SIunits.Temperature TStaircase = 293.15
    "Indoor air temperature of staircase in K";
  parameter Modelica.SIunits.Height heightRooms = 3 "Height of rooms in m";

  parameter Modelica.SIunits.Length lengthZone = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthZone = 5 "Width of room in m";
  parameter Modelica.SIunits.Length widthHallway = 3 "Width of room in m";
  parameter Real doorOpening = 1
    "Opening of door (between 0:closed and 1:open)";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Components.Floor floor[nFloors](
    each nZones=nZones,
    each TRoom=TRoom,
    each THallway=THallway,
    each TStaircase=TStaircase,
    each heightRooms=heightRooms,
    each lengthZone=lengthZone,
    each widthZone=widthZone,
    each widthHallway=widthHallway,
    redeclare each package Medium = Medium,
    each forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Annex60/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  for i in 1:(nFloors-1) loop
    connect(floor[i].port_a_top, floor[i+1].port_a_bot);
    connect(floor[i].port_b_top, floor[i+1].port_b_bot);
  end for;
  for i in 1:(nFloors) loop
    connect(weaDat.weaBus, floor[i].weaBus1) annotation (Line(
      points={{-60,-30},{-14,-30},{-14,-20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>
February 2015 by Marcus Fuchs:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
A fully scalable air flow benchmark model
</p>
<h4>Typical use and important parameters</h4>
<p>
With nZones and nFloors, this vectorized model can be scaled to represent a 
simple building of any size.
</p>
<h4>Validation</h4>
<p>
This model still needs to be validated 
</p>
<h4>References</h4>
<p>
Inspired by Buildings.Airflow.Multizone.Examples.Validation3Rooms
</p>
</html>"));
end MultipleFloorsVectors;
