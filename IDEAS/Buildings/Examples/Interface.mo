within IDEAS.Buildings.Examples;
model Interface
  "Example detailed building structure model including Interfaces.Structure"

extends Modelica.Icons.Example;

extends IDEAS.Interfaces.BaseClasses.Structure(
                                   nZones=3, ATrans=211, VZones={gF.V,fF.V,sF.V});
extends IDEAS.Buildings.Examples.Structure;

equation
  connect(gF.gainCon, heatPortCon[1]) annotation (Line(
      points={{60,-53},{104,-53},{104,13.3333},{150,13.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF.gainCon, heatPortCon[2]) annotation (Line(
      points={{60,7},{104,7},{104,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.gainCon, heatPortCon[3]) annotation (Line(
      points={{60,67},{104,67},{104,26.6667},{150,26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.gainRad, heatPortRad[1]) annotation (Line(
      points={{60,-56},{106,-56},{106,-26.6667},{150,-26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF.gainRad, heatPortRad[2]) annotation (Line(
      points={{60,4},{104,4},{104,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF.gainRad, heatPortRad[3]) annotation (Line(
      points={{60,64},{106,64},{106,-13.3333},{150,-13.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gF.TSensor, TSensor[1]) annotation (Line(
      points={{60.6,-50},{104,-50},{104,-66.6667},{156,-66.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fF.TSensor, TSensor[2]) annotation (Line(
      points={{60.6,10},{104,10},{104,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sF.TSensor, TSensor[3]) annotation (Line(
      points={{60.6,70},{104,70},{104,-53.3333},{156,-53.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gF_floor.port_emb, heatPortEmb[1]) annotation (Line(
      points={{-37,-76},{56,-76},{56,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fF_floor.port_emb, heatPortEmb[1]) annotation (Line(
      points={{-37,-16},{56,-16},{56,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sF_floor.port_emb, heatPortEmb[3]) annotation (Line(
      points={{-37,44},{56,44},{56,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Interface;
