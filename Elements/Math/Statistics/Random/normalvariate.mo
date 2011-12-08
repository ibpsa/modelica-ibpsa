within IDEAS.Elements.Math.Statistics.Random;
function normalvariate "normally distributed random variable"
input Real mu
    "requested mean value of the generated random variables with standard deviation sigma";
input Real sigma
    "standard deviation of the requested gaussian random variate with average mu";
input Real[3] si
    "input of a random seed, preferably as output of a previous random function";
output Real x
    "output of the requested gaussian random variate between zero and one";
output Real[3] so
    "Output of a random seed for input of the following random function";

protected
Real[3] s1;
Real[3] s2;
Real z;
Real zz;
Real u1;
Real u2;
Boolean breakLoop = false;

constant Real NV_MAGICCONST=4*exp(-0.5)/sqrt(2.0);

algorithm
s1 := si;
u2 := 1;

while not breakLoop loop
    (u1,s2) := IDEAS.Elements.Math.Statistics.Random.random(s1);
    (u2,s1) := IDEAS.Elements.Math.Statistics.Random.random(s2);
z := NV_MAGICCONST*(u1-0.5)/u2;
zz := z*z/4.0;
breakLoop := zz <= (- Modelica.Math.log(u2));
end while;

x := mu + z*sigma;
so := s1;

end normalvariate;
