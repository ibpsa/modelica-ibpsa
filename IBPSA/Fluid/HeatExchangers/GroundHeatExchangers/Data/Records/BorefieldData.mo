within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records;
record BorefieldData
  "Record containing all the subrecords which describe all parameter values of the borefield"
  extends Modelica.Icons.Record;

  replaceable record Soi = Soil constrainedby Soil annotation (
      __Dymola_choicesAllMatching=true);
  Soi soi;

  replaceable record Fil = Filling constrainedby Filling annotation (
      __Dymola_choicesAllMatching=true);
  Fil fil;

  replaceable record Gen = General constrainedby General annotation (
      __Dymola_choicesAllMatching=true);
  Gen gen;

  parameter Real loaPerMBor_nominal(unit="W/m") = 40
    "Nominal thermal load per meter borhole depth";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=gen.m_flow_nominal_bh*gen.nbBh/
      gen.nbSer "Total nominal flow to the borefield";
  parameter Modelica.SIunits.Power PThe_nominal=gen.hBor*gen.nbBh*loaPerMBor_nominal
    "Nominal thermal power of the borefield";

  parameter String pathMod=
      "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records.BorefieldData"
    "Modelica path of the record";
  parameter String pathCom=Modelica.Utilities.Files.loadResource(
      "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/Records")
    "Computer path of the record";

  annotation (Documentation(info="<html>
 <p>Record containing all the subrecords which describe all parameter values of the borefield and record path.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end BorefieldData;
