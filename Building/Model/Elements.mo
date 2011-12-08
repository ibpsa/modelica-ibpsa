within IDEAS.Building.Model;
package Elements

  model Window "multipane window"

  extends Modelica.Blocks.Interfaces.BlockIcon;

    parameter Modelica.SIunits.Area A "window area";

    parameter Modelica.SIunits.Angle inc "inclination";
    parameter Modelica.SIunits.Angle azi "azimuth";
    parameter Boolean shading = false "shading presence";
    parameter Modelica.SIunits.Efficiency shaCorr = 0.2 "shading transmittance";

    replaceable parameter IDEAS.Building.Elements.Glazing glazing
      "glazing type"                                                              annotation(AllMatching=true);

  protected
    IDEAS.Elements.Meteo.Solar.RadSol radSol(inc=inc,azi=azi,A=A)
      "determination of incident solar radiation on wall based on inclination and azimuth"
      annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
    IDEAS.Building.Model.Elements.SwWindowResponse solWin(
      nLay=glazing.nLay,
      SwAbs=glazing.SwAbs,
      SwTrans=glazing.SwTrans)
      annotation (Placement(transformation(extent={{-8,-60},{12,-40}})));

  public
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a solGain
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    outer SimInfoManager sim
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  equation

    connect(radSol.angInc, solWin.angInc) annotation (Line(
        points={{-60,-54},{-40,-54},{-40,-56},{-8,-56}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(radSol.solDir, solWin.solDir) annotation (Line(
        points={{-60,-44},{-8,-44}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(radSol.solDif, solWin.solDif) annotation (Line(
        points={{-60,-48},{-8,-48}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(solWin.iSol, solGain) annotation (Line(
        points={{0,-60},{0,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end Window;

  model SwWindowResponse "shortwave window respones"

  extends Modelica.Blocks.Interfaces.BlockIcon;

    parameter Integer nLay(min=1) "number of layers of the wall";

    parameter Real[:,nLay+1] SwAbs
      "absorbed solar radiation for each layer for look-up table as function of angle of incidence";
    parameter Real[:,2] SwTrans
      "transmitted solar radiation for look-up table as function of angle of incidence";

    Modelica.Blocks.Interfaces.RealInput solDir
      "direct solar illuminance on surface se"
      annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
    Modelica.Blocks.Interfaces.RealInput solDif
      "diffuse solar illuminance on surface s"
      annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
    Modelica.Blocks.Interfaces.RealInput angInc "angle of incidence"
      annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSol
      "transmitted direct solar riadtion"
      annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
    IDEAS.Building.Component.Elements.AngleOfIncidence angDir
      "angle of incidence conversion"
      annotation (Placement(transformation(extent={{-58,-52},{-40,-34}})));
    Modelica.Blocks.Tables.CombiTable1Ds SwTransDir(table=SwTrans, smoothness=
          Modelica.Blocks.Types.Smoothness.LinearSegments,
      columns={2}) "lookup table for AOI dependent transmittance" annotation (Placement(
          transformation(
          extent={{-9,-9},{9,9}},
          rotation=90,
          origin={-3,-11})));
    Modelica.Blocks.Tables.CombiTable1Ds SwTransDif(table=SwTrans, smoothness=
          Modelica.Blocks.Types.Smoothness.LinearSegments)
      "lookup table for diffuse transmittance"                                                      annotation (Placement(
          transformation(
          extent={{-9,-9},{9,9}},
          rotation=90,
          origin={49,-11})));
    Modelica.Blocks.Sources.Constant angDif(k=60)
      annotation (Placement(transformation(extent={{-90,-38},{-72,-20}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Dir_flow
      "transmitted direct solar riadtion source"
      annotation (Placement(transformation(extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={-20,-78})));
    Modelica.Blocks.Math.Product SwTransDirProd annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=90,
          origin={-7,19})));
    Modelica.Blocks.Math.Product SwTransDifProd annotation (Placement(
          transformation(
          extent={{-7,-7},{7,7}},
          rotation=90,
          origin={45,17})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{56,30},{76,50}})));
  equation
    connect(angDir.angIncDeg, SwTransDir.u) annotation (Line(
        points={{-40,-43},{-3,-43},{-3,-21.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(angDif.y, SwTransDif.u) annotation (Line(
        points={{-71.1,-29},{49,-29},{49,-21.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(angInc, angDir.angInc) annotation (Line(
        points={{-100,-60},{-66,-60},{-66,-43},{-58,-43}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Dir_flow.port, iSol)    annotation (Line(
        points={{-20,-86},{-20,-100}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(solDif, SwTransDifProd.u1) annotation (Line(
        points={{-100,20},{-62,20},{-62,2},{40.8,2},{40.8,8.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(solDir, SwTransDirProd.u1) annotation (Line(
        points={{-100,60},{-60,60},{-60,4},{-11.2,4},{-11.2,10.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(SwTransDir.y[1], SwTransDirProd.u2) annotation (Line(
        points={{-3,-1.1},{-3,13.45},{-2.8,13.45},{-2.8,10.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(SwTransDif.y[1], SwTransDifProd.u2) annotation (Line(
        points={{49,-1.1},{49,3.45},{49.2,3.45},{49.2,8.6}},
        color={0,0,127},
        smooth=Smooth.None));

  for i in 1:nLay loop
  end for;

    connect(SwTransDirProd.y, add.u1) annotation (Line(
        points={{-7,26.7},{-7,46},{54,46}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(SwTransDifProd.y, add.u2) annotation (Line(
        points={{45,24.7},{45,34},{54,34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.y, Dir_flow.Q_flow) annotation (Line(
        points={{77,40},{84,40},{84,-60},{-20,-60},{-20,-70}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end SwWindowResponse;
  annotation (             Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-100,-100},{80,50}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{-80,70},{100,70},{80,50},{-100,50}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,70},{100,-80},{80,-100},{80,50},{100,70}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid)}));

end Elements;
