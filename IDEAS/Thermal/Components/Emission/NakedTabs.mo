within IDEAS.Thermal.Components.Emission;
model NakedTabs "HeatPort-only tabs system, without embedded pipe"

  replaceable parameter IDEAS.Thermal.Components.BaseClasses.FH_Characteristics
                                                                       FHChars     annotation (choicesAllMatching = true);

  parameter Integer n1 = FHChars.n1;
  parameter Integer n2 = FHChars.n2;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n1+1] U1(each G = FHChars.lambda_b / (FHChars.S_1 / (n1+1)) * FHChars.A_Floor)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,32})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n2+1] U2(each G = FHChars.lambda_b / (FHChars.S_2 / (n2+1)) * FHChars.A_Floor)
                                                               annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-22})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n1] C1(each C = FHChars.A_Floor * FHChars.S_1/n1 * FHChars.rho_b * FHChars.c_b,
    each T(fixed=false))
    annotation (Placement(transformation(extent={{32,54},{52,74}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n2] C2(each C = FHChars.A_Floor * FHChars.S_2/n2 * FHChars.rho_b * FHChars.c_b)
    annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portCore
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
  for i in 1:n1 loop
    connect(U1[i].port_b, U1[i+1].port_a);
    connect(U1[i].port_b, C1[i].port);
  end for;
  for i in 1:n2 loop
    connect(U2[i].port_b, U2[i+1].port_a);
    connect(U2[i].port_b, C2[i].port);
  end for;
  connect(U1[n1+1].port_b, port_a);
  connect(U2[n2+1].port_b, port_b);
  connect(portCore, U1[1].port_a) annotation (Line(
      points={{-100,0},{-6.12323e-016,0},{-6.12323e-016,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(portCore, U2[1].port_a) annotation (Line(
      points={{-100,0},{6.12323e-016,0},{6.12323e-016,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><b>Description</b> </p>
<p>Description of components, equations, reference links (references should be written in the user&apos;s Guide of the library) </p>
<p><h4>Assumptions and limitations </h4></p>
<p>(keep this section short and to the point, preferentially in bullets only)</p>
<p><ol>
<li>Description of assumptions used by the model (including tuned parameters which should not be modified by the user). </li>
<li>Description of the validity region of the model and interval of accuracy (if possible) </li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Which are the important, the tuning and the &QUOT;negligeable&QUOT; parameters. </li>
<li>What are the default value of the model and how have then been chosen. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>Description of the validation procedure and results </p>
<p><h4>Example (optional) </h4></p>
<p>Link to an example for the component and (optional) examples where the component is used. </p>
</html>"));
end NakedTabs;
