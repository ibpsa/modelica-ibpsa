within IDEAS.Interfaces.BaseClasses;
partial model HeatingSystem "Partial heating system"

  outer IDEAS.SimInfoManager         sim
    "Simulation information manager for climate data" annotation (Placement(transformation(extent={{-200,80},
            {-180,100}})));

// Building characteristics  //////////////////////////////////////////////////////////////////////////
  parameter Boolean floorHeating "true if the emission has a floor heating";
  parameter Boolean radiators "true if the emission has a radiator";

  parameter Integer nZones(min=1)
    "Number of conditioned thermal zones in the building";
  parameter Integer nEmb(min=1) = nZones
    "Number of embedded systems in the building, not used at the moment?";
  parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = ones(nZones)*5000
    "Nominal power, can be seen as the max power of the emission system";
  parameter Real[nZones] VZones "Conditioned volumes of the zones";
  final parameter Modelica.SIunits.HeatCapacity[nZones] C = 1012*1.204*VZones*5
    "Heat capacity of the conditioned zones";

// Electricity consumption or production  //////////////////////////////////////////////////////////////
  parameter Integer nLoads(min=1) = 1 "Number of electric loads";
  SI.Power[nLoads] P "Active power for each of the loads";
  SI.Power[nLoads] Q "Reactive power for each of the loads";

// Parameters DHW ///////////////////////////////////////////////////////////////////////////////////////
  parameter Integer nOcc = 2
    "number of occupants for determination of DHW consumption";

// Interfaces  ///////////////////////////////////////////////////////////////////////////////////////
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon if radiators
    "Nodes for convective heat gains" annotation (Placement(transformation(extent={{-210,10},
            {-190,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortRad if radiators
    "Nodes for radiative heat gains" annotation (Placement(transformation(extent={{-210,
            -30},{-190,-10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortEmb if floorHeating
    "Construction nodes for heat gains by embedded layers" annotation (Placement(transformation(extent={{-210,50},
            {-190,70}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug plugLoad( each m=1)
    "Electricity connection to the Inhome feeder" annotation (Placement(transformation(extent={{190,-10},
            {210,10}})));
  Modelica.Blocks.Interfaces.RealInput[nZones] TSensor
    "Sensor temperature of the zones" annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},
        rotation=180,
        origin={-204,-60})));
  Modelica.Blocks.Interfaces.RealInput[nZones] TSet
    "Setpoint temperature for the zones" annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={0,-104})));
  Electric.BaseClasses.WattsLawPlug wattsLawPlug(each numPha=1,nLoads=nLoads)
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Modelica.Blocks.Interfaces.RealInput mDHW60C
    "mFlow for domestic hot water, at 60 degC"  annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={60,-104})));

// Total heat use ///////////////////////////////////////////////////////////////////////////////////////
  SI.Power QHeatTotal "Total net heat use (space heating + DHW, if present)";

equation
  connect(wattsLawPlug.vi, plugLoad) annotation (Line(
      points={{190,0},{200,0}},
        color={85,170,255},
        smooth=Smooth.None));
P = wattsLawPlug.P;
Q = wattsLawPlug.Q;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},
            {200,100}}),
                  graphics={
        Polygon(
          points={{-46,-8},{-46,-20},{-44,-22},{-24,-10},{-24,2},{-26,4},{-46,-8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-46,-32},{-46,-44},{-44,-46},{-24,-34},{-24,-22},{-26,-20},{-46,
              -32}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-44,-18},{-50,-22},{-50,-46},{-46,-50},{28,-50},{42,-40}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,-46},{-44,-42}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,0},{-20,2},{-20,-32},{-16,-36},{-16,-36},{40,-36}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-24},{-20,-22}},
          color={127,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{40,-26},{40,-46},{50,-52},{58,-46},{58,-30},{54,-24},{48,-20},
              {40,-26}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid)}),                         Diagram(
        coordinateSystem(preserveAspectRatio=false,extent={{-200,-100},{200,100}}),
        graphics),
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
end HeatingSystem;
