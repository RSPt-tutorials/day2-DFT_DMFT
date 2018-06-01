# day2-DFT_DMFT
DFT+SPTF for bcc Fe

#### 0. Setup simulation for bcc Fe
Setup simulation for spin-polarized bcc Fe as we did on day1, or copy the setup from yesterday.

#### 1. Converge DFT 
Converge the DFT cycle as we did on day1, or copy the converged simulation from yesterday.

#### 2. DFT+SPTF
Now we will do new things, namely combining DFT with the SPTF impurity solver for the 3d orbitals in a charge self-consistent (csc) fashion. 
We always add a `green.inp` file when doing DFT+DMFT.
In this case the `green.inp` file should contain:
```bash
!matsubara
!1024  60  60  10

inputoutput
T T

convergency
1d-6 1d-5 999 999

!energymesh
!1001 -1.0 1.0 0.001

projection
2

verbose
Solver Dc Projection Interface

!spectrum
!Dos Pdos

cluster
1 2 eV                  ! ntot udef [nsites]
1 2 1 1 0 3.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
1 -1 0.1                ! solv DC sigma_mix [symbrk]
1 1000 1e-9 0.1d0          ! # sptf_mode sptf_niter sptf_conv sptf_mix
.false.                   ! # spin_average
```
Run csc DFT+SPTF until convergence.  
For an explaination of the keywords in the `green.inp`-file, check the `documentation/manual/` folder in the RSPt repository.

#### 3. PDOS
Uncomment the spectrum block and change the number of DMFT-solver iterations to 0 and the number of total DMFT-iterations to 1 in the `green.inp`-file. It should now look like:
```bash
!matsubara
!1024  60  60  10

inputoutput
T T

convergency
1d-6 1d-5 1 0

!energymesh
!1001 -1.0 1.0 0.001

projection
2

verbose
Solver Dc Projection Interface

spectrum
Dos Pdos

cluster
1 2 eV                  ! ntot udef [nsites]
1 2 1 1 0 3.0 0.9       ! t l e site basis[cubic harm] U J or F0 F2 F4 (F6)
1 -1 0.1                ! solv DC sigma_mix [symbrk]
1 1000 1e-9 0.1d0          ! # sptf_mode sptf_niter sptf_conv sptf_mix
.false.                   ! # spin_average
```
Run `rspt` once to get `DOS` and `PDOS`.

#### 4. Analyze output
Compare total energy and PDOS with the help folder `sptf-spectrum` and with the DFT results.
