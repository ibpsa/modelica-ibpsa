within IDEAS.Interfaces.BaseClasses;
partial model PartialSystem "General partial for electricity-based systems"

  outer IDEAS.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));

  // --- Electrical
  parameter Integer nLoads(min=0) = 1
    "Number of electric loads. If zero, all electric equations disappear.";
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug
    plugLoad(m=1) if nLoads >= 1 "Electricity connection to the Inhome feeder"
    annotation (Placement(transformation(extent={{190,-10},{210,10}})));
  IDEAS.Electric.BaseClasses.AC.WattsLawPlug wattsLawPlug(each numPha=1, final nLoads=
        nLoads) if nLoads >= 1
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));

  // --- Sensor

  final parameter Integer nLoads_min=max(1, nLoads);
  Modelica.SIunits.Power[nLoads_min] P "Active power for each of the loads";
  Modelica.SIunits.Power[nLoads_min] Q "Passive power for each of the loads";
  Modelica.Blocks.Sources.RealExpression[nLoads_min] P_val(y=P)
    annotation (Placement(transformation(extent={{144,-5},{164,15}})));
  Modelica.Blocks.Sources.RealExpression[nLoads_min] Q_val(y=Q)
    annotation (Placement(transformation(extent={{144,-20},{164,0}})));
equation
  if nLoads >= 1 then
    connect(wattsLawPlug.vi, plugLoad) annotation (Line(
        points={{190,0},{200,0}},
        color={85,170,255},
        smooth=Smooth.None));
  end if;
  connect(P_val.y, wattsLawPlug.P) annotation (Line(
      points={{165,5},{174,5}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Q_val.y, wattsLawPlug.Q) annotation (Line(
      points={{165,-10},{170,-10},{170,1},{173,1}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
            100}}),     graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Interface model for a complete multi-zone heating system (with our without domestic hot water and solar system).</p>
<p>This model defines the ports used to link a heating system with a building, and the basic parameters that most heating systems will need to have. The model is modular as a function of the number of zones <i>nZones. </i></p>
<p>Two sets of heatPorts are defined:</p>
<p><ol>
<li><i>heatPortCon[nZones]</i> and <i>heatPortRad[nZones]</i> for convective respectively radiative heat transfer to the building. </li>
<li><i>heatPortEmb[nZones]</i> for heat transfer to TABS elements in the building. </li>
</ol></p>
<p>The model also defines <i>TSensor[nZones]</i> and <i>TSet[nZones]</i> for the control, and a nominal power <i>QNom[nZones].</i></p>
<p>There is also an input for the DHW flow rate, <i>mDHW60C</i>, but this can be unconnected if the system only includes heating and no DHW.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>See the different extensions of this model in <a href=\"modelica://IDEAS.Thermal.HeatingSystems\">IDEAS.Thermal.HeatingSystems</a></li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Connect the heating system to the corresponding heatPorts of a <a href=\"modelica://IDEAS.Interfaces.BaseClasses.Structure\">structure</a>. </li>
<li>Connect <i>TSet</i> and <i>TSensor</i> and <i>plugLoad. </i></li>
<li>Connect <i>plugLoad </i> to an inhome grid.  A<a href=\"modelica://IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder\"> dummy inhome grid like this</a> has to be used if no inhome grid is to be modelled. </li>
<li>Set all parameters that are required, depending on which implementation of this interface is used. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>No validation performed.</p>
<p><h4>Example </h4></p>
<p>See the <a href=\"modelica://IDEAS.Thermal.HeatingSystems.Examples\">heating system examples</a>. </p>
</html>"));
end PartialSystem;
