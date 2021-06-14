
## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)


# Please see attached the dataset for the FEV1 variability project. 
# I have attached a data dictionary to explain the variables that are 
# not self-explanatory. 
# 
# COPDGene has 3 visits. 
# Approximately 10K in P1 (Phase 1), 6.5K in P2 and about 2K so far in P3. 
# 
# Some of the CT variables are different ways of measuring the same thing. 
# I realized something after we spoke. There are some variables such as height 
# which is known to explain a large share of FEV1, so may "eat into" the 
# explanation by other variables that are associated with disease. But that 
# high explanation is in normals and not smokers with disease. If you think it 
# would be better, we can use FEV1%predicted as the outcome which adjust for 
# age, gender height, and race. Perhaps this will make the models cleaner? 

#   The finalGOLD category includes codes for normals and non-normals. 
#   Maybe we should just look at non-normals? 
#   Gold stage -2= normals, Rest can be used as cases. 
#   Please note that the IDs include some participants enrolled at P2 
#   (all normals GOLD = -2) who will have missing FEV1 and CT values at P1. 
# 
# Maybe the following models will be good to start with.
# 
# Cross-sectional models:
#   Outcome: FEV1_post_P1
# 
# Model 1: 
# (This includes most commonly calculated measures on inspiratory CT alone)
# Pct_Emph_P1 (this can also be substituted by Perc15_Insp_P1 which is a more 
#              continuous measure compared with %emphysema                                 
#              which dichotomizes each voxel into emphysema yes/no)
# Pi10_P1 (this can be substituted by WallAreaPct_seg_P1)
# 
# Model 2: (This includes inspiratory and expiratory measures)
# PRM_pct_emphysema_P1
# PRM_pct_airtrapping_P1
# Pi10_P1
# 
# Model 3: (This includes many more advanced metrics)
# PRM_pct_emphysema_P1
# PRM_pct_airtrapping_P1
# Pi10_P1
# NDEI_P1
# meanJAC_P1
# pct_MAL2MM_P1
# TAC_P1
# AirwayVolume_P1
# AFD_P1
# HydraulicD_seg
# 
# +/- SAV_P1
# (I added this last as this measure is affected by both AIRWAY NARROWING 
# as estimated by HydraulicD_seg and airway volume as well as  AIRWAY LOSS 
# as estimated by TAC)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(

  image_metrics = read_csv("data/Imaging Metrics 1.10.2021.csv"),
  
  m1 = fit_lm(
    data = image_metrics, 
    vars_outcome = 'FEV1_post_P1',
    vars_control = c('pctEmph_P1',
                     'Pi10_P1')
  ),
  
  m2 = fit_lm(
    data = image_metrics, 
    vars_outcome = 'FEV1_post_P1',
    vars_control = c('pctEmph_P1',
                     'Pi10_P1',
                     'PRM_pct_emphysema_P1',
                     'PRM_pct_airtrapping_P1',
                     'Pi10_P1')
  ),
  
  m3 = fit_lm(
    data = image_metrics, 
    vars_outcome = 'FEV1_post_P1',
    vars_control = c('pctEmph_P1',
                     'Pi10_P1',
                     'PRM_pct_emphysema_P1',
                     'PRM_pct_airtrapping_P1',
                     'Pi10_P1',
                     'PRM_pct_emphysema_P1',
                     'PRM_pct_airtrapping_P1',
                     'Pi10_P1',
                     'NDEI_P1',
                     'meanJAC_P1',
                     'pct_MAL2MM_P1',
                     'TAC_P1',
                     'AirwayVolume_P1',
                     'AFD_P1',
                     'HydraulicD_seg')
  ),
  
  model_coef_data = make_model_coef(models = c(m1, m2, m3)),
  
  r2_partial_data = make_r2_partial(models = c(m1, m2, m3)),
  
  model_table = tabulate_model_values(
    data = left_join(model_coef_data,
                     r2_partial_data)
  ),
  
  tar_render(report, "doc/report.Rmd")
  
)
