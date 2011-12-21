within IDEAS.Occupants.Stochastic.BaseClasses;
model RandomChainLight

  parameter Integer n=3;
  parameter Real[3] seed={3,17,9};
  parameter Real interval=300;
  discrete Real[n] r;

protected
  Real[n,3] seed1;
  Real[n,3] seed2;

initial equation
  seed1[n,:] = seed;

equation

  when rem(time,interval) < 0.1 then
    (r[1],seed2[1, :]) = IDEAS.Occupants.Stochastic.BaseClasses.Random(si=seed1
      [n, :]);
    seed1[1,:] = pre(seed2[1,:]);
  end when;

  when rem(time,interval) < 0.1 then
    for i in 2:n loop
      (r[i],seed2[i, :]) = IDEAS.Occupants.Stochastic.BaseClasses.Random(si=
        seed1[i - 1, :]);
      seed1[i,:] = pre(seed2[i,:]);
    end for;
  end when;

end RandomChainLight;
