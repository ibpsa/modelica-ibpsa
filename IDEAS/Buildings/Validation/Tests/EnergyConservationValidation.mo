within IDEAS.Buildings.Validation.Tests;
model EnergyConservationValidation
  "This example shows how conservation of energy can be checked."
  extends Components.Examples.ZoneExample(
    sim(computeConservationOfEnergy=true,
        strictConservationOfEnergy=true,
        Emax=1),
    zone(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    zone1(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

  annotation (
    experiment(
      StopTime=5e+06,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Validation/Tests/EnergyConservationValidation.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
June 14, 2015, Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConservationValidation;
