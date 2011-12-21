within IDEAS.Occupants.Stochastic.BaseClasses;
model RandomChain

  parameter Real[3] seed;
  parameter Real interval=300;
  discrete Real r(start=0);

  discrete Real[3] seed1( start = seed);
  discrete Real[3] seed2( start = seed);

//initial equation
//  seed1 = seed;

equation
  when sample(0,interval) then
    (r,seed2) = IDEAS.Occupants.Stochastic.BaseClasses.Random(si=seed1);
    seed1 = pre(seed2);
    //pre(.) breaks the algebraic loop by taking "the left-limit of seed2" instead of "seed2"
  end when;

end RandomChain;
