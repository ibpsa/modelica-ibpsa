within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record Template "General parameters of the borefield"
  extends Modelica.Icons.Record;

  parameter Types.BoreholeConfiguration borCon
    "Borehole configuration";

  parameter Boolean use_Rb = false
    "True if the value borehole thermal resistance Rb should be given and used";
  parameter Real Rb(unit="(m.K)/W") = 0.0
    "Borehole thermal resistance Rb. Only to fill in if known";
  parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal
    "Nominal mass flow rate per borehole";
  parameter Modelica.SIunits.MassFlowRate mBorFie_flow_nominal = mBor_flow_nominal*nbBor
    "Nominal mass flow of borefield";
  parameter Modelica.SIunits.Pressure dp_nominal
    "Pressure losses for the entire borefield";

  //------------------------- Geometrical parameters -----------------------------------------------------------------------------------------------------------------------------
  // -- Borefield geometry
  parameter Modelica.SIunits.Height hBor "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.SIunits.Radius rBor "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Modelica.SIunits.Height dBor "Borehole buried depth" annotation (Dialog(group="Borehole"));
  parameter Integer nbBor "Total number of boreholes"
    annotation (Dialog(group="Borehole"));

  parameter Real[nbBor,2] cooBor
    "Cartesian coordinates of the boreholes in meters."
    annotation (Dialog(group="Borehole"));

  // -- Tube
  parameter Modelica.SIunits.Radius rTub "Outer radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.SIunits.ThermalConductivity kTub "Thermal conductivity of the tube"
    annotation (Dialog(group="Tubes"));

  parameter Modelica.SIunits.Length eTub "Thickness of a tube"
    annotation (Dialog(group="Tubes"));

  parameter Modelica.SIunits.Length xC
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));

  //------------------------- Advanced parameters -----------------------------------------------------------------------------------------------------------------------------

//   /*--------Discretization: */
//   parameter Integer nVer
//     annotation (Dialog(tab="Discretization"));
//   parameter Integer nHor(min=1)
//     "Number of state variables in each horizontal layer of the soil"
//     annotation (Dialog(tab="Discretization"));
//   final parameter Modelica.SIunits.Height hSeg=hBor/nVer "Height of horizontal element"
//     annotation (Dialog(tab="Discretization"));

  /*--------Flow: */
  parameter Modelica.SIunits.MassFlowRate mBor_flow_small(min=0) = 1E-4*abs(mBor_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Nominal condition"));

  /*--------Assumptions: */

  parameter Modelica.SIunits.Pressure p_constant;

//   final Modelica.SIunits.Volume volOneLegSeg=hSeg*Modelica.Constants.pi*rTub^2
//     "Volume of brine in one leg of a segment";
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
