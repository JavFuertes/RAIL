# Algorithmic structural health monitoring of railway infrastructure

### Background
Railway has become an increasingly popular transportation mode all over the world. In the Netherlands, the railway network reaches up to 3223 km in total and transports millions of passengers and million tonnes of freight every year. In recent decades, the Dutch railway keeps evolving to be safer, faster, and greener to become more competitive with air and road transport. The condition of railway tracks affects the safety, ride comfort, and sustainability of train operations. To achieve this goal, the health condition of railway tracks needs to be timely and properly maintained.

|<img src="https://cdnstorevoestalpine.blob.core.windows.net/images/815857/Open_CMS_Lightbox/roadmaster-visualisation.jpg" width="800">|
|:----------------------------------------------------------------------:|
| **Figure 1:** Hypothetical scheme of smart railway infrastructure |


**Figure 2** shows a typical modern railway track structure. The rails are fixed on the sleepers by fasteners (consisting of rail pads and clamps). Rail pads are made of resilient material. The ballast layer also provides elasticity for the track structure. The stiffness of these two components determines the overall track stiffness. In practice, track stiffness can be measured by a non-destructive hammer test, as shown in **Figure 2**. The rail head is excited with a hammer, and the dynamic response (usually acceleration) is measured at the location of interest. Then, the input force and output accelerations are used to calculate a frequency response function (FRF), from which the track stiffness can be identified. 

The main components **which** contribute to the track stiffness are,

1. *Rail* are the members of the track laid in two parallel lines to provide an unchanging, continuous, and level surface for the movement of trains. They are made of high-carbon steel. Rails provide a pathway which is smooth and has very little friction and act as a lateral guide for the wheels. They bear the stresses developed due to vertical loads transmitted to them by the axles and wheels of rolling stock as well as due to braking and thermal forces. They transmit the load to a large area of the formation through sleepers and the ballast.

2. *Sleepers* are the transverse ties that are laid to support the rails. They transmit the wheel load from the rails to the ballast, acting as an elastic medium. They hold the rails in their correct gauge and alignment.

3. *Rail pads* are elastic material typically made of rubber provided between the rails and the sleepers to absorb shocks, dampen vibration, provide electric isolation and prevent the abrasion of the bottom surface of the rail against the sleeper. 

4. *Ballast* is a layer of granular material placed and packed below and around sleepers for distributing load from the sleepers to the formation. It provides drainage, longitudinal and lateral stability to the track. It provides a level and hard bed for the sleepers to rest on and transfers and distributes load from the sleepers to a large area of the underlying soil. It also provides elasticity and resilience to the track for proper riding comfort. 

5. *Stratified Material* or Formation is the prepared flat surface, which is ready to receive the ballast, along with sleepers and rails. The formation supports the entire track structure. It bears the load transmitted to it from the ballast. And facilitates drainage while providing overall stability to the track. 

| ![Figure 1](_Alt/Figures/Figure_1.png)|
|----------------------------------------|
|**Figure 2,3 & 4:** Typical arrangement of a railway track & a hammer test on a railway track. | 


### Details

This study makes use of a 3D finite element model, as shown in <b>Figure 3</b>. The total length of the track model is 12 m with 20 sleeper spans. The rail and sleepers are meshed with Timoshenko beam elements. The fasteners are modelled using the Kelvin-Voigt (KV) model with an elastic spring and viscous damper connected in parallel. The ballast layer is modelled as discretely distributed KV models under each sleeper node. The elastic spring elements in KV models are derived from the stiffness property of fasteners and ballast layer. Accordingly, the viscous dampers represent the damping effects of the fasteners and ballast layer.

<blockquote>

**Project Objective:** To firstly perform an investigation into the response and behaviour of multiple railway samples and determine if we can remotely monitor the structural condition of railway infrastructure through its response to excitation. And in the second place, to develop an algorithmic approach to determine the condition of railway infrastructure at different locations.

</blockquote>

| ![Figure 3](_Alt/Figures/Figure_3.png)|
|----------------------------------------|
| **Figure 5:** Mechanical scheme of the Finite element model. | 

