within IDEAS.Thermal.Components.Examples;
model MassiveCoreComparison
  "Comparison of different discretization with and without massive core"
extends Modelica.Icons.Example;

Real QBasic3(start=0,fixed=true);
Real QBasic50(start=0,fixed=true);
Real QMassive3(start=0,fixed=true);
Real QMassive50(start=0,fixed=true);

  MassiveCoreOrNot Basic_n3(redeclare
      IDEAS.Thermal.Components.Emission.BaseClasses.Tabs tabs(redeclare
        IDEAS.Thermal.Components.Emission.BaseClasses.FH_Standard1 FHChars,
        m_flowMin=12*24/3600)) "No massive core tabs"
    annotation (Placement(transformation(extent={{-10,54},{10,74}})));
  MassiveCoreOrNot Basic_n50(redeclare
      IDEAS.Thermal.Components.Emission.BaseClasses.Tabs tabs(m_flowMin=12*24/3600,
        redeclare IDEAS.Thermal.Components.Emission.BaseClasses.FH_Standard1
        FHChars(n1=50, n2=50))) "No massive core tabs"
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));
  MassiveCoreOrNot Massive_n3(redeclare
      IDEAS.Thermal.Components.Emission.BaseClasses.TabsMassiveCore tabs(
        redeclare IDEAS.Thermal.Components.Emission.BaseClasses.FH_Standard1
        FHChars,
        m_flowMin=12*24/3600)) "Massive core tabs"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  MassiveCoreOrNot Massive_n50(redeclare
      IDEAS.Thermal.Components.Emission.BaseClasses.TabsMassiveCore tabs(
        redeclare IDEAS.Thermal.Components.Emission.BaseClasses.FH_Standard1
        FHChars(n1=50, n2=50),
        m_flowMin=12*24/3600)) "Massive core tabs"
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));

equation
  der(QBasic3)=Basic_n3.convection.solid.Q_flow;
  der(QBasic50)=Basic_n50.convection.solid.Q_flow;
  der(QMassive3)=Massive_n3.convection.solid.Q_flow;
  der(QMassive50)=Massive_n50.convection.solid.Q_flow;

end MassiveCoreComparison;
