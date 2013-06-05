within IDEAS.Thermal.Control;
model Ctrl_Heating "Basic heating curve control for heater and mixing valve"
  extends Interfaces.Partial_Ctrl_Heating;

equation
  THeaterSet = heatingCurve.TSup + dTHeaterSet;
  connect(heatingCurve.TSup, THeaCur) annotation (Line(
      points={{1,56},{24,56},{24,40},{104,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},
            {100,80}}), graphics));
end Ctrl_Heating;
