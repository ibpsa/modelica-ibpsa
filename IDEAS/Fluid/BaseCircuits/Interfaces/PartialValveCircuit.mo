within IDEAS.Fluid.BaseCircuits.Interfaces;
model PartialValveCircuit

  // Extensions ----------------------------------------------------------------

  extends ValveParametersSupply(
      rhoStdSupply=Medium.density_pTX(101325, 273.15+4, Medium.X_default));
  extends PartialFlowCircuit(redeclare Actuators.BaseClasses.PartialTwoWayValve
      flowRegulator(
        Kv=KvSupply,
        rhoStd=rhoStdSupply,
        deltaM=deltaMSupply,
        CvData=IDEAS.Fluid.Types.CvTypes.Kv));

equation
  connect(flowRegulator.y_actual, power) annotation (Line(
      points={{5,67},{40,67},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Polygon(
          points={{-20,70},{-20,50},{0,60},{-20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,70},{20,50},{0,60},{20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,102},{6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Rectangle(
          extent={{-6,44},{6,32}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialValveCircuit;
