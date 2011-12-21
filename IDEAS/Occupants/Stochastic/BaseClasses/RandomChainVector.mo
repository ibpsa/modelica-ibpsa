within IDEAS.Occupants.Stochastic.BaseClasses;
model RandomChainVector

  parameter Integer n = 99;
  parameter Real[4] seed={160,908,4689,14};
  parameter Real interval=300;
  discrete Real[n] r;

  discrete Real[4] seed1( start = seed);
  discrete Real[4] seed2( start = seed);

equation
  when sample(0,interval) then
    (r,seed2)=IDEAS.BaseClasses.Math.Statistics.Random.randomSuperVector(
                                                         si=seed1,n=n);
    seed1 = pre(seed2);
    //pre(.) breaks the algebraic loop by taking "the left-limit of seed2" instead of "seed2"
  end when;

end RandomChainVector;
