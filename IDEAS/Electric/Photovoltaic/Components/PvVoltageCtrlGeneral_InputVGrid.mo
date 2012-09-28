within IDEAS.Electric.Photovoltaic.Components;
model PvVoltageCtrlGeneral_InputVGrid
  "Basic controller, with fixed shut down time, with RealInput for grid voltage"

extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Real VMax = 253;
parameter Real timeOff = 300;
parameter Integer numPha=1
    "1 or 3, just indicates if it's a single or 3 phase PV system";

Boolean switch(start = true, fixed=true) "if true, system is producing";

  Modelica.Blocks.Interfaces.RealInput PInit
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput QInit
    annotation (Placement(transformation(extent={{-120,0},{-80,40}})));
  Modelica.Blocks.Interfaces.RealOutput PFinal
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Blocks.Interfaces.RealOutput QFinal
    annotation (Placement(transformation(extent={{90,10},{110,30}})));

  discrete Real restartTime( start=-1, fixed=true)
    "system is off until time>restartTime";

public
  Modelica.Blocks.Interfaces.RealInput VGrid
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
equation

when {VGrid > VMax, time > pre(restartTime)} then
  if VGrid > VMax and time > pre(restartTime) then
    // some voltage limit was crossed while system was on.  Switch off and set restarttime
    switch = false;
    restartTime = time + timeOff;
  elseif VGrid > VMax and time < pre(restartTime) then
    // some voltage limit was crossed during an offtime: keep off but don't change the restarTime
    switch = false;
    restartTime = pre(restartTime);
  else
    switch = true;
    restartTime = -1;
  end if;
end when;

if pre(switch) then
  PFinal = PInit;
else
  PFinal = 0;
end if;

QFinal = QInit;

  annotation (Diagram(graphics));
end PvVoltageCtrlGeneral_InputVGrid;
