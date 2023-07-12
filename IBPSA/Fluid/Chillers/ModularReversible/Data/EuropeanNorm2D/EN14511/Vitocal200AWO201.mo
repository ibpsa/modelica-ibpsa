within IBPSA.Fluid.Chillers.ModularReversible.Data.EuropeanNorm2D.EN14511;
record Vitocal200AWO201 "Vitocal200AWO201Chilling"
  extends IBPSA.Fluid.Chillers.ModularReversible.Data.EuropeanNorm2D.Generic(
    devIde="Vitocal200AWO201",
    tabPEle=[
      0,20,25,27,30,35;
      7,1380.0,1590.0,1680.0,1800.0,1970.0;
      18,950.0,1060.0,1130.0,1200.0,1350.0],
    tabQEva_flow=[
      0,20,25,27,30,35;
      7,2540.0,2440.0,2370.0,2230.0,2170.0;
      18, 5270.0,5060.0,4920.0,4610.0,4500.0],
    mCon_flow_nominal=3960/4180/5,
    mEva_flow_nominal=(2250*1.2)/3600,
    tabLowBou=[10,7; 45,7],
    use_TConOutForOpeEnv=false,
    use_TEvaOutForOpeEnv=false,
    use_conOut=true,
    use_evaOut=false);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Data record for type AWO-M/AWO-M-E-AC 201.A04,
  obtained from the technical guide in the UK.
</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end Vitocal200AWO201;
