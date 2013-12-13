within IDEAS.Electric.BaseClasses.Types;
record ComplexCharacteristicImpedance = Complex (redeclare
      IDEAS.Electric.BaseClasses.Types.CharacteristicResistance re, redeclare
      IDEAS.Electric.BaseClasses.Types.CharacteristicReactance im)
  "Complex Characterisitc impedance";
