within Annex60.Fluid.Examples.FlowSystem;
model Simplified5 "Removed most mass/energy dynamics"
  extends Simplified4(
    spl1(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, massDynamics
        =Modelica.Fluid.Types.Dynamics.SteadyState),
    spl(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, massDynamics=
          Modelica.Fluid.Types.Dynamics.SteadyState),
    spl2(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, massDynamics
        =Modelica.Fluid.Types.Dynamics.SteadyState),
    spl3(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState, massDynamics
        =Modelica.Fluid.Types.Dynamics.SteadyState),
    pumpCoo(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    pumpHea(energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
        massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState),
    heater(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
  annotation (Documentation(info="<html>
<p>
The model is further simplified: mass dynamics and energy dynamics of most models were set to steady state.
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Simplified5;
