within IDEAS.Templates.Heating.Examples;
model Heating_Embedded_DHW_STS
  "Example and test for heating system with embedded emission, DHW and STS"
  extends IDEAS.Templates.Heating.Examples.Heating_Embedded(
    redeclare IDEAS.Templates.Heating.Heating_Embedded_DHW_STS heating(
    nZones=nZones,
    dTSupRetNom=5,
    redeclare IDEAS.Fluid.Production.HP_AirWater_TSet heater,
    each RadSlaCha=radSlaCha_ValidationEmpa,
    TSupNom=273.15 + 45,
    corFac_val=5,
    AEmb=building.AZones,
    QNom={10000 for i in 1:nZones},
    nLoads=0,
    InInterface=false,
    Q_design=heating.QNom));


  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Model demonstrating the use of the embedded heating system template with storage.</p>
</html>",     revisions="<html>
<ul>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised implementation
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Heating/Examples/Heating_Embedded_DHW_STS.mos"
        "Simulate and Plot"));
end Heating_Embedded_DHW_STS;
