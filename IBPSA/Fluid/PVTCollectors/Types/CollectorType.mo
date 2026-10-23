within IBPSA.Fluid.PVTCollectors.Types;
type CollectorType = enumeration(
    Covered "Covered collector",
    Uncovered "Uncovered collector")
  "Enumeration to define the type of PVT collector"
  annotation(Documentation(info="<html>
<p>
Enumeration used to define whether a PVT collector is covered (glazed)
or uncovered (unglazed).
</p>
</html>"));
