within IDEAS.Templates.Heating;
model IdealRadiatorHeating "Hystersis heating system that instantly responds to a heat demand by injecting a nominal heating power"
  extends IDEAS.Templates.Interfaces.BaseClasses.HeatingSystem(
    P=fill(QHeaSys,nLoads_min),
    Q=zeros(nLoads_min),
    final nConvPorts = nZones,
    final nRadPorts = nZones,
    final isDH=false,
    final nTemSen = nZones,
    final nEmbPorts=0,
    final nLoads=0);
  parameter Real dTHys=2 "Temperature difference for hysteresis controller";
  parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = fill(5000,nZones)
    "Nominal power, power that is injected when the heating system is on";
  parameter Real COP = 3
    "Coefficient of performance, conversion factor for thermal power to electrical power";
  parameter Real fraRad(min=0,max=1) = 0.3
    "Fraction of heat that is dissipated using radiative heat transfer";
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] preHeaFloRad(
    each final alpha=0)
    "Prescribed heat flow rate for radiative gains"
    annotation (Placement(transformation(extent={{-160,-30},{-180,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nZones] preHeaFloCon(
    each final alpha=0)
    "Prescribed heat flow rate for convection gains"
    annotation (Placement(transformation(extent={{-160,10},{-180,30}})));
  Modelica.Blocks.Logical.Hysteresis[nZones] hys(
    each uLow=0,
    each uHigh=dTHys,
    each pre_y_start=false)
    "Hysteresis controller to avoid chattering"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Modelica.Blocks.Math.Gain[nZones] gain(final k=QNom) "Nominal heat gain"
    annotation (Placement(transformation(extent={{-100,-10},{-120,10}})));
  Modelica.Blocks.Math.Add[nZones] add(each final k1=-1, each final k2=1)
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={12,-30})));
  Modelica.Blocks.Math.BooleanToReal[nZones] booToRea "Boolean to real conversion"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Modelica.Blocks.Math.Gain[nZones] fraRadGai(each k=fraRad)
    "Fraction of heat that is dissipated through radiative port"
    annotation (Placement(transformation(extent={{-130,10},{-150,30}})));
  Modelica.Blocks.Math.Gain[nZones] fraConGai(each k=1 - fraRad)
    "Fraction of heat that is dissipated through convective port"
    annotation (Placement(transformation(extent={{-130,-30},{-150,-10}})));
equation

  connect(add.u2, TSet)
    annotation (Line(points={{18,-42},{18,-104},{20,-104}}, color={0,0,127}));
  connect(add.u1, TSensor)
    annotation (Line(points={{6,-42},{6,-60},{-204,-60}}, color={0,0,127}));
  connect(add.y, hys.u)
    annotation (Line(points={{12,-19},{12,0},{-18,0}}, color={0,0,127}));
  connect(hys.y, booToRea.u) annotation (Line(points={{-41,0},{-50,0},{-50,0},{-58,
          0}}, color={255,0,255}));
  connect(booToRea.y, gain.u)
    annotation (Line(points={{-81,0},{-98,0}}, color={0,0,127}));
  connect(fraConGai.y, preHeaFloRad.Q_flow)
    annotation (Line(points={{-151,-20},{-160,-20}}, color={0,0,127}));
  connect(fraRadGai.y, preHeaFloCon.Q_flow)
    annotation (Line(points={{-151,20},{-160,20}}, color={0,0,127}));
  connect(fraRadGai.u, gain.y) annotation (Line(points={{-128,20},{-122,20},{-122,
          0},{-121,0}}, color={0,0,127}));
  connect(fraConGai.u, gain.y) annotation (Line(points={{-128,-20},{-122,-20},{-122,
          0},{-121,0}}, color={0,0,127}));
  connect(preHeaFloRad.port, heatPortRad)
    annotation (Line(points={{-180,-20},{-200,-20}}, color={191,0,0}));
  connect(preHeaFloCon.port, heatPortCon)
    annotation (Line(points={{-180,20},{-200,20}}, color={191,0,0}));
  annotation (Documentation(info="<html>
<p>
This model represents an ideal heating system with a hysteresis controller.
It reacts instantly when the zone temperature input <code>TSensor</code> is 
below <code>TSet</code> by supplying the nominal
heat flow rate <code>QNom</code>.
This heat flow rate is maintained until <code>TSensor</code> is above <code>TSet+dTHys</code>.
</p>
<p>
The <code>COP</code> is used to compute the electric power that is drawn from 
the elecrical grid. It can be ignored if it is not of interest.
</p>
</html>", revisions="<html>
<ul>
<li>
June 5, 2018 by Filip Jorissen:<br/>
Cleaned up implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
<li>
January 23, 2017 by Filip Jorissen and Glenn Reynders:<br/>
Revised implementation and documentation.
</li>
<li>2013 June, Roel De Coninck: reworking interface and documentation</li>
<li>2011, Roel De Coninck: first version</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,100}}),
        graphics));
end IdealRadiatorHeating;
