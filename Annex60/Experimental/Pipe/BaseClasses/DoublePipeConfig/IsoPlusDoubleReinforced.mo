within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig;
package IsoPlusDoubleReinforced

  record IsoPlusDR20R "Reinforced DN 20 IsoPlus double pipe"

    extends IsoPlusDouble(
      Di=20e-3,
      Do=26.9e-3,
      h=20e-3,
      Dc=140e-3);
  end IsoPlusDR20R;

  record IsoPlusDR25R "Reinforced DN 25 IsoPlus double pipe"

    extends IsoPlusDouble(
      h=20e-3,
      Di=25e-3,
      Do=33.7e-3,
      Dc=160e-3);
  end IsoPlusDR25R;

  record IsoPlusDR32R "Reinforced DN 32 IsoPlus double pipe"

    extends IsoPlusDouble(
      h=20e-3,
      Di=32e-3,
      Do=42.4e-3,
      Dc=180e-3);
  end IsoPlusDR32R;

  record IsoPlusDR40R "Reinforced DN 40 IsoPlus double pipe"

    extends IsoPlusDouble(
      h=20e-3,
      Di=40e-3,
      Do=48.3e-3,
      Dc=180e-3);
  end IsoPlusDR40R;

  record IsoPlusDR50R "Reinforced DN 50 IsoPlus double pipe"

    extends IsoPlusDouble(
      h=20e-3,
      Di=50e-3,
      Do=60.3e-3,
      Dc=225e-3);
  end IsoPlusDR50R;

  record IsoPlusDR65R "Reinforced DN 65 IsoPlus double pipe"

    extends IsoPlusDouble(
      h=20e-3,
      Di=65e-3,
      Do=76.1e-3,
      Dc=250e-3);
  end IsoPlusDR65R;

  record IsoPlusDR80R "Reinforced DN 80 IsoPlus double pipe"

    extends IsoPlusDouble(
      Di=80e-3,
      Do=88.9e-3,
      h=25e-3,
      Dc=280e-3);
  end IsoPlusDR80R;

  record IsoPlusDR100R "Reinforced DN 100 IsoPlus double pipe"

    extends IsoPlusDouble(
      h=25e-3,
      Di=100e-3,
      Do=114.3e-3,
      Dc=355e-3);
  end IsoPlusDR100R;

  record IsoPlusDR125R "Reinforced DN 125 IsoPlus double pipe"

    extends IsoPlusDouble(
      Di=125e-3,
      Do=139.7e-3,
      h=30e-3,
      Dc=450e-3);
  end IsoPlusDR125R;

  record IsoPlusDR150R "Reinforced DN 150 IsoPlus double pipe"

    extends IsoPlusDouble(
      Di=150e-3,
      Do=168.3e-3,
      h=40e-3,
      Dc=500e-3);
  end IsoPlusDR150R;

  record IsoPlusDR200R "Reinforced DN 200 IsoPlus double pipe"

    extends IsoPlusDouble(
      Di=200e-3,
      Do=219.1e-3,
      h=45e-3,
      Dc=630e-3);
  end IsoPlusDR200R;
end IsoPlusDoubleReinforced;
