within IBPSA.Fluid.Movers;
model PrescribedFlow
  "Component for idealized, prescribed massflow or volume flow"
  extends IBPSA.Airflow.Multizone.BaseClasses.PartialOneWayFlowElement;
  // fixme : if this is intended as an airflow model, it should be in IBPSA.Airflow.Multizone as IBPSA.Fluid.Movers is for fans and pumps.

  parameter Boolean flowOpt = true
    "type of prescribed airflow"
    annotation(choices(__Dymola_radioButtons=true, choice=true "mass flow", choice=false "volume flow"));//choices
  // fixme : I am not sure if this kind of choice on input is "allowed" (M.Wetter can confirm). There are duplicates of all other models for mass and volume flow so having duplicate models here would make sense.

  Modelica.Blocks.Interfaces.RealInput PrescribedflowIn annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,106}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,114})));

equation

 if flowOpt then
    m_flow=PrescribedflowIn;

  else
    V_flow=PrescribedflowIn;
  end if;

  // fixme : A validation/test case is missing.
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,16},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-50},{54,0},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,16},{36,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Line(
          points={{-2,102},{-2,52}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          visible=use_inputFilter,
          extent={{-34,42},{32,102}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-30,102},{30,42}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-22,94},{20,48}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="M/V")}), Documentation(revisions="<html>
<ul>
<li>June 26, 2020, by Klaas De Jonge (UGent):<br>First implementation, idealised mover with prescribed mass or volume flow. Extension of IBPSA.Airflow.Multizone.BaseClasses.PartialOneWayFlowelement.</li>
</ul>
</html>", info="<html>
<p>This model describes an idealized flow component. The model expects a real input signal prescribing the <u>mass <b>or</b> volume flow rate</u>.</p>
</html>"));
end PrescribedFlow;
