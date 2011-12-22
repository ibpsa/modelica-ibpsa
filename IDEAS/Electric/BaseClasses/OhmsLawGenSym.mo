within IDEAS.Electric.BaseClasses;
model OhmsLawGenSym
  "For use  with loads. Either symmetrically divided over 3 phases (numPha=3) or single phase (numPha=1)."
  parameter Integer numPha=3 "Choose the number of phases" annotation(choices(choice=1
        "single phase",                                                                               choice=3
        "symmetrical 3 phase"));
  IDEAS.Electric.BaseClasses.CNegPin[
                          numPha] vi
                     annotation (Placement(transformation(extent={{90,-10},{110,10}},
                                   rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P
    annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  Modelica.Blocks.Interfaces.RealInput Q
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
equation
    for i in 1:numPha loop
    P/numPha = Modelica.ComplexMath.real(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
    Q/numPha = Modelica.ComplexMath.imag(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
    end for;
  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-100,100},{100,-100}},
            fileName="modelica://ELECTA/OhmsLaw.png")}));
end OhmsLawGenSym;
