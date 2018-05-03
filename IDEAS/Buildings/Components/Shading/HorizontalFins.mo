within IDEAS.Buildings.Components.Shading;
model HorizontalFins "horizontal fins shading"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(final controlled=use_betaInput);

  parameter Modelica.SIunits.Length s(min=0)
    "Vertical spacing between fins";
  parameter Modelica.SIunits.Length w(min=0)
    "Fin width";
  parameter Modelica.SIunits.Length t(min=0)
    "Fin thickness";
  parameter Boolean use_betaInput = false
    "=true, to use input for fin inclination angle"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Angle beta(min=0)=0
    "Fin inclination angle: 0 for horizontal inclination, see documentation"
    annotation(Dialog(enable=not use_betaInput));

  Real shaFrac "Shaded fraction of the glazing";


protected
  Modelica.SIunits.Length dy1 = s-cos(beta_internal)*w-sin(beta_internal)*t;
  Modelica.SIunits.Length dx = cos(beta_internal)*w-sin(beta_internal)*t;
  Modelica.SIunits.Length dz = dx/cos(angInc);
  Modelica.SIunits.Length dy3 = max(0,min(dz*tan(angAlt),s));


  Modelica.Blocks.Interfaces.RealInput beta_internal "Internal variable for inclination angle";
  Modelica.SIunits.Angle angAlt = Modelica.Constants.pi/2 - angZen "Altitude angle";

initial equation
  if not use_betaInput then
    assert(beta > 0 and beta < acos(t/s), "beta between feasible values");
  end if;
  assert(s > 0 and w > 0 and t >= 0,
   "The fin spacing, width and thickness should be positive");

equation
  connect(beta_internal,Ctrl);
  if not use_betaInput then
    beta_internal = beta;
  end if;

  if dy3 > dy1 then
    shaFrac = 1;
  else
    shaFrac = 1-(dy1-min(dy1,dy3))/s;
  end if;

  HShaDirTil = (1-shaFrac)*HDirTil;
  angInc = iAngInc;
  connect(HSkyDifTil, HShaSkyDifTil);
  connect(HGroDifTil, HShaGroDifTil);

    annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}})),
    Documentation(info="<html>
<p>
Shading model for exterior horizontal fins in front of a window,
in function of the fin angle.
</p>
<h4>Assumption and limitations</h4>
<p>
We assume that the fins fully cover the window at all times.
The fin angle should be positive.
The diffuse solar irradiation is not modified, i.e. only the direct
solar irradiation is influenced.
</p>
<h4>Typical use and important parameters</h4>
<p>
Parameter <code>t</code> is the fin thickness,
<code>s</code> is the vertical spacing between the fins and
<code>w</code> is the fin width.
See the figure below for an illustration.
</p>
<h4>Dynamics</h4>
<p>
This model has no dynamics.
</p>
<h4>Implementation</h4>
<p>
The implementation is illustrated using this figure: 
<br><img src=\"modelica://IDEAS/Resources/Images/Buildings/Components/Shading/HorizontalFins.PNG\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
April, 2017 by Iago Cupeiro:<br/>
Cleaned up implementation and documentation.
</li>
</ul>
</html>"));
end HorizontalFins;
