within IDEAS.Electric.DistributionGrid.GridSubModels;
model Linear1P "Linear single-line grid for 1-phase situation"

// Input parameters //////////////////////////////////////////////////////////////////////////////////////////////
  parameter Integer nLoads = 33 "Number of buildings attached to the feeder";
  parameter Modelica.SIunits.Length[nLines] length = ones(nLoads)*24
    "Length of all (nLoads+1) cables";
  replaceable parameter IDEAS.Electric.Data.Interfaces.Cable cable;

  final parameter Integer nLines = nLoads;

// Output variables //////////////////////////////////////////////////////////////////////////////////////////////
  Modelica.SIunits.ReactivePower QGriTot = Modelica.ComplexMath.imag(TraPin.v*Modelica.ComplexMath.conj(TraPin.i))
    "Reactive transformer load";
  Modelica.SIunits.ActivePower PGriTot = Modelica.ComplexMath.real(TraPin.v*Modelica.ComplexMath.conj(TraPin.i))
    "Active transformer load";
  Modelica.SIunits.ActivePower PLosBra[nLines] = line.R.*(Modelica.ComplexMath.'abs'(line.i)).*(Modelica.ComplexMath.'abs'(line.i))
    "Resistive losses in each line";
  Modelica.SIunits.ActivePower PGriLosTot = sum(PLosBra)
    "Total resistive loss in the feeder";
  Modelica.SIunits.Voltage VMax = max(Modelica.ComplexMath.'abs'(node.v))
    "Maximum momentaneous nodal voltage";
  Modelica.SIunits.Voltage VMin = min(Modelica.ComplexMath.'abs'(node.v))
    "Minimum momentaneous nodal voltage";

// Connection variables //////////////////////////////////////////////////////////////////////////////////////////
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin TraPin
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[nLoads] node
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

// Protected variables ///////////////////////////////////////////////////////////////////////////////////////////
protected
  Components.Branch[nLines] line(R=cable.RCha.*length/3, X=cable.XCha.*length)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(line[1].pin_p,TraPin) annotation (Line(
      points={{-10,0},{-100,0}},
      color={85,170,255},
      smooth=Smooth.None));

  for i in 1:nLines loop
    connect(line[i].pin_n,node[i]) annotation (Line(
      points={{10,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  end for;

  for j in 1:nLines-1 loop
    connect(line[j].pin_n,line[j+1].pin_p) annotation (Line(
      points={{10,0},{30,0},{30,10},{-30,10},{-30,0},{-10,0}},
      color={85,170,255},
      smooth=Smooth.None));
  end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
        Line(
          points={{-22,36},{30,2},{100,0}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{30,36},{54,18},{100,4}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-32,40},{-32,34},{-4,34},{-4,-80},{4,-80},{4,34},{34,34},{34,
              40},{4,40},{4,46},{-4,46},{-4,40},{-32,40}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Line(
          points={{-102,4},{-46,12},{-28,36}},
          color={85,170,255},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,0},{-12,12},{30,36}},
          color={85,170,255},
          smooth=Smooth.Bezier)}));
end Linear1P;
