within IBPSA.Fluid.Sources.BaseClasses;
partial model PartialSource
  "Partial component source with one fluid connector"

  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));
  parameter Boolean verifyInputs = true
    " = false, to remove verification check of inputs"
    annotation(Dialog(tab="Advanced"));

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
      "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Boolean use_X_in = false
    "Get the composition (all fractions) from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(tab="Advanced"));
  parameter Boolean use_Xi_in = false
    "Get the composition (independent fractions) from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Medium.MassFraction X[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Fixed value of composition"
    annotation (Dialog(enable = (not use_X_in) and Medium.nXi > 0));
  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames) = fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Dialog(enable = (not use_C_in) and Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames) if use_X_in
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput Xi_in[Medium.nXi](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames) if use_Xi_in
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  Medium.BaseProperties medium if verifyInputs "Medium in the source";
  Modelica.Blocks.Interfaces.RealInput Xi_in_internal[Medium.nXi](
    each final unit = "kg/kg")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX](
    each final unit = "kg/kg")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Needed to connect to conditional connector";

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](redeclare each package
      Medium = Medium, m_flow(each max=if flowDirection == Modelica.Fluid.Types.PortFlowDirection.Leaving
           then 0 else +Modelica.Constants.inf, each min=if flowDirection == Modelica.Fluid.Types.PortFlowDirection.Entering
           then 0 else -Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{90,40},{110,-40}})));
protected
  parameter Modelica.Fluid.Types.PortFlowDirection flowDirection=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Allowed flow direction" annotation (Evaluate=true, Dialog(tab="Advanced"));
initial equation
  assert(not use_X_in or not use_Xi_in,
    "Cannot use both X and Xi inputs, choose either of the two.");

  if not use_X_in and not use_Xi_in then
    Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
      Medium.singleState, true, X_in_internal, "Boundary_pT");
  end if;

equation
  if use_X_in then
    Modelica.Fluid.Utilities.checkBoundary(Medium.mediumName, Medium.substanceNames,
      Medium.singleState, true, X_in_internal, "Boundary_pT");
  end if;
  connect(X_in[1:Medium.nXi], Xi_in_internal);
  connect(X_in,X_in_internal);
  connect(Xi_in, Xi_in_internal);
  connect(C_in, C_in_internal);
  if not use_X_in and not use_Xi_in then
    Xi_in_internal = X[1:Medium.nXi];
  end if;
  if not use_X_in then
    X_in_internal[1:Medium.nXi] = Xi_in_internal[1:Medium.nXi];
    X_in_internal[Medium.nX] = 1-sum(X_in_internal[1:Medium.nXi]);
  end if;
  if not use_C_in then
    C_in_internal = C;
  end if;
  // Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1,"
each ports[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");

    ports[i].Xi_outflow = Xi_in_internal;
    ports[i].C_outflow = C_in_internal;
  end for;
  connect(medium.Xi, Xi_in_internal);
  ports.C_outflow = fill(C_in_internal, nPorts);

  annotation (defaultComponentName="boundary", Documentation(info="<html>
<p>
Partial component to model the <b>volume interface</b> of a <b>source</b>
component, such as a mass flow source. The essential
features are:
</p>
<ul>
<li> The pressure in the connection port (= ports.p) is identical to the
     pressure in the volume.</li>
<li> The outflow enthalpy rate (= port.h_outflow) and the composition of the
     substances (= port.Xi_outflow) are identical to the respective values in the volume.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>"));
end PartialSource;
