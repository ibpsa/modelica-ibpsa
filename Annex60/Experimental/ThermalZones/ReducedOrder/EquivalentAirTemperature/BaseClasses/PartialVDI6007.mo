within Annex60.Experimental.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses;
partial model PartialVDI6007
  "Partial model for equivalent air temperature as defined in VDI 6007 Part 1"

  parameter Modelica.SIunits.Emissivity aExt
    "Coefficient of absorption of exterior walls (outdoor)";
  parameter Modelica.SIunits.Emissivity eExt
    "Coefficient of emission of exterior walls (outdoor)";
  parameter Integer n "Number of orientations (without ground)";
  parameter Real wfWall[n] "Weight factors of the walls";
  parameter Real wfWin[n] "Weight factors of the windows";
  parameter Real wfGround "Weight factor of the ground (0 if not considered)";
  parameter Modelica.SIunits.Temp_K TGround
    "Temperature of the ground in contact with floor plate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExtOut
    "Exterior walls' convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRad
    "Coefficient of heat transfer for linearized radiation";
  parameter Boolean withLongwave=true
    "If longwave radiation exchange is considered"
    annotation(choices(checkBox = true));
  Modelica.SIunits.Temp_K TEqWall[n] "Equivalent wall temperature";
  Modelica.SIunits.Temp_K TEqWin[n] "Equivalent window temperature";
  Modelica.SIunits.TemperatureDifference TEqLW
    "Equivalent long wave temperature";
  Modelica.SIunits.TemperatureDifference TEqSW[n]
    "Equivalent short wave temperature";
  Modelica.Blocks.Interfaces.RealInput HSol[n](
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Solar radiation per unit area"
    annotation (Placement(
        transformation(extent={{-120,40},{-80,80}}),
        iconTransformation(extent={{-110,24},
            {-70,64}})));
  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Black-body sky temperature" annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-110,
            -26},{-70,14}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Dry bulb temperature" annotation (Placement(
        transformation(extent={{-120,-44},{-80,-4}}),  iconTransformation(
          extent={{-110,-78},{-70,-38}})));
  Modelica.Blocks.Interfaces.RealOutput TEqAir(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Equivalent air temperature" annotation (Placement(
     transformation(extent={{98,-56},
            {118,-36}}),      iconTransformation(extent={{78,-76},{118,-36}})));
  Modelica.Blocks.Interfaces.RealInput sunblind[n]
    "Opening factor of sunblinds for each direction (0 - open to 1 - closed)"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-10,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,90})));
initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGround) > 0.1),
  "The sum of the weightfactors (walls,windows and ground) in eqAirTemp is close
   to 0. If there are no walls, windows and ground at all, this might be 
   irrelevant.", level=AssertionLevel.warning);
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),        Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Rectangle(
          extent={{-70,70},{78,-76}},
          lineColor={170,213,255},
          lineThickness=1,
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-70,70},{-16,18}},
          lineColor={255,221,0},
          fillColor={255,225,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-70,-92},{76,-128}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={236,99,92},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Rectangle(
          extent={{4,46},{78,-76}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Backward,
          lineColor={0,0,0}),
        Rectangle(
          extent={{8,42},{78,-72}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{8,42},{30,14},{78,14}}, color={0,0,0}),
        Line(points={{10,-72},{30,-40},{78,-40}}, color={0,0,0}),
        Line(points={{30,14},{30,-40}}, color={0,0,0})}),
    Documentation(info="<html>
    <p><code>PartialEqAirTemp</code> is a partial model for <code>EqAirTemp</code> 
    models.</p>
</html>",
        revisions="<html>
<ul>
<li><i>October 2014,&nbsp;</i> by Peter Remmen:<br>Implemented.</li>
<li><i>September 2015,&nbsp;</i> by Moritz Lauster:<br>Got rid of cardinality 
and used assert for warnings.<br>Adapted to Annex 60 requirements.</li>
</ul>
</html>"));
end PartialVDI6007;
