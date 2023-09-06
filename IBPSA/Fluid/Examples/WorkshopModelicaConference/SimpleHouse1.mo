within IBPSA.Fluid.Examples.WorkshopModelicaConference;
model SimpleHouse1 "Building wall model"
  extends SimpleHouseTemplate;

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(
    C=A_wall*d_wall*cp_wall*rho_wall)
    "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={150,0})));
equation
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{100,0},{130,0},
          {130,1.77636e-15},{140,1.77636e-15}}, color={191,0,0}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleHouse1;
