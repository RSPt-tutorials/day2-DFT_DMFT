# day2-DFT_DMFT
DFT+U for NiO

#### 0. `symt.inp` in `sym`
Copy and inspect the provided `symt.inp`-file.
Notice that it is a spin-polarized *anti-ferromagnetic* setup:
```
# Sites
atoms
 4
  0.00  0.00  0.00   28  l   up
  0.00  0.00  0.50   28  l   dn
  0.50  0.50  0.25    8  l    a
  0.50  0.50  0.75    8  l    a
```
Create a simulation folder, inside it create a `sym`-folder and then use the `symt`-binary:
```bash
mkdir -p NiO/sym
cd NiO/sym
symt -all
cd ..
```

#### 1. Atomic density in `atom`
Create atomic density:
```bash
cd atom
make
cd ..
```

#### 2. Create k-mesh in `bz`
Create a k-mesh:
```bash
cd bz
cub
```
Follow the instructions and use for an example a `12 12 12`-mesh without Gamma-shift.
Do not forget to select the generated k-mesh. In the parent folder type:
```bash
link_spts 12_no
```

#### 3. `dta`
Copy `lengthscale` and `strain_matrix` to parent folder:
```bash
cp dta/length_scale .
cp  dta/strain_matrix .
```

#### 4. Make `data`-file
In the parent folder, type:
```bash
make data
```
Now edit the `data`-file a bit.

In RSPt the default is to always use two energy-sets. In this system it is not really needed and we can use only one energy-set. 
This is done by moving Ni 3s and 3p basis functions from the second energy-set to the core-states. 
- Start by changing the `nsets`-keyword from 2 to 1. 
- Then remove the second energy-set from the basis of both Ni types:
```
     8 Bases
     0     1     1
     0     1     2
     0     1     3
     1     1     1
     1     1     2
     1     1     3
     2     1     1
     2     1     2
     4     4     3     4     5     6     7     8     9
    20    21     0     0     0     0     0     0     0
     4     4     3     4     5     6     7     8     9
    20    21     0     0     0     0     0     0     0
```
- Occupy the Ni 3s and 3p core-states by increasing the `occ`-values for both Ni-types:
```bash
 (/f6.0, i6, f12.0, 2f6.0, 2x, 2i1, f2.0, 11x, a1//(2i6, f12.0, i12))
     Z    nc      Sinf/S     . Sws/S  ....     ScoFlag
   28.     7          1.    1.    1.  10.0           p
     n     k         occ        flag
     1    -1          2.           0
     2    -1          2.           0
     2     1          2.           0
     2    -2          4.           0
     3    -1          2.           0
     3     1          2.           0
     3    -2          4.           0
```
- Remove the second energy-set also for the oxygen type:
```
     2     2     3     4     5     6     7     8     9
     0     0     0     0     0     0     0     0     0
     2     2     3     4     5     6     7     8     9
     0     0     0     0     0     0     0     0     0
```
- Reduce the number of valence electrons by 8\*2 = 16 electrons since we treat them in the core-states instead. This is done by changing the `zval` keyword from 48 to 32. 
- Change the functional from PBE to LDA by modifying the `icorr`-keyword from 34 to 02.
- Change to Fermi smearing and reduce the temperature:
```
 (i6)
     0
 (/ 2f12.0, i6)
       W(Ry)        dE/W     .
      0.0005          4.     0
```
- Reduce the mixing parameter `pmix` from .5 to .05:
```
  lmax ntype  zval     . icorr     .  pmix   win   wmt f-rel sp-po     .
     8     3  32.0     8    02    1.  .050     t     t     f     t     1
```
- Change so that the muffin-tin radiuses are set in a absoulte way instead of by the corresponding volume. For Ni:
```
 (// i6, 2f12.0, 5x, a1 )
     n           S          dx coord
   543  .826975542       0.025     v
   543  2.02640800       0.025     a
```
For oxygen:
```
 (// i6, 2f12.0, 5x, a1 )
     n           S          dx coord
   479  .705150361       0.025     v
   479  1.72788947       0.025     a
```
- Change the linearization flags. For Ni:
```
     4     4     3     4     5     6     7     8     9
     0     0    -1     0     0     0     0     0     0
     4     4     3     4     5     6     7     8     9
     0     0    -1     0     0     0     0     0     0
```

####  Provide a `green.inp`-file
Provide a `green.inp`-file with content:
```
inputoutput
T T

convergency
1d-6 1d-5 999 999

!energymesh
!1001 -1.0 1.0 0.001

projection
1

verbose
Solver Dc Projection Interface

debug
Renorm_corr

!spectrum
!Dos Pdos

cluster
1 2 eV                  ! ntot udef [nsites]
1 2 1 1 3 8.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1.0                 ! solv DC sigma_mix [symbrk]

cluster
1 2 eV                  ! ntot udef [nsites]
2 2 1 1 3 8.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1.0                 ! solv DC sigma_mix [symbrk]
```

#### Run csc LSDA+U
Run until convergence.

#### DOS
Modify the `green.inp` in order to obtain DOS and PDOS:
```
inputoutput
T T

convergency
1d-6 1d-5 1 0

energymesh
1001 -1.0 1.0 0.001

projection
1

verbose
Solver Dc Projection Interface

debug
Renorm_corr

spectrum
Dos Pdos

cluster
1 2 eV                  ! ntot udef [nsites]
1 2 1 1 3 8.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1.0                 ! solv DC sigma_mix [symbrk]

cluster
1 2 eV                  ! ntot udef [nsites]
2 2 1 1 3 8.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1.0                 ! solv DC sigma_mix [symbrk]
```
Run `rspt` once.

#### Interexchange parameters: Jij

- Modify the `green.inp`-file to:
```
matsubara
1024   60  60   0

inputoutput
T F

convergency
1d-6 1d-5 1 0

!energymesh
!1001 -1.0 1.0 0.001

projection
1

verbose
Solver Dc Projection Interface Jij_Eg_T2g

!spectrum
!Dos Pdos

isoexch
1          ! 1=mt 2=ort
1          ! central site
-3.0       ! radius, should be negative
2
1 2

cluster
2 0              ! ntot udef [nsites]
1 2 1 1 3        ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1 1 3        ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)

cluster
1 2 eV                  ! ntot udef [nsites]
1 2 1 1 3 8.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1.0                 ! solv DC sigma_mix [symbrk]

cluster
1 2 eV                  ! ntot udef [nsites]
2 2 1 1 3 8.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
2 2 1.0                 ! solv DC sigma_mix [symbrk]
```

- Generate a new k-mesh.
```
cp symcof bz/lowsym
cd bz
```
Open `lowsym` and change the number of symmetries to 1 and remove all symmetry matrices except the identity.
Create a new k-mesh (by calling `cub`) and instead of reading from `symcof` read information from `lowsym`.
Make a `12 12 12` k-mesh without Gamma-shift.
Link to the new k-mesh:
```
link_spts 12_no_1
```

- run `rpst` once and look in the `out`-file for the Jij's.