## 1. A breakdown of the investigation and algorithm structure

We firstly begin by understanding and plotting the lab data two hammer tests where conducted on the same sample and the FRF was also measured. Therefore we first examine firstly the hammer test data for the different laboratory sample and then follow by plotting the response function for the railway locations and the laboratory sample we can see observe the influence of the complex response on the location of peaks due to the elastic damper of the Kelvin-voigt model.   

| ![Figure 4](_Alt/Figures/Graphs/IH_tests.png) | ![Figure  5](_Alt/Figures/Graphs/ht_target_signal.png) |
|----------------------------------------|----------------------------------------|
|**Figure 6:** Laboratory hammer tests data. |**Figure 5:** Laboratory and railway Frequency response function |  

We then continue by investigating the below two stiffness distributions of multiple measurement locations and the expected stiffnesses for rail stiffness (Kr) and ballast stiffness (Kb) components of healthy railway locations. From observation we can deduce fitting Gumbel, Log Normal may be most suitable. After fitting different distribution we then evaluate there suitableness through evaluating the value 'ks_statistic' or 'sumsquare_error'; the lower the value of 'ks_statistic' and 'sumsquare_error', the better is the fit of the distribution. The results where the following,

| ![Figure 6](_Alt/Figures/Graphs/KB_distribution.png) | ![Figure 7](_Alt/Figures/Graphs/KR_distribution.png) |
|----------------------------------------|----------------------------------------|
|**Figure 7:** Fitted distributions for ballast components stiffness. |**Figure 7:** Fitted distributions for rail components stiffness |  

**Kr Distribution**: The Kolmogorov Smirnov test for the rail stiffness indicates that the Type I Gumbel distribution indicates the best fit. By contrary through the mean square error metric we would assume the Normal distribution would be the best fit which also the case according to the the ks_statistic which can be chosen as our distribution. Given the characteristics of both distribution since we are interested in capturing the greatest number of sample and perhaps may forego the precision of extreme values in the tails, we will assume the **Kr** to be best represented through a Normal distribution.

**Kb Distribution**: In this case we have an opposite scenario as opposed to the rail stiffness the ks_statistic values suggest normal distribution as the best fit however, but in this case the mean square error suggests that the lognormal distribution would be the best distribution. Since we can observe the distribution  is slightly skewed to the left in this case we believe a lognormal distribution best fits the samples.

|              | **Rail Stiffness** |                   | **Ballast Stiffness** |                   |
|--------------|------------------------|-------------------|--------------------|-------------------|
| Distribution       | Mean                   | Std               | Mean               | Std               |
| **Normal**         | **7.563600e+08**           | **3.220440e+08**      | 7.563600e+08      | 3.220440e+08      |
| gumbel_l           | 9.188854e+08           | 3.127422e+08      |                    |                   |
| gumbel_r           | 5.975530e+08           | 2.935236e+08      | 9.188854e+08      | 3.127422e+08      |
| **Lognormal**      |                        |                   | **5.975530e+08**      | **2.935236e+08**      |

**Table 1**: Mean and standard deviation for ballast stiffness samples (Lognormal distribution) and rail stiffness samples (Normal distribution) 

### Track stiffness monitoring investigation

We know continue performing a small parametric study in order to further understand the sensitivity of different parameters to the response of a railway location under impact or some form of excitation. To do so we begin by investigating three scenarios to assess the frequency responses from the FE model.

Performed scenarios:
> Scenario 1: Equally spaced stifnesses for both ballast and Stiffener with a Mean & standard deviation of: <br>
```np.linspace(kp-kp*0.5, kp+kp*0.5, n)``` and ```np.linspace(kb-kb*0.5, kb+kb*0.5, n))```<br>
> Scenario 2.1: Constant Fastener stiffness with a value of ```500e6``` and equally spaced distributed ballast stiffness of:<br>
```np.linspace(kb-kb*0.5, kb+kb*0.5, n))```<br>
> Scenario 2.2: Constant Ballast stiffness with a value of ```100e6``` and equally spaced ballast stiffness of: <br>
```np.linspace(kp-kp*0.5, kp+kp*0.5, n))```

