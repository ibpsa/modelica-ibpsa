within Annex60.Experimental.ThermalZones;
model ThermalZoneFourElements
  extends ThermalZoneThreeElements;
  BaseClasses.ExtMassVarRC groundMassVarRC1(
    n=nGround,
    RExt=RGround,
    RExtRem=RGroundRem,
    CExt=CGround) if AGroundInd > 0   annotation (Placement(transformation(
        extent={{10,-11},{-10,11}},
        rotation=90,
        origin={10,145})));
end ThermalZoneFourElements;
