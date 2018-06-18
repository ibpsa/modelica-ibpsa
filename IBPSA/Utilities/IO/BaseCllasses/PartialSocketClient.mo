within IBPSA.Utilities.IO.BaseCllasses;
partial block PartialSocketClient "The socket client "

  extends Modelica.Blocks.Icons.Block;

  outer IBPSA.Utilities.IO.Configuration Config "Default plot configuration";

  parameter Integer numVar(min=1)
    "The number of inputs";
  parameter String host = "127.0.0.1"
    "The host name";
  parameter Integer port = 8888
    "The TCP port";

  Integer reVal
    "The return value";
  Boolean OveEn;
  Modelica.Blocks.Interfaces.RealInput u[numVar]
    "Connector of second Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3) = Config.samplePeriod
    "Sample period of component"
    annotation(Dialog(group="Activation"));
  Real Ove[numVar]
    "Overwritten signals";

  Modelica.Blocks.Interfaces.RealOutput y[numVar]
    "Connector of Real output signal"    annotation (Placement(transformation(extent={{100,-20},
            {140,20}}),enable=OveEn,visible=WriEn));
equation
      OveEn=Config.active;
       when (sample(0,samplePeriod) and OveEn) then
          (Ove,reVal) =SocketClient(
             numVar,
             u,
             host,
          port);
       end when;



  annotation ();
end PartialSocketClient;
