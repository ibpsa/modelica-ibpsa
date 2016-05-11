within IDEAS.Fluid;
package Production "Models for heat/cold production devices"
extends Modelica.Icons.VariantsPackage;

/*
  model HP_BW "BW HP with losses to environment"

    extends 
      IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses
      ( final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_BW);
    parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";
    parameter Thermal.Data.Interfaces.Medium mediumEvap=Data.Media.Water() 
      "Medium in the evaporator";

    Real COP "Instanteanous COP";

    IDEAS.Thermal.Components.Production.BaseClasses.HP_BW_CondensationPower_Losses
                                                                             heatSource(
      medium=medium,
      mediumEvap=mediumEvap,
      QDesign=QNom,
      TCondensor_in=heatedFluid.T_a,
      TCondensor_set=TSet,
      m_flowCondensor=heatedFluid.flowPort_a.m_flow,
      TEnvironment=heatPort.T,
      UALoss=UALoss)
      annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
    outer IDEAS.BoundaryConditions.SimInfoManager         sim
      annotation (Placement(transformation(extent={{-82,66},{-62,86}})));
    Thermal.Components.Interfaces.FlowPort_a flowPortEvap_a(medium=mediumEvap)
      annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
          iconTransformation(extent={{-110,-30},{-90,-10}})));
    Thermal.Components.Interfaces.FlowPort_b flowPortEvap_b(medium=mediumEvap)
      annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
          iconTransformation(extent={{-110,10},{-90,30}})));
  equation 
    PFuel = 0;
    PEl = heatSource.PEl;
    COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;
    connect(flowPortEvap_a, heatSource.flowPort_a)
                                               annotation (Line(
        points={{-100,-20},{-42,-20},{-42,-46}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(heatSource.flowPort_b, flowPortEvap_b)
                                               annotation (Line(
        points={{-36,-46},{-34,-46},{-34,-72},{-100,-72},{-100,20}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(heatSource.heatPort, heatedFluid.heatPort)
                                                   annotation (Line(
        points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics), Icon(graphics));
  end HP_BW;
*/

end Production;
