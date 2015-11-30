within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig;
partial record PipeData "Contains pipe properties from catalogs"

  parameter Modelica.SIunits.Length Di=0.1 "Equivalent inner diameter";
  parameter Modelica.SIunits.Length Do=Di "Equivalent outer diameter";

  parameter Modelica.SIunits.Length h=Di
    "Horizontal distance between pipe walls";
  parameter Modelica.SIunits.Length Dc=2.5*Di "Diameter of circumscribing pipe";

  final parameter Modelica.SIunits.Length E=h + Do
    "Horizontal distance between pipe centers";

  parameter Modelica.SIunits.ThermalConductivity lambdaI=0.028
    "Thermal conductivity of pipe insulation material";
  parameter Modelica.SIunits.ThermalConductivity lambdaG=2
    "Thermal conductivity of ground layers";
  parameter Modelica.SIunits.ThermalConductivity lambdaGS=2
    "Equivalent conductivity of ground surface";

  parameter Modelica.SIunits.Length H=2 "Buried depth of pipe";
  final parameter Modelica.SIunits.Length Heff=H + lambdaI/lambdaGS
    "Effective buried depth, corrected for ground conductivity";

  final parameter Modelica.SIunits.Length ro=Do/2 "Equivalent outer radius";
  final parameter Modelica.SIunits.Length ri=Di/2 "Equivalent inner radius";
  final parameter Modelica.SIunits.Length rc=Dc/2 "Circumscribing radius";
  final parameter Modelica.SIunits.Length e=E/2
    "Half the distance between the center of the pipes";

end PipeData;
