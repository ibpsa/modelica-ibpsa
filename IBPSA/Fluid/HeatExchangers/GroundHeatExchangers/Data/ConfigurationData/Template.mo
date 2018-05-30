within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData;
record Template "General parameters of the borefield"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter Boolean singleUTube = true
    "True if use single U-tube, false if use double U-tube";
  parameter Boolean parallel2UTube = true
    "True if the double u-tube is connected in parallel in each borehole.";

  parameter Boolean use_Rb = false
    "True if the value borehole thermal resistance Rb should be given and used";
  parameter Real Rb(unit="(m.K)/W") = 0.14
    "Borehole thermal resistance Rb. Only to fill in if known";

  parameter SI.Temperature T_start=283.15
    "Initial temperature of the borefield (grout and soil)";
  parameter SI.MassFlowRate m_flow_nominal_bh=0.3
    "Nominal mass flow rate per borehole";
  parameter SI.MassFlowRate m_flow_nominal = m_flow_nominal_bh*nbBh "Nominal mass flow of borefield";
  parameter SI.Pressure dp_nominal=50000
    "Pressure losses for the entire borefield";

  //------------------------- Geometrical parameters -----------------------------------------------------------------------------------------------------------------------------
  // -- Borefield geometry
  parameter SI.Height hBor=100 "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter SI.Radius rBor=0.075 "Radius of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter SI.Height dBor = 1 "Borehole buried depth" annotation (Dialog(group="Borehole"));
  parameter Integer nbBh=1 "Total number of boreholes"
    annotation (Dialog(group="Borehole"));

  parameter Real[nbBh,2] cooBh={{0,0}}
    "Cartesian coordinates of the boreholes in meters."
    annotation (Dialog(group="Borehole"));

  // -- Tube
  parameter SI.Radius rTub=0.02 "Outer radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter SI.ThermalConductivity kTub=0.5 "Thermal conductivity of the tube"
    annotation (Dialog(group="Tubes"));

  parameter SI.Length eTub=0.002 "Thickness of a tube"
    annotation (Dialog(group="Tubes"));

  parameter SI.Length xC=0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Tubes"));

  //------------------------- Step reponse parameters -----------------------------------------------------------------------------------------------------------------------------
  parameter SI.Time tStep=3600 "Time resolution of the step-response [s]";

  //------------------------- Advanced parameters -----------------------------------------------------------------------------------------------------------------------------

  /*--------Discretization: */
  parameter Integer nVer=10
    annotation (Dialog(tab="Discretization"));
  parameter Integer nHor(min=1) = 10
    "Number of state variables in each horizontal layer of the soil"
    annotation (Dialog(tab="Discretization"));
  final parameter SI.Height hSeg=hBor/nVer "Height of horizontal element"
    annotation (Dialog(tab="Discretization"));

  /*--------Flow: */
  parameter SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal_bh)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Nominal condition"));
  /*--------aggregation: */
  parameter Integer p_max = 5 "Maximum number of cell per aggregation level";

  /*--------Boundary condition: */
  /*----------------T_start: */
  /*------------------------Ground: */
  parameter SI.Height z0=0
    "NOT YET SUPPORTED. Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));
  parameter SI.Height z[nVer]={hBor/nVer*(i - 0.5) for i in 1:nVer}
    "NOT YET SUPPORTED. Distance from the surface to the considered segment"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));
  parameter Real dT_dz(unit="K/m") = 0.0
    "NOT YET SUPPORTED. Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Radius rExt=3
    "Radius of the soil used for the external boundary condition"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  /*--------Assumptions: */

  parameter SI.Pressure p_constant=101300;

  final SI.Volume volOneLegSeg=hSeg*Modelica.Constants.pi*rTub^2
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
