within IDEAS.Electric.Data.Interfaces;
record TransformerImp "Transformer type"
extends Modelica.Icons.MaterialProperty;

parameter Modelica.SIunits.ApparentPower Sn "Apparent power of the transformer";
parameter Modelica.SIunits.ActivePower P0
    "No-load losses, as defined in original transformer model (no update yet on values in data)";
parameter Modelica.SIunits.ComplexImpedance Zd
    "Direct impedance of the equivalent transformer scheme";
parameter Modelica.SIunits.ComplexImpedance Zi=Zd
    "Inverse impedance of the equivalent transformer scheme";
parameter Modelica.SIunits.ComplexImpedance Z0=Zd
    "Zero-sequence impedance of the equivalent transformer scheme";

end TransformerImp;
