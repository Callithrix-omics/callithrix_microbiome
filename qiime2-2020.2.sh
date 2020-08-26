source activate qiime2-2020.2

 #all samples 
 qiime diversity adonis \
 --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula sex \
 --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/sex_weighed_unifrac_adonis.qzv
 qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/sex_weighed_unifrac_adonis.qzv
 
 qiime diversity adonis \
 --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula captive \
 --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/captive_weighed_unifrac_adonis.qzv
 qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/captive_weighed_unifrac_adonis.qzv
 
 qiime diversity adonis \
 --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula species \
 --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/species_weighed_unifrac_adonis.qzv
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/species_weighed_unifrac_adonis.qzv


 #all no hybrids 
 qiime diversity adonis \
 --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file microbiome/metadata/gut_metadatav5.txt \
 --p-formula sex \
 --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/sex_weighed_unifrac_adonis.qzv

 qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/sex_weighed_unifrac_adonis.qzv
 
 qiime diversity adonis \
 --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula captive \
 --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/captive_weighed_unifrac_adonis.qzv
 qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/captive_weighed_unifrac_adonis.qzv
 
 qiime diversity adonis \
 --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula species \
 --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/species_weighed_unifrac_adonis.qzv
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets_nohybrids/species_weighed_unifrac_adonis.qzv

 
 
 