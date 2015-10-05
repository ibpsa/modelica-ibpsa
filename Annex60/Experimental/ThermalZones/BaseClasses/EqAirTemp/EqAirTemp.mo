within Annex60.Experimental.ThermalZones.BaseClasses.EqAirTemp;
model EqAirTemp
  "model for equivalent air temperature as defined in VDI 6007-1 with modifications"

  extends
    .Annex60.Experimental.ThermalZones.BaseClasses.EqAirTemp.partialEqAirTemp;
parameter Modelica.SIunits.Angle orientationsWallsHorizontal[n]={1.570796327,1.570796327,1.570796327,1.570796327}
    "Orientations of the walls against the vertical (wall,roof)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaExtOut=24.67
    "Exterior walls' coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWinOut=16.37
    "Windows' coefficient of heat transfer (outdoor)";
parameter Real aWin=0.0 "Coefficient of absorption of the windows";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a eqAirTempWindow
    "equivalent air temperature for windows (no short-wave radiation)"
    annotation (Placement(transformation(extent={{80,58},{100,78}}),
        iconTransformation(extent={{78,6},{118,46}})));

protected
    Modelica.SIunits.TemperatureDifference T_eqLW_win[n]
    "equivalent long wave temperature for windows";
    Modelica.SIunits.TemperatureDifference T_eqSW_win[n]
    "eqiuvalent short wave temperature for windows";
  Real phiprivate[n];
initial equation
  assert(noEvent(abs(sum(wf_wall) + wf_ground - 1) < 0.1), "The sum of the weightfactors (walls and ground) in eqairtemp is <0.9 or >1.1. Normally, the sum should be 1.", level=AssertionLevel.warning);
  assert(noEvent(abs(sum(wf_win) - 1) < 0.1), "The sum of the weightfactors (windows) in eqairtemp is <0.9 or >1.1. Normally, the sum should be 1.", level=AssertionLevel.warning);
equation

  T_earth=((-E_earth/(0.93*5.67))^0.25)*100;
  T_sky=((E_sky/(5.67))^0.25)*100;

  phiprivate = (unitVec+Modelica.Math.cos(orientationsWallsHorizontal))/2;

  T_eqLW=((T_earth-T_air)*(unitVec-phiprivate)+(T_sky-T_air)*phiprivate)*(eExt*alphaRad/(alphaRad+alphaExtOut));
  T_eqLW_win=((T_earth-T_air)*(unitVec-phiprivate)+(T_sky-T_air)*phiprivate)*(eExt*alphaRad/(alphaRad+alphaWinOut)).*abs(sunblind-unitVec);
  T_eqSW=solarRad_in*aExt/(alphaRad+alphaExtOut);
  T_eqSW_win=solarRad_in*aWin/(alphaRad+alphaWinOut);

  if withLongwave then
    T_eqWin=T_air*unitVec+T_eqLW_win+T_eqSW_win;
    T_eqWall=T_air*unitVec+T_eqLW+T_eqSW;
  else
    T_eqWin=T_air*unitVec+T_eqSW_win;
    T_eqWall=T_air*unitVec+T_eqSW;
  end if;

  eqAirTemp.T = T_eqWall*wf_wall + T_ground*wf_ground;
  eqAirTempWindow.T = T_eqWin*wf_win;
  annotation (Documentation(revisions="<html>
<p><ul>
<li><i>October 2014,&nbsp;</i> by Peter Remmen:<br/>Implemented.</li>
<li><i>September 2015,&nbsp;</i> by Moritz Lauster:<br>Got rid of cardinality and used assert for warnings.</li>
</ul></p>
</html>", info="<html>
<p>EqAirTemp extends from partialEqAirTemp</p>
<p>An output equivalent air temperature is calculated for the window.</p>
<p>The longwave radiation is considered for each direction seperately. The sky temperature is adjusted. The combined heat transfer coefficient is replaced by a heat transfer coefficient for convection and radiation, respectively.</p>
<h4>Main equations</h4>
<p>The concept is described in VDI 6007. All equations can be found in VDI 6007 and &QUOT;Modelling long-wave radiation heat exchange for thermal network building simulations at urban scale using Modelica.&QUOT;</p>
<h4>Assumption and limitations</h4>
<ul>
<li>The convective heat transfer coefficient alpha is weighted over the areas per each direction. In VDI 6007, alpha is considered for each element and not averaged per direction. This may cause deviations if the alphas of the single elements are considerabely different. </li>
</ul>
<h4>References</h4>
<ul>
<li>German Association of Engineers: Guideline VDI 6007-1, March 2012: Calculation of transient thermal response of rooms and buildings - Modelling of rooms.</li>
<li>Lauster, M.; Teichmann, J.; Fuchs, M.; Streblow, R.; Mueller, D. (2014): Low order thermal network models for dynamic simulations of buildings on city district scale. In: Building and Environment 73, p. 223&ndash;231. DOI: 10.1016/j.buildenv.2013.12.016.</li>
<li>Lauster, Moritz; Remmen, Peter; Fuchs, Marcus; Teichmann, Jens; Streblow, Rita; Mueller, Dirk (2014): Modelling long-wave radiation heat exchange for thermal network building simulations at urban scale using Modelica. In: the 10th International Modelica Conference, March 10-12, 2014, Lund, Sweden, March 10-12, 2014: Linkoeping University Electronic Press (Linkoeping Electronic Conference Proceedings), p. 125&ndash;133.</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end EqAirTemp;
