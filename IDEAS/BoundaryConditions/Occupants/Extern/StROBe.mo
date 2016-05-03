within IDEAS.BoundaryConditions.Occupants.Extern;
model StROBe "StROBe occupant, for multi zone building models"

  extends IDEAS.Templates.Interfaces.BaseClasses.Occupant(
                                                final nLoads=1);
  outer StrobeInfoManager strobe(final StROBe_P=true, StROBe = true)
    annotation (Placement(transformation(extent={{-186,80},{-166,100}})));

  parameter Modelica.SIunits.Volume[nZones] VZones "Zone volumes";
  final parameter Real[nZones] fV = VZones/sum(VZones) "Zone volume fractions";

protected
  Modelica.SIunits.Temperature[nZones] TSet_internal;

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] QCon_flow
    annotation (Placement(transformation(extent={{-170,10},{-190,30}})));
  Modelica.Blocks.Sources.RealExpression[nZones] QCon(y=fV*strobe.tabQCon.y[id])
    annotation (Placement(transformation(extent={{-120,10},{-160,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] QRad_flow
    annotation (Placement(transformation(extent={{-170,-30},{-190,-10}})));
  Modelica.Blocks.Sources.RealExpression[nZones] QRad(y=fV*strobe.tabQRad.y[id])
    annotation (Placement(transformation(extent={{-120,-30},{-160,-10}})));
  Modelica.Blocks.Sources.RealExpression mDHW(y=strobe.tabDHW.y[id]/60)
    annotation (Placement(transformation(extent={{20,-10},{-20,10}},
        rotation=-90,
        origin={60,60})));
  Modelica.Blocks.Sources.RealExpression[nZones] TSet_signal(y=TSet_internal)
             annotation (Placement(transformation(
        extent={{20,-10},{-20,10}},
        rotation=-90,
        origin={0,60})));
equation

  P = {strobe.tabP.y[id]};
  Q = {strobe.tabQ.y[id]};
  TSet_internal[1] = strobe.tabTSet.y[id];
  if nZones > 1 then
    for i in 2:nZones loop
      TSet_internal[i] = strobe.tabTSet2.y[id];
    end for;
  end if;

  connect(heatPortCon, QCon_flow.port) annotation (Line(
      points={{-200,20},{-190,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QCon_flow.Q_flow, QCon.y) annotation (Line(
      points={{-170,20},{-162,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QRad_flow.port, heatPortRad) annotation (Line(
      points={{-190,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QRad_flow.Q_flow, QRad.y) annotation (Line(
      points={{-170,-20},{-162,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mDHW60C, mDHW.y) annotation (Line(
      points={{60,100},{60,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, TSet_signal.y) annotation (Line(
      points={{0,100},{0,82}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}),
                      graphics));
end StROBe;
