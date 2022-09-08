within IBPSA.Utilities.IO.Strings;
model StringPassThrough
  StringInput u;
  StringOutput y;
equation
  connect(u, y);
  annotation (Documentation(info="<html>
<p>Model to pass trough any String.</p>
</html>"));
end StringPassThrough;