The results of the study are the following,

| ![Figure 8](_Alt/Figures/Graphs/FRF_sensitivity_analysis.png) |
|---------------------------------------------------------------|
|**Figure 8:** Solutions to the Frequency response function parametric study. | 

A breakdown of the behaviour of the frequency response function is the following. Peaks indicate the presence of the natural frequencies of the structure under test ie Resonance. For a ballasted track, between every pair of resonant frequencies, an anti-resonant frequency can be expected. A typical anti-resonant frequency is observed in discretely supported tracks with two elastic layers.

The lowest possible vertical resonant frequency of the track structure is the full track resonance (ft). It is characterised by all suspended mass of the track structure, moving in vertical direction relative to the infinitely stiff boundary of the structure. Whereas ballasted tracks have full track resonant frequencies of 40 to 140 Hz
A second vertical resonant frequency (fb) is found when considering track structures with baseplates mounted on block supports or on sleepers. The vibration mode shape is comparable to the full track vibration mode, namely a long bending wave, as shown in Figure 3-2. Typical resonant frequencies of this vibration mode are between 100 and 400 Hz.

Another vertical vibration mode describes the rail, vibrating relative to the supports. This rail resonant frequency (ft) heavily depends on the railpad properties and is between 250 and 1500 Hz. For frequencies below 500 Hz, bending of the rails is the dominating vibration mode shape, whereas ben- ding plus shear determine the mode shape at resonant frequencies higher than approximately 500 Hz. 

The pin-pin resonance (fmm) is a clear mark in the mid-span receptance. This resonance is located in the same range in which the rail resonance can occur. The resonant frequency is a function of the rail properties and the support spacing and is hardly sensitive towards stiffness properties. Pin-pin resonant frequencies have been found between 500 Hz and 1200 Hz. For a longer support spacing, the resonant frequency decreases. The conformity in length of a few neighboring spans is important for the sharpness of the resonant peak.

### Accounting for the uncertainty in component stiffness

As we initially observed there is a substantial range of stiffnesses the twp main railway stiffness components can have whilst remaining evaluated as healthy locations. After having performed the parametric study we now aim to quantify the effects of this uncertainty and determine the range under which the FRF may still take whilst remaining as a healthy location.  

We therefore investigate firstly for different mesh sizes 1: Small and 2: Big mesh sizes on the different receptance bounds low [10Hz - 100Hz] and high [300Hz - 900Hz] over which we perform to scenarios:

- Analysis 1: Sumation of all values within bound.
- Analysis 2: Sumation of all values excluding natural frequencies

The  results of the investigation where the following,

| ![Figure 9](_Alt/Figures/Graphs/MC_simul_results.png)         |
|---------------------------------------------------------------|
| **Figure 9:** Histrogram plot monte carlo simulation study on receptance bounds. | 

The results of the monte carlo study where quite comforting since they demonstrate that the response of the FRF is to a large extent similar to the stiffness samples since they follow the same distributions. Therefore we can assume that the specified bound locations are quite robustly the locutions where if nearby peaks are detected we can assume healthy railway locations to be indentified. Moreover the investigation into the mesh size influence is also comforting since it demonstrates little influence on non exploded results (corresponding to the natural frequencies), in which case we can observe that a more refined mesh requires the frequency response to be much closer for resonance to occur. Therefore in reconstruction or estimation the finer the mesh the more robust a solution will be since the actual response may be better reproduced.

### Investigation into the capability of the `TRACK v3.0` x Kelvin-Voigt model through Matlab signal processing capabilities against the laboratory results. 

We now average the monte carlo simulation response for a small and coarse mesh and compare it against the laboratory results. We can observe how the residuals are relatively small and decay at the same time as the signal does. This just refers to the importance of adequately predicting the first resonant peak in adequately reconstructing the signal.


