within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record Template "General parameters of the borefield"
  extends Modelica.Icons.Record;

  parameter Types.BoreHoleConfiguration borHolCon = Types.BoreHoleConfiguration.SingleUTube
    "Borehole configuration";

  parameter Boolean use_Rb = false
    "True if the value borehole thermal resistance Rb should be given and used";
  parameter Real Rb(unit="(m.K)/W") = 0.14
    "Borehole thermal resistance Rb. Only to fill in if known";

  parameter Modelica.SIunits.Temperature T_start=283.15
    "Initial temperature of the borefield (grout and soil)";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_bh=0.3
    "Nominal mass flow rate per borehole";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = m_flow_nominal_bh*nbBh "Nominal mass flow of borefield";
  parameter Modelica.SIunits.Pressure dp_nominal=50000
    "Pressure losses for the entire borefield";

  //------------------------- Geometrical parameters -----------------------------------------------------------------------------------------------------------------------------
  // -- Borefield geometry
  parameter Modelica.SIunits.Height hBor=100 "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.SIunits.Radius rBor=0.075 "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.SIunits.Height dBor = 1 "Borehole buried depth" annotation (Dialog(group="Borehole"));
  parameter Integer nbBh=1 "Total number of boreholes"
    annotation (Dialog(group="Borehole"));

  parameter Real[nbBh,2] cooBh={{0,0}}
    "Cartesian coordinates of the boreholes in meters."
    annotation (Dialog(group="Borehole"));

  // -- Tube
  parameter Modelica.SIunits.Radius rTub=0.02 "Outer radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.SIunits.ThermalConductivity kTub=0.5 "Thermal conductivity of the tube"
    annotation (Dialog(group="Tubes"));

  parameter Modelica.SIunits.Length eTub=0.002 "Thickness of a tube"
    annotation (Dialog(group="Tubes"));

  parameter Modelica.SIunits.Length xC=0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));

  //------------------------- Advanced parameters -----------------------------------------------------------------------------------------------------------------------------

  /*--------Discretization: */
  parameter Integer nVer=10
    annotation (Dialog(tab="Discretization"));
  parameter Integer nHor(min=1) = 10
    "Number of state variables in each horizontal layer of the soil"
    annotation (Dialog(tab="Discretization"));
  final parameter Modelica.SIunits.Height hSeg=hBor/nVer "Height of horizontal element"
    annotation (Dialog(tab="Discretization"));

  /*--------Flow: */
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal_bh)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Nominal condition"));

  /*--------Assumptions: */

  parameter Modelica.SIunits.Pressure p_constant=101300;

  final Modelica.SIunits.Volume volOneLegSeg=hSeg*Modelica.Constants.pi*rTub^2
    "Volume of brine in one leg of a segment";
  annotation (Documentation(info="<html>
 <p>General parameters of the borefield and record path.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end Template;
