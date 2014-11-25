within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeMFactor "A check for verifying mFactor implementation"
  extends Annex60.Fluid.MixingVolumes.Examples.MixingVolumeMassFlow(
  sou(X={0.02,0.98},
      T=Medium.T_default),
  vol(mFactor=10));
  annotation (Documentation(info="<html>
<p>The mixingVolume temperature vol.T should be constant. This is to check the correct implementation of the parameter mFactor for moist air media.</p>
</html>", revisions="<html>
<ul>
<li>
November 25, 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeMFactor;