| ![Figure 10](_Alt/Figures/Graphs/MC_residuals.png)            |
|---------------------------------------------------------------|
| **Figure 10:** Histrogram plot monte carlo simulation study on receptance bounds. | 

## 2. The detection algorithm 

We not therefore implement all the gained understanding from the laboratory signal behaviour and samples distribution and aim to implement through a gradient based method to converge to the solution. The problem statement can be broken down as follows,

| Problem | Target variable $t$ | Predictor variable $x$ | Predicted Datasets |
| :-- | :-- | :-- | :-- |
| Determining railway component stiffnesses | Rail stiffness [**Kr**] & Ballast stiffness [**Kb**] | Location and magnitude of peak Receptance & frequency | 1. RAIL_target_frf_1.csv<br> 2. RAIL_target_frf_2.csv |

We make use of the peakdetect module to detect the peaks within the specified `lookahead`, we initially carry this out for the FRF to be reconstructed and we determine the ballast and rail frequencies we aim to converge to. We then initiate a loop whose escape clause is determined by the difference between both frequencies being less than the prescribed `tolerance` . We then therefore then iterate and manually calibrate some weights to improve the speed of the convergence. In this case we decide to conservatively initiate low stiffnesses for both components and set greater step sizes whenever the stiffness is being under-determined and a smaller time step when we see a change in the ratio of Predicted/Laboratory we additionally also from a few runs calibrate the solver to have a smaller step size when determining the rail stiffness since the frequencies are more sensitive to stiffness changes than in comparison to ballast stiffnesses. As can be seen from **TABLE 3** this method works well and the convergence of the method is relatively fast with the eventual FRF being quite similar. 

```python
def inv_solver(DATA_LAB,Frequency_LAB,Kr_guess,Kb_guess,num_elem_slp,step_size, tolerance):
    '''
    Inverse solver for stiffness reconstruction.
    
    Parameters:
        DATA_LAB (array): Location frequency response function.
        Frequency_LAB (array): Frequency array.
        Kr_guess (float): Initial guess for rail stiffness.
        Kb_guess (float): Initial guess for ballast stiffness.
        num_elem_slp (int): Mesh size.
        step_size (float): Gradient step size.
        tolerance (float): Acceptable difference against actual solution [Hz].
        
    Returns:
        Kr (float): Reconstructed rail stiffness.
        Kb (float): Reconstructed ballast stiffness.
        
    The function aims to reconstruct stiffness parameters Kr and Kb based on the given data.
    It iteratively adjusts Kr and Kb until the simulated frequencies match the laboratory frequencies within the specified tolerance.
    The reconstructed parameters are returned, and a plot comparing laboratory and simulated data is generated.
    '''
    print(f'Stiffness inverse problem reconstructor')
    i = 0
    Kr = Kr_guess 
    Kb = Kb_guess

    labdata_peaks = peak_solver(DATA_LAB)
    freq_kb_lab = labdata_peaks[0] 
    freq_kr_lab = labdata_peaks[1]
    # ---------------------- INITIALISING LOOP VARIABLES --------------------- #
    freq_kr_sim = 0
    freq_kb_sim = 0

    while not m.isclose(freq_kb_sim , freq_kb_lab, abs_tol = tolerance) and not m.isclose(freq_kr_sim, freq_kr_lab, abs_tol = tolerance):
        i += 1 #Obtain data with ML Engine
        DATA_SIM,f=eng.black_box_model(Kr , Kb ,num_elem_slp,nargout=2)
        # --------------------------- FINDING PEAKS -------------------------- #
        simuldata_peaks = peak_solver(np.reshape(np.abs(DATA_SIM).real , len(DATA_SIM)))
        freq_kb_sim = simuldata_peaks[0]
        freq_kr_sim = simuldata_peaks[1]
        # --------------------------- SEARCHER LOOP -------------------------- #
        if (freq_kb_sim / freq_kb_lab) < 1:
            Kb += step_size*2e6  #Kb exhibits greater sensibility 
        if (freq_kb_sim / freq_kb_lab) > 1:
            Kb -= step_size*1e6
        print(f'Kb new {Kb}')
        
        if (freq_kr_sim / freq_kr_lab) < 1:
            Kr += step_size*1e6 #Kr exhibits less sensibility
        if (freq_kr_sim / freq_kr_lab) > 1:
            Kr -= step_size*0.5e6 #Smaller reversed step for faster convergence
        print(f'Kr new {Kr}')
    
    # ------------------------ MINOTRING FUNCTIONALITIES --------------------- #
    DATA_SIM = np.array(np.abs(DATA_SIM))
    DATA_SIM = np.reshape(DATA_SIM.real , len(DATA_SIM))
    interp_arr = np.interp(np.linspace(0, Frequency_LAB[-1], len(Frequency_LAB)), np.ravel(np.array(f)), DATA_SIM , len(DATA_SIM))

    fbt = plt.fill_between(Frequency_LAB,DATA_LAB,interp_arr, 
                                alpha=0.2, edgecolor='#00B8C8', facecolor='#00B8C8',
                                linewidth=0, label = 'Residuals between simulation and Laboratory')

    plt.plot(DATA_LAB, label = "Laboratory Data", color="#00A6D6",linestyle = "dotted")
    peak_data_plotter(DATA_LAB,labdata_peaks,"Lab Data")
    peak_data_plotter(np.abs(DATA_SIM),simuldata_peaks,"Simulation Data",Kr,Kb)
    print(f'Total runs {i},with solutions \n Lab DATA | Kr: {(Kr):.2E} Kb: {(Kb):.2E}\n With frequencies | {freq_kb_sim}[HZ] {freq_kr_sim}[HZ], ')

    return Kr, Kb
```
Nevertheless, the author acknowledges some lackings in this approach which could be evaluated if in different scenarios these prove necessary. Firstly the gradient based method can be significantly improved by having automaticaly adjusted step sizes through a ratio against the prediction stiffness, since with the current method it is a possibility that a combination of prescribed `tolerance` and `step_size` be such that the algorithm doesn't converge. Moreover, the `TRACK_v3.0` makes also use of the number of sleepers when calling the `black_box_model` therefore this method is currently omiting   necessary in reconstructing the actual state of the railway. It is possible that such incorporations could make this approach faster and more robust although for now they have not been deemed necessary.  

