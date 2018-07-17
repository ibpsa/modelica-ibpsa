within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses;
partial model partialInternalResistances
  "Partial model to implement borehole segment resistance models"
  parameter Modelica.SIunits.Length hSeg
    "Length of the internal heat exchanger";
  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature of the filling material";
  parameter Data.BorefieldData.Template borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Modelica.SIunits.ThermalResistance Rgb_val
    "Thermal resistance between grout zone and borehole wall";
  parameter Modelica.SIunits.ThermalResistance RCondGro_val
    "Thermal resistance between: pipe wall to capacity in grout";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Boolean dynFil=true
      "Set to false to remove the dynamics of the filling material."
      annotation (Dialog(tab="Dynamics"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_1
    "Thermal connection for pipe 1"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    "Thermal connection for pipe 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_2
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
Partial model to implement the inner resistance network of a borehole segment.
</p>
<p>
The partial model uses a thermal port representing a uniform borehole wall for
that segment, and at least two other thermal ports (one for each tube going through the borehole
segment).
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialInternalResistances;
