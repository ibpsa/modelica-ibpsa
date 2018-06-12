within IDEAS.Templates;
package Examples "Models for testing heating systems "
extends Modelica.Icons.ExamplesPackage;
  model ConstantAirFlowRecup
    "Example of model with ventilation system"
    extends Modelica.Icons.Example;
    inner IDEAS.BoundaryConditions.SimInfoManager sim
      "Simulation information manager for climate data"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

    package Medium = IDEAS.Media.Air "Air medium";

    IDEAS.Templates.Structure.ThreeZone structure(
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-80,-40},{-50,-20}})));
    replaceable IDEAS.Templates.Ventilation.ConstantAirFlowRecup constantAirFlowRecup(
      n=2.*structure.VZones)
    constrainedby IDEAS.Templates.Interfaces.BaseClasses.VentilationSystem(
      nZones=3,
      VZones=structure.VZones,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-38,-10},{-2,8}})));
    IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder causalInhomeFeeder
      annotation (Placement(transformation(extent={{16,-10},{36,10}})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
      voltageSource(
      f=50,
      V=230,
      phi=0,
      gamma(fixed=true)) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={58,-30})));
    Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
      annotation (Placement(transformation(extent={{48,-80},{68,-60}})));

  equation
    connect(voltageSource.pin_p, ground.pin) annotation (Line(
        points={{58,-40},{58,-60}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(causalInhomeFeeder.pinSingle, voltageSource.pin_n) annotation (Line(
        points={{36,0},{58,0},{58,-20}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(constantAirFlowRecup.plugLoad, causalInhomeFeeder.nodeSingle)
      annotation (Line(
        points={{-2,-1},{0,-1},{0,0},{16,0}},
        color={85,170,255},
        smooth=Smooth.None));
    connect(structure.TSensor, constantAirFlowRecup.TSensor) annotation (Line(
        points={{-49.4,-36},{-42,-36},{-42,-6.4},{-38.36,-6.4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(structure.port_b, constantAirFlowRecup.port_a) annotation (Line(
          points={{-67,-20},{-68,-20},{-68,0.8},{-38,0.8}}, color={0,127,255}));
    connect(structure.port_a, constantAirFlowRecup.port_b) annotation (Line(
          points={{-63,-20},{-64,-20},{-64,-2.8},{-38,-2.8}}, color={0,127,255}));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})),
      Documentation(info="<html>
<p>
Model demonstrating the use of the ventilation system template.
</p>
</html>",       revisions="<html>
<ul>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised implementation
</li>
</ul>
</html>"),
      __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Examples/ConstantAirFlowRecup.mos"
          "Simulate and Plot"),
      experiment(
        StopTime=2000000,
        Tolerance=1e-06,
        __Dymola_Algorithm="Lsodar"));
  end ConstantAirFlowRecup;

  model IdealFloorHeating "Model with idealised floor heating"
    extends IDEAS.Templates.Examples.BaseClasses.SimpleHeatingsystem(redeclare
        Heating.IdealFloorHeating heating, redeclare
        Structure.Case900FloorHeating structure);
  equation
    connect(structure.heatPortEmb,
      heating.heatPortEmb) annotation (Line(points={{-20,17.6},{0,17.6},{0,17.6},
            {20,17.6}}, color={191,0,0}));
    annotation (Documentation(revisions="<html>
<ul>
<li>
June 8, 2018 by Filip Jorissen:<br/>
First implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
</ul>
</html>"), experiment(
        StopTime=100000,
        Tolerance=1e-06,
        __Dymola_Algorithm="Lsodar"),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/Templates/Examples/IdealFloorHeating.mos"
          "Simulate and plot"));
  end IdealFloorHeating;

  model IdealRadiatorHeating "Example and test for ideal heating with radiators"
    extends IDEAS.Templates.Examples.BaseClasses.SimpleHeatingsystem(redeclare
        Heating.IdealRadiatorHeating heating);

  equation
    connect(structure.heatPortRad,
      heating.heatPortRad) annotation (Line(points={{-20,8.8},{0,8.8},{0,8.8},{
            20,8.8}}, color={191,0,0}));
    connect(structure.heatPortCon,
      heating.heatPortCon) annotation (Line(points={{-20,13.2},{0,13.2},{0,13.2},
            {20,13.2}}, color={191,0,0}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})),
      experiment(
        StopTime=100000,
        Tolerance=1e-06,
        __Dymola_Algorithm="Lsodar"),
      __Dymola_experimentSetupOutput,
      Documentation(info="<html>
<p>
Model that demonstrates the use of the 
<a href=\"modelica://IDEAS.Templates.Heating.IdealRadiatorHeating\">
IDEAS.Templates.Heating.IdealRadiatorHeating</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
June 5, 2018 by Filip Jorissen:<br/>
Cleaned up implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised
</li>
</ul>
</html>"),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/Templates/Examples/IdealRadiatorHeating.mos"
          "Simulate and Plot"));
  end IdealRadiatorHeating;

  model NoVentilation
    "Example of model without ventilation system"
    extends IDEAS.Templates.Examples.ConstantAirFlowRecup(
      redeclare IDEAS.Templates.Ventilation.None constantAirFlowRecup);
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics),
      Documentation(info="<html>
<p>
Model demonstrating the use of the ventilation system template 
by redeclaring the ventilation model of 
<a href=modelica://IDEAS.Templates.Ventilation.Examples.ConstantAirFlowRecup>ConstantAirFlowRecup</a>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised implementation
</li>
</ul>
</html>"),
  __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Examples/NoVentilation.mos"
          "Simulate and Plot"),
      experiment(
        StopTime=2000000,
        Tolerance=1e-06,
        __Dymola_Algorithm="Lsodar"));
  end NoVentilation;

  model RadiatorHeating "Model with radiator heating"
    extends IDEAS.Templates.Examples.IdealRadiatorHeating(
    redeclare IDEAS.Templates.Heating.RadiatorHeating heating);
    annotation (Documentation(revisions="<html>
<ul>
<li>
June 8, 2018 by Filip Jorissen:<br/>
First implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
</ul>
</html>"),
      experiment(
        StopTime=100000,
        Tolerance=1e-06,
        __Dymola_Algorithm="Lsodar"),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/Templates/Examples/RadiatorHeating.mos"
          "Simulate and plot"));
  end RadiatorHeating;

  model TemplateExample
    extends IDEAS.Templates.Interfaces.Building(
      redeclare Structure.ThreeZone building,
      redeclare Templates.Ventilation.None ventilationSystem,
      redeclare BoundaryConditions.Occupants.Standards.None occupant,
      redeclare Templates.Heating.None heatingSystem,
      redeclare Interfaces.BaseClasses.CausalInhomeFeeder inHomeGrid);

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end TemplateExample;

  package BaseClasses
    extends Modelica.Icons.BasesPackage;
    partial model SimpleHeatingsystem
      "Example model of a structure coupled to a heating system"
      extends Modelica.Icons.Example;
      inner IDEAS.BoundaryConditions.SimInfoManager sim
        annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

      final parameter Integer nZones=structure.nZones "Number of zones";
      replaceable IDEAS.Templates.Heating.BaseClasses.HysteresisHeating heating
        constrainedby IDEAS.Templates.Heating.BaseClasses.HysteresisHeating(
        final nZones=nZones,
        QNom={2000 for i in 1:nZones},
        Q_design=structure.Q_design) annotation (choicesAllMatching=true, Placement(
            transformation(extent={{20,0},{60,22}})));
      replaceable IDEAS.Templates.Structure.Case900 structure constrainedby
        IDEAS.Templates.Interfaces.BaseClasses.Structure "Building structure"
        annotation (Placement(transformation(extent={{-54,0},{-20,22}})),
          __Dymola_choicesAllMatching=true);

      Modelica.Blocks.Sources.Constant TSet(k=273.15 + 22)
        "Temperature set point for zone"
        annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    equation
      connect(structure.TSensor, heating.TSensor) annotation (Line(
          points={{-19.32,4.4},{19.6,4.4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(TSet.y, heating.TSet[1])
        annotation (Line(points={{21,-30},{40,-30},{40,-0.22}}, color={0,0,127}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}})),
        experiment(
          StopTime=200000,
          Interval=900,
          Tolerance=1e-06,
          __Dymola_Algorithm="Lsodar"),
        __Dymola_experimentSetupOutput,
        Documentation(info="<html>
<p>
Model that demonstrates the use of the 
<a href=\"modelica://IDEAS.Templates.Heating.IdealRadiatorHeating\">
IDEAS.Templates.Heating.IdealRadiatorHeating</a>.
</p>
</html>",         revisions="<html>
<ul>
<li>
June 5, 2018 by Filip Jorissen:<br/>
Cleaned up implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised
</li>
</ul>
</html>"),
        __Dymola_Commands);
    end SimpleHeatingsystem;
  end BaseClasses;
end Examples;
