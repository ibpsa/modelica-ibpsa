within IDEAS.Buildings.Components;
package Shading "Shadeing devices for windows"

  extends Modelica.Icons.Package;

model None "No solar shadeing"
extends IDEAS.Buildings.Components.Interfaces.StateShading(controled = false);

equation
  connect(solDir, iSolDir) annotation (Line(
      points={{-60,50},{40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-16,-50},{-16,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end None;

model Overhang "Roof overhangs"
extends IDEAS.Buildings.Components.Interfaces.StateShading(controled = false);

parameter Modelica.SIunits.Length H "Window height";
parameter Modelica.SIunits.Length W "Window width";
parameter Modelica.SIunits.Length PH
      "Horizontal projection of overhang above window";
parameter Modelica.SIunits.Length RH
      "Height of horizontal projection above window";
parameter Modelica.SIunits.Length PV
      "Vertical projections of overhang  besides window";
parameter Modelica.SIunits.Length RW
      "Width of vertical projections besides window";

//protected
Modelica.SIunits.Length SW "Shadow width by the horizontal projections";
Modelica.SIunits.Length SH "Shadow height by the vertical projections";
Modelica.SIunits.Area ASL "Sunlit area";
Modelica.SIunits.Area ASH "Shaded area";
Real tanSha "Tangent of the shadow angle";

equation
  tanSha = tan(Modelica.Constants.pi-angZen)/cos(angAzi);
  SW = min(PV * abs(tan(angAzi)),W+RW);
  SH = min(PH * abs(tanSha),H+RH);
  ASL = (W-(SW-RW))*(H-(SH-RH));
  ASH = W*H-ASL;

  iSolDir = min(solDir,solDir*ASL/W/H);

  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-14,-50},{-14,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end Overhang;

model Screen "Exterior screen"
extends IDEAS.Buildings.Components.Interfaces.StateShading(controled = true);

  parameter Real shaCorr = 0.24
      "Shortwave transmittance of shortwave radiation";

  protected
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax = 1,
    uMin = 0,
    limitsAtInit = true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-60})));

equation
iSolDir = solDir*(1-limiter.y);
iSolDif = solDif*(1-limiter.y) + solDif*limiter.y*shaCorr + solDir*limiter.y*shaCorr;
angInc = iAngInc;

  connect(limiter.u, Ctrl) annotation (Line(
      points={{-10,-72},{-10,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}), graphics), Diagram(graphics));
end Screen;

model ScreenOverhang "Roof overhangs with exterior screen"
extends IDEAS.Buildings.Components.Interfaces.StateShading(controled = true);

parameter Modelica.SIunits.Length H "Window height";
parameter Modelica.SIunits.Length W "Window width";
parameter Modelica.SIunits.Length PH
      "Horizontal projection of overhang above window";
parameter Modelica.SIunits.Length RH
      "Height of horizontal projection above window";
parameter Modelica.SIunits.Length PV
      "Vertical projections of overhang  besides window";
parameter Modelica.SIunits.Length RW
      "Width of vertical projections besides window";

  parameter Real shaCorr = 0.24
      "Shortwave transmittance of shortwave radiation";

  protected
  Overhang overhang(H=H, W=W, PH=PH, RH=RH, PV=PV, RW=RW)
    annotation (Placement(transformation(extent={{-42,-24},{-32,-4}})));
  Screen screen(shaCorr=shaCorr)
    annotation (Placement(transformation(extent={{-14,-24},{-4,-4}})));
equation

  connect(overhang.iAngInc, screen.angInc) annotation (Line(
      points={{-32,-20},{-26,-20},{-26,-18},{-14,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.iSolDif, screen.solDif) annotation (Line(
      points={{-32,-12},{-14,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.iSolDir, screen.solDir) annotation (Line(
      points={{-32,-8},{-14,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.Ctrl, Ctrl) annotation (Line(
      points={{-9,-24},{-10,-24},{-10,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iAngInc, iAngInc) annotation (Line(
      points={{-4,-20},{12,-20},{12,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, overhang.solDif) annotation (Line(
      points={{-60,10},{-60,10},{-54,10},{-54,-12},{-42,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDir, overhang.solDir) annotation (Line(
      points={{-60,50},{-52,50},{-52,-8},{-42,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, overhang.angInc) annotation (Line(
      points={{-60,-50},{-50,-50},{-50,-18},{-42,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, overhang.angZen) annotation (Line(
      points={{-60,-70},{-48,-70},{-48,-20},{-42,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angAzi, overhang.angAzi) annotation (Line(
      points={{-60,-90},{-46,-90},{-46,-22},{-42,-22}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(screen.iSolDir, iSolDir) annotation (Line(
        points={{-4,-8},{8,-8},{8,50},{40,50}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(screen.iSolDif, iSolDif) annotation (Line(
        points={{-4,-12},{12,-12},{12,10},{40,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(angZen, screen.angZen) annotation (Line(
        points={{-60,-70},{-24,-70},{-24,-20},{-14,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(angAzi, screen.angAzi) annotation (Line(
        points={{-60,-90},{-22,-90},{-22,-22},{-14,-22}},
        color={0,0,127},
        smooth=Smooth.None));
  annotation (Diagram(graphics));
end ScreenOverhang;

model ShadingControl "shading control based on irradiation"

  parameter Real uLow = 250 "upper limit above which shading goes down";
  parameter Real uHigh = 150 "lower limit below which shading goes up again";
  IDEAS.BaseClasses.Control.Hyst_NoEvent   hyst(uLow=uLow, uHigh=uHigh);
  Modelica.Blocks.Interfaces.RealInput irr "irradiance on the depicted surface"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput y "control signal"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

//  Modelica.Blocks.Interfaces.RealInput TSensor
//    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
equation
hyst.u = irr;
if noEvent(time > 8E6) and noEvent(time <2.6E7) then
  hyst.y=y;
else
  y=0;
end if;
  annotation (Diagram(graphics));
end ShadingControl;

end Shading;
