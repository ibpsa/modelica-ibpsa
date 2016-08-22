IDEAS v0.3.0
============

Modelica model environment for Integrated District Energy Assessment Simulations (IDEAS), allowing simultaneous transient simulation of thermal and electrical systems at both building and feeder level.

### Current release

The current release is v0.3, which has been pushed on 2 september 2015. Major changes compared to v0.2 are:

1. Added code for checking conservation of energy
2. Added options for linear / non-linear radiative heat exchange and convection for exterior and interior faces of walls and floors/ceilings. Respective correlations have been changed.
3. Overall improvements resulting in more efficient code and less warnings.
4. The emissivity of window coatings must now be specified as a property of the solid (glass sheet) and not as a property of the gas between the glass sheets. This is only relevant if you create your own glazing.
5. Merged Annex 60 library up to commit d7749e3
6. Expanded unit tests
7. More correct implementation of Koschenz's model for TABS. Also added the option for discretising TABS sections.
8. Added new building shade components.
9. Removed inefficient code that would lead to numerical Jacobians in grid.
10. Added new AC and DC electrical models.



### License

The **IDEAS** package is licensed by [KU Leuven](http://www.kuleuven.be) and [3E](http://www.3e.eu) under the [Modelica License Version 2](https://www.modelica.org/licenses/ModelicaLicense2).

### Development and contribution

1. You may report any bugfixes or suggestions as a [github issue](https://github.com/open-ideas/IDEAS/issues).
2. Contributions in the form of [Pull Requests](https://help.github.com/articles/using-pull-requests) are always welcome. Prior to issuing a pull request, make sure :
    1. your code follows the [Style Guide and Conventions](https://github.com/open-ideas/IDEAS/wiki/Style%20Guide%20and%20GitHub%20Good%20Practice),
    2. you use this **IDEAS** GitHub repository as escribed in the [GitHub Good Practice Description](https://github.com/open-ideas/IDEAS/wiki/Style%20Guide%20and%20GitHub%20Good%20Practice)
    3. unittests are included for your models, and
    4. the model physics are described in the [Specifications](https://github.com/open-ideas/IDEAS/tree/master/Specifications).

### References

1. Baetens, R., De Coninck, R., Jorissen, F., Picard, D., Helsen, L., Saelens, D. (2015). OpenIDEAS - An Open Framework for Integrated District Energy Simulations. Proceedings of Building Simulation 2015 - Int. Conference of the Int. Buildings Performance Simulation Association. Hyderabad (India), 7-9 December 2015.
2. De Coninck R., Baetens R., Saelens D., Woyte A., Helsen L. (2014). Rule-based demand side management of domestic hot water production with heat pumps in zero energy neighbourhoods. *Journal of Building Performance Simulation*, **7** (4), 271-288.
3. Baetens R., De Coninck R., Van Roy J., Verbruggen B., Driesen J., Helsen L., Saelens D. (2012). Assessing electrical bottlenecks at feeder level for residential net zero-energy buildings by integrated system simulation. *Applied Energy*, **96**, 74-83.
