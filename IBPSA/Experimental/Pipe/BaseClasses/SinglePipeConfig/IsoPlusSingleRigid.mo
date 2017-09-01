within IBPSA.Experimental.Pipe.BaseClasses.SinglePipeConfig;
partial record IsoPlusSingleRigid
  "Basic data structure for single rigid (steel) pipes of IsoPlus"
  extends SinglePipeData(      lambdaI=0.024,
    cW=490,
    rhoW=7850);

  final parameter Real hInvers=lambdaI/lambdaG*Modelica.Math.log(2*Heff/ro) +
      Modelica.Math.log(ro/ri);
end IsoPlusSingleRigid;
