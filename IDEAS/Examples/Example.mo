within IDEAS.Examples;
model Example

  extends Modelica.Icons.Example;

  inner SimInfoManager sim(
    redeclare IDEAS.Climate.Meteo.Files.min15 detail,
    redeclare IDEAS.Climate.Meteo.Locations.Uccle city,
    occBeh=false)
    annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
end Example;