| Sample         | Reconstruction run     |
|----------------|------------------------|
| Sample 1       | ![Sample 2 Reconstructions](_Alt/Figures/Graphs/Reconstruction/reconstruction2/reconstruction_s2.gif)         |
| Sample 2       | ![Sample 2 Reconstructions](_Alt/Figures/Graphs/Reconstruction/reconstruction1/reconstruction_s1.gif)         |

**Table 3**: Implementation of the reconstruction algorithm to predict railway component sitffness

The algorithm was run timed through the `%%timeit` magic command from Jupyter lab. The timing of both of the solver in both runs was the following,

| Sample       | Time [s]  | Standard Deviation [s]  |
|--------------|-----------|-------------------------|
| Sample 1     | 30.2 s    | ± 4.8 s                 | 
| Sample 2     | 36.3 s    | ± 8.4 s                 |

**Table 4**: Effectiveness of the reconstruction algorithm for both samples.

It is important to note that the effectiveness of the solution is to a great extent determined by the stiffness guesses `kb_guess` and `kr_guess` and also by the determined `tolerance` and `step_size` but in the case of Sample 1 and Sample 2 not much tweaking was done to the hyperparameters and the solution was still stable and relatively fast.

## 3. Results - What is the structural health assesment of the examined railway locations  

We remember that the aim of this project was to construct a method capable of determining structural health of railway segments through trying to inversely determine the stiffness of its components. We then made use of a series of measurements of healthy railway locations to determine that the stiffnesses of both components can be characterised by the following distributions and the following parameters.

|              | **Rail Stiffness**     |                   | **Ballast Stiffness** |                   |
|--------------|------------------------|-------------------|--------------------|-------------------|
| Distribution | Mean                   | Std               | Mean               | Std               |
| Normal       | 7.563600e+08           | 3.220440e+08      | N/A                | N/A               |
| Lognormal    | N/A                    | N/A               | 5.975530e+08       | 2.935236e+08      |

