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

Interesting generated files:
- `out` - contains also DMFT information. Everything inbetween two `BRIANNA` statements is DMFT related. and roughly has this structure:
   1. Interface information of DFT and DMFT with the title: 
```
+---------------------------- BRIANNA --------------------------------+

 ***********************************************
      Initialization of the DMFT code
 ***********************************************
```
  2. Many variables are set by (conservative) defaults and input information, listed below this banner:
```
 ***********************************************
     Formated and processed input data
 ***********************************************
```
  3. Cluster information. Each cluster has a ID-tag of the format: type, l, energy-set, site, basis-type. Local hamiltonian and local overlap are printed.
  4. Read-information about the self-energy.
  5. DMFT-iteration information
  6. Green's function summary after all iterations. Spin and orbital moments, occupation, Galitskii-Migdal energy, etc..
  7. End of DMFT part:
```
 ################################################
       Hurray! The DMFT cycle is converged!
 ################################################

 green_cycle: The charge self-consistency will generate a new LDA Hamiltonian.

 +---------------------------- END OF BRIANNA -----------------------------+
```

- `dmft_hist` - contains a summary of DMFT interation information.
- `sig` - contains the self-energy. Stored in a binary format so can not be opened with a text editor. 

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
