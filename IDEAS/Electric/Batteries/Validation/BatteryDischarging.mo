within IDEAS.Electric.Batteries.Validation;
model BatteryDischarging
extends Modelica.Icons.Example;
Modelica.SIunits.Power Pnet=1000;
output Modelica.SIunits.Efficiency SoC = batterySystemGeneral.battery.SoC_out;

protected
  Distribution.AC.Grid_3P gridGeneral(redeclare
      IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
    traTCal=false,
    redeclare IDEAS.Electric.Data.TransformerImp.Transfo_100kVA transformer)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  AC.BatterySystemGeneral batterySystemGeneral(
    redeclare IDEAS.Electric.Data.Batteries.LiIon technology,
    SoC_start=0.6,
    Pnet=Pnet,
    EBat=10,
    DOD_max=0.8)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
public
  inner SimInfoManager       sim
    annotation (Placement(transformation(extent={{80,78},{100,98}})));
equation

  connect(gridGeneral.gridNodes3P[1, 2], batterySystemGeneral.pin[1])
    annotation (Line(
      points={{-60,-30.6667},{-29.6,-30.6667},{-29.6,-30},{0.4,-30}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
   Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p>Mathematical validation of battery discharging</p>
<p><h4><font color=\"#008000\">Expected result</font></h4></p>
<p>1h simulation: delta_soc = -10.204% (total discharging efficiency = 87.4% + self-discharge)</p>
</html>"));
end BatteryDischarging;
