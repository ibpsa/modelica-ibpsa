within IBPSA.Fluid.Geothermal.Aquifer.Validation;
model SimulationTest
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.CombiTimeTable
                                   combiTimeTable(table=[0.0,1; 86400*120,1; 86400
        *120,0; 86400*180,0.0; 86400*180,-1; 86400*300,-1])
    "Stages of operation"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = IBPSA.Media.Water,
    use_m_flow_in=true,
    T=393.15,
    nPorts=1) "Water mass flow rate"
              annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  SingleWell aquWel(
    redeclare package Medium = IBPSA.Media.Water,
    nVol=232,
    griFac=1.1,
    T_ini=307.15,
    TGro=307.15,
    aquDat=IBPSA.Fluid.Geothermal.Aquifer.Data.Rock())
    "Single well for aquifer thermal energy storage"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
equation
  connect(combiTimeTable.y[1], boundary.m_flow_in) annotation (Line(points={{-59,
          50},{-40,50},{-40,18},{-22,18}}, color={0,0,127}));
  connect(boundary.ports[1], aquWel.port_a)
    annotation (Line(points={{0,10},{50,10},{50,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000),
    __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Geothermal/Aquifer/Validation/SimulationTest.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This validation case simulates an idealized operation of an aquifer thermal storage system. Results
are compared with simulations from a test suite developed by Mindel et al. (2021). 
This test suite comprises a set of cases to assess the thermo-hydraulic modelling capabilities of various geothermal simulators. 
</p>
<p>
The comparison was carried out with respect to the test case called TC2 - well-test comparison. 
The main goal of TC2 is to compare aquifer temperatures under a typical operation of an ATES system 
consisting of injection, falloff, drawdown, and build-up. The injection phase represents the charging period, 
while the drawdown phase represents the discharge period. 
Intermediate phases of falloff and build-up represent periods of storage or inactivity. 
The overall operational period is one year, and the sequence of the different phases is the following:
</p>
<ul>
<li>Injection: Water is pumped at Q = 0.001 m<sup>3</sup> s<sup>-1</sup> and T<sub>inj</sub> = 120°C for 120 days.</li>
<li>Falloff: Well is shut-in, Q = 0 m<sup>3</sup> s<sup>-1</sup> for 60 days.</li>
<li>Drawdown: Water is pumped at Q = -0.001 m<sup>3</sup> s<sup>-1</sup> for 120 days.</li>
<li>Build-up phase: Well is shut-in, at Q = 0 m<sup>3</sup> s<sup>-1</sup> for 65.25.</li>
</ul>
The figure below shows the temperature vs. time comparison for a virtual sensor located at r = 1 m and r= 10 m from the well. 
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/Geothermal/Aquifer/results.png\" width=\"600\">
</p>
<h4>References</h4>
<p>
Julian E. Mindel, Peter Alt-Epping, Antoine Armandine Les Landes, Stijn Beernink, Daniel T. Birdsell, 
Martin Bloemendal, Virginie Hamm, Simon Lopez, Charles Maragna, Carsten M. Nielsen, Sebastia Olivella, 
Marc Perreaux, Maarten W. Saaltink, Martin O. Saar, Daniela Van den Heuvel, Rubén Vidal, Thomas Driesner,
<i>Benchmark study of simulators for thermo-hydraulic modelling of low enthalpy geothermal processes</i>,
Geothermics,
Volume 96,
2021,
102130,
ISSN 0375-6505,
https://doi.org/10.1016/j.geothermics.2021.102130.
</p>
</html>", revisions="<html>
<ul>
<li>
May 2023, by Alessandro Maccarini:<br/>
First Implementation.
</li>
</ul>
</html>"));
end SimulationTest;
