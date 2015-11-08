===================
Annex60 Pipe models
===================

Introduction
------------
This file contains information about the aim of the ``Annex60.Experimental.Pipe`` subpackage and an overview of the development history of the plug flow pipe models. The ``Pipe`` package is developed within the IEA EBC Annex 60.

Aim
---
The ``Pipe`` package is intended as an improvement of the Modelica Standard Library pipes for the specific case of thermal network (district heating and cooling) simulations. The pipe model aims at improving the representation of the delay effects in longer pipes and at accelerating the simulation of such pipes.

Problems that were previously encountered with the existing pipe models include the inability to represent the delay of temperature changes at the inlet of the pipe and the corresponding heat losses.
The current MSL implementation uses one or more mixing volumes (more in case of discretization). This way of modelling is not able to represent the plug flow behaviour, which requires a time delay depending on the fluid velocity and the length of the pipe. The mixing volume approach shows an exponential transition between temperatures instead, whereas the discretized approach causes numerical diffusion effects in the outlet temperature.

.. math::
	\\frac{\\partial\\left(\\rho h A\\right)}{\\partial t} + \\frac{\\partial\\left(\\rho vAh\\right)}{\\partial x}  = - \\dot{Q}_e \\label



Development history
-------------------







File history
------------

- First version by Bram van der Heijde, November 8 2015.

