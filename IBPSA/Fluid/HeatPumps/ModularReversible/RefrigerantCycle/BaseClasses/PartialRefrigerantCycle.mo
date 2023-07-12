within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialRefrigerantCycle
  "Partial model of refrigerant cycle"

  parameter Modelica.Units.SI.HeatFlowRate QUse_flow_nominal
    "Nominal heat flow rate at useful heat exchanger side"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.Power PEle_nominal
    "Nominal electrical power"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.Temperature TCon_nominal
    "Nominal temperature at secondary condenser side"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.Temperature TEva_nominal
    "Nominal temperature at secondary evaporator side"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal
    "Nominal temperature difference at secondary condenser side"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal
    "Nominal temperature difference at secondary evaporator side"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in secondary condenser side"
    annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate in secondary evaporator side"
    annotation (Dialog(group="Nominal Design"));
  parameter Real y_nominal "Nominal relative compressor speed"
    annotation (Dialog(group="Nominal Design"));
  parameter Real scaFac=QUse_flow_nominal/QUseNoSca_flow_nominal
    "Scaling factor of heat pump" annotation (Dialog(group="Nominal Design"));
  parameter Modelica.Units.SI.HeatFlowRate QUseNoSca_flow_nominal
    "Nominal heat flow rate at useful heat exchanger in the 
    unscaled data model, used to calculate the scaling factor"
    annotation (Dialog(group="Nominal Design"));
  parameter String datSou=""
    "Indicate where the data is coming from";

  replaceable IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal
  constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses.PartialIcingFactor
    "Replaceable model to calculate the icing factor" annotation (
    choicesAllMatching=true,
    Dialog(group="Frosting supression", enable=calc_iceFac),
    Placement(transformation(extent={{-100,-52},{-80,-32}})));

  Modelica.Blocks.Interfaces.RealOutput PEle(final unit="W", final displayUnit=
        "kW") "Electrical Power consumed by HP" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W", final
      displayUnit="kW") "Heat flow rate through Condenser" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-110})));
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus sigBus
    "Bus-connector used in a heat pump" annotation (Placement(transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={1,104})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W", final
      displayUnit="kW") "Heat flow rate through Evaporator" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));
  Modelica.Blocks.Math.Add redQCon
    "Reduce heat flow to the condenser based on the reduction to the evaporator"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-70})));
  Modelica.Blocks.Math.Product proRedQEva
    "Based on the icing factor, the heat flow to the evaporator is reduced"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-50,-70})));

  IBPSA.Utilities.IO.Strings.StringOutput datSouOut
  "String output of data source";
protected
  IBPSA.Utilities.IO.Strings.ConstStringSource conStrSou(final k=datSou)
    "Constant String with data source as output";
equation
  connect(conStrSou.y, datSouOut);
  connect(proRedQEva.y, QEva_flow) annotation (Line(points={{-50,-81},{-50,-88},
          {0,-88},{0,-52},{88,-52},{88,-96},{80,-96},{80,-110}},
                               color={0,0,127}));
  connect(proRedQEva.y, redQCon.u1) annotation (Line(points={{-50,-81},{-50,-88},
          {0,-88},{0,-52},{76,-52},{76,-58}}, color={0,0,127}));
  connect(redQCon.y, QCon_flow) annotation (Line(points={{70,-81},{70,-96},{-80,
          -96},{-80,-110}}, color={0,0,127}));
  connect(iceFacCal.iceFac, proRedQEva.u1)
    annotation (Line(points={{-79,-42},{-56,-42},{-56,-58}}, color={0,0,127}));
  connect(iceFacCal.sigBus, sigBus) annotation (Line(
      points={{-100.1,-42},{-102,-42},{-102,104},{1,104}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),   Text(
          extent={{-57.5,-35},{57.5,35}},
          pattern=LinePattern.Dash,
          textString="%name", origin={-1.5,113},
          rotation=180)}),Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adapted based on IBPSA implementation. Mainly, the iceFac is added directly 
    in this partial model (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    November 26, 2018 by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Partial model for calculation of electrical power 
  <code>PEle</code>, condenser heat flow <code>QCon_flow</code> 
  and evaporator heat flow <code>QEva_flow</code> based on the 
  values in the <code>sigBus</code> for a refrigerant machine.
</p>
<h4>Frosting performance</h4>
<p>
  To simulate possible icing of the evaporator on air-source devices, the 
  icing factor <code>iceFac</code> is used to influence the outputs. 
  The factor models the reduction of heat transfer between refrigerant 
  and source. Thus, the factor is implemented as follows: 
</p>
<p>
  <code>QEva_flow = iceFac * (QConNoIce_flow - PEle)</code> 
</p>
<p>
  With <code>iceFac</code> as a relative value between 0 and 1: </p>
<p><code>iceFac = kA/kA_noIce</code></p>
<p>Finally, the energy balance must still hold: </p>
<p><code>QCon_flow = PEle + QEva_flow</code> </p>
<p>
  You can select different options for the modeling of the icing factor or
  implement your own approach.
</p>

<h4>Scaling factor</h4>
<p>
  Furthermore, different designs of the refrigerant machine 
  are modeled via a scaling factor <code>scaFac</code>. 
  To linearly scale the outputs of the model according to the specified 
  <code>QUse_flow_nominal</code>, children of this partial model must
  specify <code>QUseNoSca_flow_nominal</code> based on the nominal parameters. 
  Then, the scaling factor is calculated following:
</p>
<p><code>scaFac=QUse_flow_nominal/QUseNoSca_flow_nominal</code></p>
</html>"));
end PartialRefrigerantCycle;
