within IDEAS.Occupants.Appliances.BaseClasses;
function Action

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
end Action;
