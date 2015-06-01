within Annex60.Fluid.Examples.PerformanceExamples;
model Example5
  extends Modelica.Icons.Example;
  parameter Boolean efficient = false
  annotation(Evaluate=true);

  parameter Real[3] a = 1:3;
  parameter Real b=sum(a);

  Real c;
equation
  der(c) = sin(time)*(if efficient then b else sum(a));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          lineColor={0,0,255},
          textString="See code")}),
    experiment(StopTime=100000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    Documentation(revisions="<html>
<ul>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example illustrates the impact of 
Modelica code formulations on the c-code.
</p>
<p>
Compare the c-code in dsmodel.c when setting parameter 
<code>efficient</code> to  <code>true</code> or <code>false</code> 
and when adding <code>annotation(Evaluate=true)</code> to parameter <code>efficient</code>.
</p>
<p>
This produces:
</p>
<h3>Efficient = false and Evaluate = false</h3>
<p>
<code>
helpvar[0] = sin(Time); <br />
F_[0] = helpvar[0]*(IF DP_[0] THEN W_[0] ELSE DP_[1]+DP_[2]+DP_[3]);
</code>
</p>
<h3>Efficient = false and Evaluate = true</h3>
<p>
<code>
helpvar[0] = sin(Time);<br />
F_[0] = helpvar[0]*(DP_[0]+DP_[1]+DP_[2]);
</code>
</p>
<h3>Efficient = true and Evaluate = true</h3>
<p>
<code>
helpvar[0] = sin(Time);<br />
F_[0] = helpvar[0]*W_[1];
</code>
</p>
The last option requires much less operations to be performed and is therefore more efficient.
</html>
"));
end Example5;
