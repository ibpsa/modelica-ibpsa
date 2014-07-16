within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.VerticalSingleBorehole.BoreholeComponents;
model CylindricalLayer
  "describes the physical behaviour of a cylindrical layer"
  // Dieter Patteeuw 28feb2012

  parameter Modelica.SIunits.Radius innerRadiusCyl
    "inner radius of the cylinder";
  parameter Modelica.SIunits.Radius outerRadiusCyl
    "outer radius of the cylinder";
  parameter Modelica.SIunits.Length heigthCyl "heigth of the cylinder";
  parameter Modelica.SIunits.SpecificHeatCapacity groundCpCyl
    "J/kgK specific heat capacity of the ground";
  parameter Modelica.SIunits.ThermalConductivity groundKCyl
    "W/mK thermal conductivity of the ground";
  parameter Modelica.SIunits.Temperature tempInitial
    "initial temperature of the cylinder";
  parameter Modelica.SIunits.Density groundRhoCyl "kg/m3 density of the ground";

protected
  parameter Modelica.SIunits.Radius capacityRadius=sqrt((outerRadiusCyl^2 +
      innerRadiusCyl^2)/2)
    "radius at which to place the capacity, according to Bianchi";

  parameter Modelica.SIunits.ThermalConductance innerRadialConductance=(2*
      Modelica.Constants.pi*heigthCyl*groundKCyl)/(log(capacityRadius/
      innerRadiusCyl)) "W/K conductivity in the radial direction, inner side";
  parameter Modelica.SIunits.ThermalConductance outerRadialConductance=(2*
      Modelica.Constants.pi*heigthCyl*groundKCyl)/(log(outerRadiusCyl/
      capacityRadius)) "W/K conductivity in the radial direction, outer side";
  parameter Modelica.SIunits.ThermalConductance verticalConductance=groundKCyl/
      heigthCyl*Modelica.Constants.pi*(outerRadiusCyl^2 - innerRadiusCyl^2)
    "W/K conductivity in vertical direction";
  parameter Modelica.SIunits.HeatCapacity cylinderCapacity=groundCpCyl*
      groundRhoCyl*heigthCyl*Modelica.Constants.pi*(outerRadiusCyl^2 -
      innerRadiusCyl^2) "J/K heatcapacity of the layer";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=
        cylinderCapacity, T(start=tempInitial)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,-12})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor innerRadial(G=
        innerRadialConductance)
    annotation (Placement(transformation(extent={{-74,-12},{-54,8}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor outerRadial(G=
        outerRadialConductance)
    annotation (Placement(transformation(extent={{44,-12},{64,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor verticalUpper(G=
        verticalConductance/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,46})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor verticalUnder(G=
        verticalConductance/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-8,-54})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a innerRadius
    annotation (Placement(transformation(extent={{-106,-2},{-86,18}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a outerRadius
    annotation (Placement(transformation(extent={{88,-4},{108,16}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a upperSurface
    annotation (Placement(transformation(extent={{-22,88},{-2,108}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a lowerSurface
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
equation
  connect(innerRadial.port_b, heatCapacitor.port) annotation (Line(
      points={{-54,-2},{-2,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, outerRadial.port_a) annotation (Line(
      points={{-2,-2},{22,-2},{22,-1},{44,-1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, verticalUpper.port_a) annotation (Line(
      points={{-2,-2},{-6,-2},{-6,36},{-8,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, verticalUnder.port_b) annotation (Line(
      points={{-2,-2},{-6,-2},{-6,-44},{-8,-44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(innerRadial.port_a, innerRadius) annotation (Line(
      points={{-74,-2},{-86,-2},{-86,8},{-96,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(verticalUpper.port_b, upperSurface) annotation (Line(
      points={{-8,56},{-10,56},{-10,98},{-12,98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(outerRadial.port_b, outerRadius) annotation (Line(
      points={{64,-1},{80,-1},{80,6},{98,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(verticalUnder.port_a, lowerSurface) annotation (Line(
      points={{-8,-64},{-10,-64},{-10,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={Line(
          points={{-46,24},{-38,30},{-36,34},{-36,40},{-38,46},{-42,52},{-48,54},
            {26,82},{40,68},{42,58},{44,44},{42,34},{38,22},{34,10},{28,4},{22,
            0},{-46,24},{-46,-54},{24,-84},{22,0},{24,-84},{38,-72},{46,-46},{
            44,44},{46,38}},
          color={102,0,0},
          smooth=Smooth.None),Text(
          extent={{-94,118},{90,36}},
          lineColor={102,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>Dieter Patteeuw. March April 2012.</p>
<p><b>Description</b> </p>
<p>Cylindrical layer is a part of the mesh. It consists of a heat capacity and 4 thermal resistances. </p>
<p>The heat capacity is based on the volume of the part, and it&apos;s physical characteristics.</p>
<p>2 of the 4 thermal resistances are for the vertical direction, which is planar heat diffusion. The location of the center is in the arithmetic mean (the middle).</p>
<p><br/>2 of the 4 thermal resistances are for the radial direction, which is radial heat diffusion. The location of the center is the quadratic mean.</p><p><br/>See also page 173 of PhD thesis Clara Verhelst titled &QUOT;Model Predictive Control of Ground Coupled Heat Pump Systems for Office Buildings&QUOT;</p>
<p><h4>Assumptions and limitations </h4></p>
<p>1.&nbsp;&nbsp;Heat diffusion is discretized in thermal resistances and thermal capacities.</p>
<p><b>Model use</b> </p>
<p>1.&nbsp;Sub-model. Only use in <a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a>.</p>
<p><h4>Validation </h4></p>
<p>See description in <a href=\"VerticalSingleBorehole.SingleBorehole\">SingleBorehole</a></p>
<p><b>Example</b> </p>
<p>An example of this model can be found in the validation models (VerticalSingleBorehole.TestSpitlerConstant and VerticalSingleBorehole.TestSpitlerInterrupted)</p>
</html>"));
end CylindricalLayer;
