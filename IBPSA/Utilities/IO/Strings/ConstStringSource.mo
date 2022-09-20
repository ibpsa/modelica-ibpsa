within IBPSA.Utilities.IO.Strings;
model ConstStringSource
  parameter String k;
  StringOutput y;
equation
  y = k;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Constant String value source.</p>
</html>"));
end ConstStringSource;
