within IBPSA.Utilities.IO.RESTClient.BaseClasses;
partial block PartialSocketClient "The socket client "
  extends Modelica.Blocks.Icons.Block;

  outer IBPSA.Utilities.IO.RESTClient.Configuration config
    "Default configuration";
  parameter String hosAddress="127.0.0.1"
    "Host address";
  parameter Integer tcpPort=8888
    "TCP port";
  parameter Integer numberVariable(min=1)=1
    "Number of inputs";
  parameter String nameVariable[numberVariable]={"Placeholder"}
    "Variable name";
  parameter Modelica.SIunits.Time t0=0
    "Start time of component";
  parameter IBPSA.Utilities.IO.RESTClient.Types.LocalActivation activation=IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.global
    "Flag to determine if this block is activating or not"
    annotation (Dialog(group="Activation"));

  String actualhosAddress
    "Actual host address";
  Integer actualtcpPort
    "Actual TCP port";
  Modelica.SIunits.Time nextSampleTime(start = (if t0 > 0 then floor(0.5+t0) else ceil(t0-0.5)))
    "Next sample time";

  Modelica.Blocks.Interfaces.BooleanInput activate if (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.dynamic)
    "Set to true to enable block locally"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));



protected
    Modelica.Blocks.Interfaces.BooleanInput activate_internal
    "Internal connector to activate the block";

equation
  if (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.dynamic) then
    connect(activate, activate_internal);
    actualhosAddress = hosAddress;
    actualtcpPort = tcpPort;
  elseif (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.global) then
    activate_internal = config.active;
    actualhosAddress = config.hosAddress;
    actualtcpPort = config.tcpPort;
  elseif (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.always) then
    activate_internal = true;
    actualhosAddress = hosAddress;
    actualtcpPort = tcpPort;
  end if;
  annotation (Documentation(info="<html>
<p>Partial block that implements the basic functionality used by Send_Real and Read_Real. </p>
</html>", revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>"));
end PartialSocketClient;
