within Annex60.Fluid.MixingVolumes.Validation;
model TraceSubstanceConservationSteadyState
  "This test checks if trace substance mass flow rates are conserved when steady state"
  extends
    Annex60.Fluid.MixingVolumes.Validation.BaseClasses.TraceSubstanceConservation(
      sou(X={0,1}));
  Annex60.Utilities.Diagnostics.AssertEquality assEquTra2(threShold=1E-10,
      message="Measured trace quantities are not equal")
    "Assert equality of trace substances"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Annex60.Utilities.Diagnostics.AssertEquality assEquTra1(threShold=1E-10,
      message="Measured trace quantity does not equal set point")
    "Assert equality of trace substances"
    annotation (Placement(transformation(extent={{40,-48},{60,-68}})));
  Modelica.Blocks.Sources.Constant const(k=sou.m_flow*sou.C[1])
    "Set point of trace substance concentration"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(const.y, assEquTra1.u1) annotation (Line(
      points={{21,-70},{30,-70},{30,-64},{38,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra2.u1, senTraSubOut.C) annotation (Line(
      points={{38,-24},{30,-24},{30,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra2.u2, senTraSubIn.C) annotation (Line(
      points={{38,-36},{-50,-36},{-50,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra1.u2, senTraSubIn.C) annotation (Line(
      points={{38,-52},{-50,-52},{-50,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(Tolerance=1e-08),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This test checks if the trace substance flow rate is conserved 
when adding moisture to a mixing volume that is configured to steady state.<br />
The trace substance flow rate at the inlet and outlet should be equal 
since the trace substance concentration should not
be affected by the vapour concentration.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/TraceSubstanceConservationSteadyState.mos"
        "Simulate and plot"));
end TraceSubstanceConservationSteadyState;
