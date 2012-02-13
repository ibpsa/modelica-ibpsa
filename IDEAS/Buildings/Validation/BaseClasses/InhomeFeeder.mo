within IDEAS.Buildings.Validation.BaseClasses;
package InhomeFeeder

    extends Modelica.Icons.Package;

model None "None"

  extends IDEAS.Interfaces.InhomeFeeder;

equation
for i in 1:nHeatingLoads loop
  connect(pinHeatingLoad[i], plugFeeder) annotation (Line(
      points={{-100,40},{0,40},{0,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
end for;
for j in 1:nVentilationLoads loop
  connect(pinVentilationLoad[j], plugFeeder) annotation (Line(
      points={{-100,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));

end for;
for k in 1:nOccupantLoads loop
  connect(pinOccupantLoad[k], plugFeeder) annotation (Line(
      points={{-100,-40},{0,-40},{0,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));

end for;

  annotation (Diagram(graphics));
end None;

end InhomeFeeder;
