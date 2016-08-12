within IDEAS.Buildings.Components.InternalGains;
model None "No occupancy: no heat, moisture, or CO2 gains"
  extends BaseClasses.PartialOccupancyGains(
                           final requireInput=false);
  Modelica.Blocks.Sources.Constant constWatFlow(final k=0)
    "Zero moisture being added"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.Constant constCflow[max(Medium.nC, 1)](final k=zeros(
        max(Medium.nC, 1))) "Zero value for trace substance mass flow rate"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow constQcon(final Q_flow=0,
      final alpha=0) "Zero convective sensible heat gains"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow constQrad(final Q_flow=0,
      final alpha=0) "Zero radiative sensible heat gains"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(constCflow.y, C_flow)
    annotation (Line(points={{11,20},{52,20},{106,20}},
                                                color={0,0,127}));
  connect(constWatFlow.y, mWat_flow)
    annotation (Line(points={{11,60},{106,60}}, color={0,0,127}));
  connect(constQcon.port, portCon)
    annotation (Line(points={{10,-20},{56,-20},{100,-20}}, color={191,0,0}));
  connect(constQrad.port, portRad)
    annotation (Line(points={{10,-60},{10,-60},{100,-60}}, color={191,0,0}));
  annotation (Documentation(info="<html>
</html>",
        revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>"));
end None;
