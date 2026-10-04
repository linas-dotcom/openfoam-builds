#!/usr/bin/env python3
"""Chapman-Jouguet detonation state and constant-pressure flame state with Cantera.

usage: python3 cj.py [fuel] [phi] [T1_K] [p1_bar]
fuel: propane | kerosene (n-dodecane surrogate) | hydrogen | methane    (default kerosene)
Prints CJ speed, pressure, temperature and gamma of the products, plus the adiabatic
flame temperature at constant pressure (deflagration, e.g. a pulse jet).
"""
import sys

import cantera as ct
import numpy as np

FUELS = {  # mechanism, fuel species, O2 per mole of fuel at phi = 1
    "propane": ("gri30.yaml", "C3H8", 5.0, "O2", "N2"),
    "methane": ("gri30.yaml", "CH4", 2.0, "O2", "N2"),
    "hydrogen": ("gri30.yaml", "H2", 0.5, "O2", "N2"),
    "kerosene": ("nDodecane_Reitz.yaml", "c12h26", 18.5, "o2", "n2"),
}


def mixture(fuel, phi):
    mech, f, o2, O, N = FUELS[fuel]
    return mech, f"{f}:{phi}, {O}:{o2}, {N}:{o2 * 3.76}"


def cj_state(mech, X, T1=300.0, p1=ct.one_atm):
    g1 = ct.Solution(mech)
    g1.TPX = T1, p1, X
    h1, v1 = g1.enthalpy_mass, 1 / g1.density
    g2 = ct.Solution(mech)
    best = None
    for ratio in np.linspace(1.3, 2.5, 61):          # density ratio along the equilibrium Hugoniot
        v2, T = v1 / ratio, 2800.0
        g2.TDX = T, 1 / v2, X
        for _ in range(80):                          # h2 - h1 = (p2 - p1)(v1 + v2)/2
            g2.TD = T, 1 / v2
            g2.equilibrate("TV")
            f = g2.enthalpy_mass - h1 - 0.5 * (g2.P - p1) * (v1 + v2)
            g2.TD = T + 1.0, 1 / v2
            g2.equilibrate("TV")
            df = g2.enthalpy_mass - h1 - 0.5 * (g2.P - p1) * (v1 + v2) - f
            T -= f / df
            if abs(f) < 1e-3:
                break
        g2.TD = T, 1 / v2
        g2.equilibrate("TV")
        D = v1 * np.sqrt(max(g2.P - p1, 0.0) / (v1 - v2))   # Rayleigh-line wave speed
        if best is None or D < best["D"]:
            best = dict(D=D, p=g2.P, T=T, gamma=g2.cp / g2.cv, W=g2.mean_molecular_weight)
    return best


def flame_state(mech, X, T1=300.0, p1=ct.one_atm):
    g = ct.Solution(mech)
    g.TPX = T1, p1, X
    g.equilibrate("HP")
    return dict(T=g.T, gamma=g.cp / g.cv, W=g.mean_molecular_weight)


if __name__ == "__main__":
    fuel = sys.argv[1] if len(sys.argv) > 1 else "kerosene"
    phi = float(sys.argv[2]) if len(sys.argv) > 2 else 1.0
    T1 = float(sys.argv[3]) if len(sys.argv) > 3 else 300.0
    p1 = float(sys.argv[4]) * 1e5 if len(sys.argv) > 4 else ct.one_atm
    mech, X = mixture(fuel, phi)
    c, fl = cj_state(mech, X, T1, p1), flame_state(mech, X, T1, p1)
    print(f"{fuel}-air, phi = {phi}, {T1:.0f} K, {p1 / 1e5:.3f} bar  [{mech}]")
    print(f"  CJ detonation: D = {c['D']:.0f} m/s, p = {c['p'] / 1e5:.1f} bar, T = {c['T']:.0f} K, "
          f"gamma = {c['gamma']:.3f}, W = {c['W']:.1f}")
    print(f"  deflagration (const p): T = {fl['T']:.0f} K, gamma = {fl['gamma']:.3f}, W = {fl['W']:.1f}")
