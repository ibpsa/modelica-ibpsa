within Annex60.Fluid.Movers.Validation;
model PowerExact
  extends PowerSimplified(
    pump_dp(redeclare replaceable parameter Data.Pumps.Wilo.Stratos30slash1to8 per),
    pump_m_flow(redeclare replaceable parameter
        Data.Pumps.Wilo.Stratos30slash1to8                                         per));
  annotation (
    experiment(StopTime=200),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/Movers/Validation/PowerExact.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
March 2, 2016, by Filip Jorissen:<br/>
First implementation for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
</ul>
</html>", info="<html>
fixme: needs documentation.
</html>"));
end PowerExact;
