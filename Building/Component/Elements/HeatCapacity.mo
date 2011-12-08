within IDEAS.Building.Component.Elements;
model HeatCapacity "thermal capacity"

extends IDEAS.Building.Elements.StateSingle(T(start=293.15, fixed=false));
parameter Modelica.SIunits.HeatCapacity C "total thermal capacity";

equation
der(T)=port_a.Q_flow/C;

  annotation (Icon(graphics={
        Line(
          points={{0,30},{0,-30}},
          color={127,0,0},
          smooth=Smooth.None,
          origin={-70,0},
          rotation=90),
        Rectangle(
          extent={{-20,5},{20,-5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-36,1},
          rotation=90),
        Rectangle(
          extent={{-20,5},{20,-5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-18,1},
          rotation=90),
        Text(
          extent={{-99,20},{99,-20}},
          lineColor={0,0,255},
          origin={20,-1},
          rotation=90,
          textString="%name")}));
end HeatCapacity;
