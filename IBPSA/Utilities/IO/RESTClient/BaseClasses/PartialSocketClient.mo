within IBPSA.Utilities.IO.RESTClient.BaseClasses;
partial block PartialSocketClient "The socket client "

  extends Modelica.Blocks.Icons.Block;

  outer IBPSA.Utilities.IO.RESTClient.Configuration Config "Default plot configuration";

  parameter Integer numVar(min=1)
    "The number of inputs";
  parameter String host = "127.0.0.1"
    "The host name";
  parameter Integer port = 8888
    "The TCP port";
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3)= Config.samplePeriod
    "Sample period of component"
    annotation(Dialog(group="Activation"));


  parameter IBPSA.Utilities.IO.RESTClient.Types.LocalActivation activation=
    IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.use_activation
    "Set to true to enable an input that allows activating and deactivating the block"
    annotation(Dialog(group="Activation"));
  Modelica.Blocks.Interfaces.BooleanInput activate if
     (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.use_input)
    "Set to true to enable block of time series after activationDelay elapsed"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Integer reVal
    "The return value";
   Modelica.SIunits.Time t0
    "Start time of component";


  Modelica.Blocks.Interfaces.RealInput u[numVar]
    "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Real Ove[numVar]
    "Overwritten signals";
protected
    Modelica.Blocks.Interfaces.BooleanInput activate_internal
    "Internal connector to activate the block";
equation
  if (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.use_input) then
    connect(activate, activate_internal);
  elseif  (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.use_activation) then
    activate_internal = Config.active;
  elseif  (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.always) then
    activate_internal = true;
  end if;

  when (sample(t0,samplePeriod) and activate_internal) then
           (Ove,reVal) =CallClient(
               numVar,
               u,
               host,
               port);
  end when;
  annotation (Documentation(info="<html>
<p>Partial block that implements the basic functionality used by Sampler and Overwritten.</p>
</html>"));
end PartialSocketClient;
