within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig;
partial record IsoPlusDouble "IsoPlus double pipes"
  // Pipes in shared insulation buried underground
  extends DoublePipeData(
                   lambdaI=0.028)
  annotation (Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">November 30, 2015 by Bram van der Heijde:<br>First implementation.</span></li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basic record structure for pipe dimensions and insulation parameters, in the specific case of IsoPlus double pipes. Data from IsoPlus catalogue. </span></p>
</html>"));
end IsoPlusDouble;
