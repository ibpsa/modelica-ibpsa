within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record Advanced "Advanced parameters"
  extends Modelica.Icons.Record;
  import SI = Modelica.SIunits;

  parameter String path="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.Advanced";

  parameter SI.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Tubes"));

  parameter SI.Height hBor=100 "Total height of the borehole";

  /*--------Discretization: */
  parameter Integer nVer=1
    "DO NOT CHANGE! NOT YET SUPPORTED. Number of segments used for discretization in the vertical direction. Only important for the short-term simulation. nVer>1 not yet supported"
    annotation (Dialog(tab="Discretization"));
  parameter Integer nHor(min=1) = 10
    "Number of state variables in each horizontal layer of the soil"
    annotation (Dialog(tab="Discretization"));
  final parameter SI.Height hSeg=hBor/nVer "Height of horizontal element"
    annotation (Dialog(tab="Discretization"));

  /*--------Flow: */
  parameter SI.MassFlowRate m_flow_nominal=0.1 "Nominal mass flow rate"
    annotation (Dialog(tab="Nominal condition"));
  parameter SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Nominal condition"));

  /*--------Boundary condition: */
  /*----------------T_start: */
  /*------------------------Ground: */
  parameter SI.Height z0=10 "Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));
  parameter SI.Height z[nVer]={hBor/nVer*(i - 0.5) for i in 1:nVer}
    "Distance from the surface to the considered segment"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));
  parameter Real dT_dz(unit="K/m") = 0.0
    "Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Radius rExt=3
    "Radius of the soil used for the external boundary condition"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Temperature TExt0_start=273.15 "Initial far field temperature"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  parameter SI.Temperature TExt_start[nVer]={if z[i] >= z0 then TExt0_start + (
      z[i] - z0)*dT_dz else TExt0_start for i in 1:nVer}
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Boundary conditions", group="T_start: ground"));

  /*------------------------Filling:*/
  parameter SI.Temperature TFil0_start=TExt0_start
    "Initial temperature of the filling material for h = 0...z0"
    annotation (Dialog(tab="Boundary conditions", group="T_start: filling"));

  /*--------Assumptions: */
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumption"), Evaluate=true);

  parameter SI.Pressure p_constant=101300;
  parameter SI.Pressure dp_nominal=50000
    "pressure losses for the entire borefield";

  final SI.Volume volOneLegSeg = hSeg*Modelica.Constants.pi*rTub^2
    "volume of brine in one leg of a segment";
end Advanced;
