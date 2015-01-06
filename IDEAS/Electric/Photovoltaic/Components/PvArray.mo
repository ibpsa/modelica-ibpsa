within IDEAS.Electric.Photovoltaic.Components;
class PvArray

  parameter Real amount=2;
  parameter Real inc=34 "inclination";
  parameter Real azi=0 "azimuth";
  replaceable parameter IDEAS.Electric.Data.Interfaces.PvPanel pvPanel
    "Choose a Photovoltaic panel to be used"
    annotation (choicesAllMatching=true);
  extends IDEAS.Electric.Photovoltaic.Components.DCgen;

  IDEAS.Climate.Meteo.Solar.RadSol radSol(
    azi=azi,
    inc=inc,
    A=1) annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.refraction refDir
    annotation (Placement(transformation(extent={{-8,20},{12,40}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.refraction refDif
    annotation (Placement(transformation(extent={{-8,-4},{12,16}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.refraction refRef
    annotation (Placement(transformation(extent={{-8,-26},{12,-6}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.incidenceAngles
    incidenceAngles(azi=azi, inc=inc)
    annotation (Placement(transformation(extent={{-38,20},{-18,40}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.absorption absorption
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.PV5 PV5(pvPanel=pvPanel)
    annotation (Placement(transformation(extent={{48,20},{68,40}})));
  IDEAS.Electric.Photovoltaic.Components.Elements.PvSerie pvSerie(amount=amount)
    annotation (Placement(transformation(extent={{72,20},{92,40}})));
  Modelica.Blocks.Math.Cos cos
    annotation (Placement(transformation(extent={{-68,36},{-60,44}})));
  Modelica.Blocks.Math.Cos cos1
    annotation (Placement(transformation(extent={{-68,24},{-60,32}})));
  Modelica.Blocks.Math.Cos cos2
    annotation (Placement(transformation(extent={{-68,12},{-60,20}})));
equation
  connect(incidenceAngles.angIncDir, refDir.angInc) annotation (Line(
      points={{-18,36},{-8,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incidenceAngles.angIncDif, refDif.angInc) annotation (Line(
      points={{-18,32},{-14,32},{-14,12},{-8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incidenceAngles.angIncRef, refRef.angInc) annotation (Line(
      points={{-18,28},{-16,28},{-16,-10},{-8,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(refDir.IncAngMod, absorption.IamDir) annotation (Line(
      points={{12,36},{22,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(refDif.IncAngMod, absorption.IamDif) annotation (Line(
      points={{12,12},{16,12},{16,32},{22,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(refRef.IncAngMod, absorption.IamRef) annotation (Line(
      points={{12,-10},{18,-10},{18,28},{22,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDir, absorption.solDir) annotation (Line(
      points={{-80,60},{34,60},{34,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, absorption.solDif) annotation (Line(
      points={{-80,56},{38,56},{38,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(absorption.solAbs, PV5.solAbs) annotation (Line(
      points={{42,36},{48,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(absorption.T, PV5.T) annotation (Line(
      points={{42,32},{48,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PV5.pin, pvSerie.pinCel) annotation (Line(
      points={{68,36},{72,36}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pvSerie.pinSer, p) annotation (Line(
      points={{92,36},{94,36},{94,-38},{-48,-38},{-48,0},{-100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cos.y, incidenceAngles.angInc) annotation (Line(
      points={{-59.6,40},{-50,40},{-50,36},{-38,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angInc, cos.u) annotation (Line(
      points={{-80,50},{-72,50},{-72,40},{-68.8,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cos1.y, incidenceAngles.angZen) annotation (Line(
      points={{-59.6,28},{-50,28},{-50,32},{-38,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angZen, cos1.u) annotation (Line(
      points={{-80,48},{-74,48},{-74,28},{-68.8,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.angHou, cos2.u) annotation (Line(
      points={{-80,46},{-76,46},{-76,16},{-68.8,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cos2.y, incidenceAngles.angHou) annotation (Line(
      points={{-59.6,16},{-46,16},{-46,28},{-38,28}},
      color={0,0,127},
      smooth=Smooth.None));

  //Ground reflectantance is not used for now (see Absorption model => SolAbs equation!
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                         graphics={
        Line(
          points={{-100,0},{100,0}},
          color={85,170,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-4,20},{-4,-20}},
          color={85,170,255},
          smooth=Smooth.None),
        Rectangle(
          extent={{6,10},{4,-10}},
          lineColor={85,170,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-4,0},{-40,0}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{40,0},{4,0}},
          color={85,170,255},
          smooth=Smooth.None),
        Polygon(
          points={{28,40},{42,60},{48,54},{28,40}},
          lineColor={85,170,255},
          smooth=Smooth.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{28,40},{58,70}},
          color={85,170,255},
          smooth=Smooth.None),
        Line(
          points={{40,30},{70,60}},
          color={85,170,255},
          smooth=Smooth.None),
        Polygon(
          points={{40,30},{54,50},{60,44},{40,30}},
          lineColor={85,170,255},
          smooth=Smooth.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}),
                             Diagram(graphics));
end PvArray;
