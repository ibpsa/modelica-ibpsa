within IDEAS.Templates.BaseCircuits.Interfaces;
model ValveParametersReturn

  parameter IDEAS.Fluid.Types.CvTypes CvDataReturn=IDEAS.Fluid.Types.CvTypes.Kv
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient Return Valve"));
  parameter Real KvReturn(
    fixed= if CvDataReturn==IDEAS.Fluid.Types.CvTypes.Kv then true else false)
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]"
  annotation(Dialog(group = "Flow Coefficient Return Valve",
                    enable = (CvDataReturn==IDEAS.Fluid.Types.CvTypes.Kv)));

  parameter Real deltaMReturn = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));

end ValveParametersReturn;
