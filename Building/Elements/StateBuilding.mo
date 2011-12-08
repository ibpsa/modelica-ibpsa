within IDEAS.Building.Elements;
partial model StateBuilding

/*
cfr. First TABULA synthesis report
For a two-zone dwelling, zone one [1] always represents the dayzonze
whereas zone two [2] will represent the nightzone.
*/

  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

parameter Integer n_C "number (n) of conditioned (C) zones for simulation";
parameter Modelica.SIunits.Area[n_C] A_C_extdim
    "conditioned (C) floor area (A) calculated on the basis of external dimensions (extdim)";
parameter Modelica.SIunits.Area[n_C] A_C_intdim
    "conditioned floor are calculated on the basis of internal dimensions";
parameter Modelica.SIunits.Area[n_C] A_C_use
    "section of the conditioned net floor area primarily dedicated to the utilisation of the building, excluding functional and circulation areas.";
parameter Modelica.SIunits.Area[n_C] A_C_living
    "section of the conditioned net floor are inside of the apartments of the building";
parameter Modelica.SIunits.Area A_T
    "transmission (T) heat loss area (A) of the residential unit";
parameter Modelica.SIunits.Volume[n_C] V_C
    "conditioned volume of the building based on external dimensions";
Modelica.Blocks.Interfaces.RealOutput[n_C] PMV "PMV";
Modelica.Blocks.Interfaces.RealOutput[n_C] PPD "PPD";
parameter Boolean SUH "single unit house";
parameter Boolean MUH = not SUH "multi unit house";

final parameter Modelica.SIunits.Length C = sum(V_C)/A_T;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[n_C] conv
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[n_C] rad
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput[n_C] Top
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[n_C] FH
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  annotation(Icon(graphics={Line(
          points={{60,8},{0,60},{-60,10},{-60,-60},{60,-60}},
          color={127,0,0},
          smooth=Smooth.None), Polygon(
          points={{60,8},{56,4},{0,50},{-54,6},{-54,-54},{60,-54},{60,-60},{-60,
              -60},{-60,10},{0,60},{60,8}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid)}),                         Diagram(
        graphics));

end StateBuilding;
