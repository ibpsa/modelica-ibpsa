within IDEAS.Buildings.Validation.BaseClasses.Structure;
model Bui900 "BESTEST Building model case 900"

  extends IDEAS.Buildings.Validation.BaseClasses.Structure.Bui600(
    wall(redeclare each parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyWall constructionType,
         redeclare each parameter IDEAS.Buildings.Validation.Data.Insulation.foaminsulation insulationType,
         insulationThickness={0.0615,0.0615,0.0615,0.0615}),
    floor(redeclare final parameter IDEAS.Buildings.Validation.Data.Constructions.HeavyFloor constructionType,
          redeclare final parameter IDEAS.Buildings.Validation.Data.Insulation.insulation insulationType,
          insulationThickness=1.007));

   annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-150,
            -100},{150,100}}), graphics));
end Bui900;
