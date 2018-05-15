within IDEAS.LIDEAS.Validation;
model Case900ValidationLinear
  extends Case900ValidationNonLinear(sim(linIntCon=true,
      linExtCon=true,
      linIntRad=true,
      linExtRad=true));
end Case900ValidationLinear;
