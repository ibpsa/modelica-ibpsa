within IDEAS.Buildings.Validation.BaseClasses;
package InhomeFeeder

    extends Modelica.Icons.Package;

model None "None"

  extends IDEAS.Interfaces.InhomeFeeder;

  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p[nHeatingLoads]
    plugToPinHeatingLoad
    annotation (Placement(transformation(extent={{-60,30},{-80,50}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p[nVentilationLoads]
    plugToPinVentilationLoad
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Basic.PlugToPin_p[nOccupantLoads]
    plugToPinOccupantLoad
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));
equation
  connect(pinHeatingLoad, plugToPinHeatingLoad.pin_p) annotation (Line(
      points={{-100,40},{-72,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pinVentilationLoad, plugToPinVentilationLoad.pin_p) annotation (Line(
      points={{-100,0},{-72,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(pinOccupantLoad, plugToPinOccupantLoad.pin_p) annotation (Line(
      points={{-100,-40},{-72,-40}},
      color={85,170,255},
      smooth=Smooth.None));

for i in 1:nHeatingLoads loop
  connect(plugToPinHeatingLoad[i].plug_p, plugFeeder) annotation (Line(
      points={{-68,40},{16,40},{16,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
end for;
for j in 1:nVentilationLoads loop
  connect(plugToPinVentilationLoad[j].plug_p, plugFeeder) annotation (Line(
      points={{-68,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
end for;
for k in 1:nOccupantLoads loop
  connect(plugToPinOccupantLoad[k].plug_p, plugFeeder) annotation (Line(
      points={{-68,-40},{16,-40},{16,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
end for;
  annotation (Diagram(graphics));
end None;

end InhomeFeeder;
