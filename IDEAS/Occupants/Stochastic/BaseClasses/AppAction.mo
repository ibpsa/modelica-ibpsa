within IDEAS.Occupants.Stochastic.BaseClasses;
function AppAction

input Real P;
input Real cal;
input Real r "random";
output Boolean action;

algorithm
  if r < P*cal then
    action:=true;
  else
    action:=false;
  end if;
end AppAction;