**Table 5**: Determined Component values for distributions

We then through means of the FE Module TRACK_v3.0 the signal processing matlab module and the optimisation algorithm built with these two. We were able to reconstruct the frequency response functions for both track locations and determine that there stiffnesses where,

|              | **Rail Stiffness**   | **Ballast Stiffness**|
|--------------|----------------------|--------------------|
| **Sample 1** | 5.500e+08            | 8.00e+07           |
| **Sample 2** | 4.7500e+08           | 6.00e+07           |

**Table 6**: Predicted sample stiffnesses for Sample 1 and Sample 2

We then calculate the likelihood of these locations undergoing structural failure through by determining the confidence interval the lie within where we require a 95th percentile confidence interval ($z \approx 1.96$) to assess a location as faulty. We now evaluate the **Rail stiffness** assuming a normal distribution with parameters in **TABLE 1** samples we obtain the samples are situated at,

$$
\begin{aligned}
PR_1 & \approx \left(1 - \frac{1}{2} \left(1 + \text{erf}\left(\frac{5.5 \times 10^8 - 7.56 \times 10^8}{3.22 \times 10^8 \times \sqrt{2}}\right)\right)\right) \times 100 >\\
\text{erf}(-0.452) & \approx -0.177 \\
\text{Sample 1 percentile} & \approx 58.9\%
\end{aligned}
$$

$$
\begin{aligned}
PR_2 & \approx \left(1 - \frac{1}{2} \left(1 + \text{erf}\left(\frac{4.75 \times 10^8 - 7.56 \times 10^8}{3.22 \times 10^8 \times \sqrt{2}}\right)\right)\right) \times 100 >\\
\text{erf}(-0.615) & \approx -0.266 \\
\text{Sample 2 percentile} & \approx 63.3\%
\end{aligned}
$$

Evaluating the **Ballast stiffness** samples through a lognormal distribution with parameters from **TABLE 1** with as well not presented but evaluated kurtosis parameter of 0.2443 we obtain,

$$
\begin{aligned}
PR_1 \approx \left(1 - \text{erf}\left(\frac{\ln(8 \times 10^7) - 5.97 \times 10^8}{\sqrt{2} \times 2.935 \times 10^8}\right)\right) \times 100 \\
\text{Sample 1 percentile} & \approx 0\%
\end{aligned}
$$

$$
\begin{aligned}
PR_2 \approx \left(1 - \text{erf}\left(\frac{\ln(6 \times 10^7) - 5.97 \times 10^8}{\sqrt{2} \times 2.935 \times 10^8}\right)\right) \times 100 \\
\text{Sample 2 percentile} & \approx 0\%
\end{aligned}
$$

Therefore we can observe how both railway locations are at a similar state of decay. We can determine that the rail components are in good condition for both samples, or better said the undergone deterioration is insuffcient to be determined as faulty. By contrast we can also evaluate that the ballast stiffnesses demonstrate extreme deterioration and completely lie outside the confidence interval and the distribution of measurements of healthy ballast locations. Since the stiffness is much lower (as in most structural deterioration issues) **we can determine that there is a loss of support at these locations and that maintenance should be carried out at these locations**.  

## Repo structure and contents
- _Alt Includes old files and figures used to make the repo and notebook.
- **TRACK_v3.0**: A finite element code that computes the frequencies response function of the railway by making use of the Kelvin-Voigt model, this module is in programmed in Matlab and requires de signal processing Matlab addon module.
- **data**: Where all laboratory and simulation results where stored and available for reproduction of the results
- **RAIL01**: A Jupyter notebook containing the analysis and the implementation of the algorithm itself.

### Useful links
Original insipirational reference:
- Fast and robust identification of railway track stiffness from simple field measurement: [https://doi.org/10.1016/j.ymssp.2020.107431](https://doi.org/10.1016/j.ymssp.2020.107431)
