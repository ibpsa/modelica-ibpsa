within IDEAS.Occupants.Stochastic.Data.BaseClasses;
record Occupance

extends Modelica.Icons.MaterialProperty;

parameter Integer n(min=1) "number of inhabitants";
parameter Integer period;
parameter Integer s "number of timesteps of Markov Chain in one period";

type TransMatrix = Real[n+1,n+1];
type TransChain = TransMatrix[s];

parameter TransChain Twe;
parameter TransChain Twd;

end Occupance;
