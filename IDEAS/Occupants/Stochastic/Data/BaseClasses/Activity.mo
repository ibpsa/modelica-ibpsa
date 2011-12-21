within IDEAS.Occupants.Stochastic.Data.BaseClasses;
record Activity

extends Modelica.Icons.MaterialProperty;

parameter Integer n
    "maximum number of inhabitants for which the probabilities are defined";
parameter Integer period;
parameter Integer s "number of timesteps of Markov Chain in one period";

parameter Real[s,n+1] Pwe;
parameter Real[s,n+1] Pwd;

/* Real [n+1,s] is used but all probabilities are set 'zero' if 'zero' people are at home.*/

parameter String act;

end Activity;
