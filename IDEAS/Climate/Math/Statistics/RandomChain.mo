within IDEAS.Climate.Math.Statistics;
model RandomChain

  parameter Real[3] seed={3,17,9};
  parameter Real interval=300;
  discrete Real r(start=0);

protected
  discrete Real[3] seed1;
  discrete Real[3] seed2;

initial equation
  seed1=seed;

equation
  when rem(time,interval) < 0.1 then
    (r,seed2) = IDEAS.Climate.Math.Statistics.Random.random(si=seed1);
    seed1 = pre(seed2);
    //pre(.) breaks the algebraic loop by taking "the left-limit of seed2" instead of "seed2"
  end when;

end RandomChain;
