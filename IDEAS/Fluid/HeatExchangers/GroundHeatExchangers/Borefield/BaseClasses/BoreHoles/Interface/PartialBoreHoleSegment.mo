within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialBoreHoleSegment
  extends PartialBoreHoleElement;
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
      computeFlowResistance=false, linearizeFlowResistance=false);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface.PartialTWall;
  parameter Modelica.SIunits.Temperature TExt_start=T_start
    "Initial far field temperature"
    annotation (Dialog(tab="Boundary conditions",group="T_start: ground"));
  parameter Modelica.SIunits.Temperature TFil_start=T_start
    "Initial far field temperature"
    annotation (Dialog(tab="Boundary conditions",group="T_start: ground"));

  Modelica.Blocks.Sources.RealExpression realExpression(final y=T_start) if not use_TWall
    annotation (Placement(transformation(extent={{-30,80},{-50,100}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TBouCon
    "Thermal boundary condition for the far-field"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,70})));
  BaseClasses.CylindricalGroundLayer
                           soilLay(
    final material=soi,
    final h=gen.hSeg,
    final nSta=gen.nHor,
    final r_a=gen.rBor,
    final r_b=gen.rExt,
    final TInt_start=TFil_start,
    final TExt_start=TExt_start,
    final steadyStateInitial=false) if not use_TWall
    "Heat conduction in the soil layers"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,40})));

equation
  if not use_TWall then
    connect(realExpression.y,TBouCon. T) annotation (Line(
      points={{-51,90},{-60,90},{-60,82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(soilLay.port_b,TBouCon. port) annotation (Line(
      points={{-60,50},{-60,60}},
      color={191,0,0},
      smooth=Smooth.None));
  else
    connect(TBouCon.T, TWall) annotation (Line(points={{-60,82},{-60,82},{0,82},
            {0,110}},
               color={0,0,127}));
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end PartialBoreHoleSegment;
