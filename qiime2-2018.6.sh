#activate conda environment 
source activate qiime2-2018.6


#import demultiplexed PE data 

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  microbiome/qiime_analysis_remove_duplicate_primers_marmosets \
  --source-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-demux-paired-end.qza

#summarize demultiplexing results 
qiime demux summarize \
  --i-data microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-demux-paired-end.qza \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-demux-paired-end.qzv

qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-demux-paired-end.qzv


#quality filter and join with DADA2 


qiime dada2 denoise-paired \
  --i-demultiplexed-seqs microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-demux-paired-end.qza \
  --o-table microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qza\
  --o-representative-sequences microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs \
  --p-trim-left-f 0 \
  --p-trim-left-r 10 \
  --p-trunc-len-r 220 \
  --p-trunc-len-f 0 \
  --o-denoising-stats microbiome/qiime_analysis_remove_duplicate_primers_marmosets/stats-dada2.qza
  
qiime metadata tabulate \
  --m-input-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/stats-dada2.qza \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/stats-dada2.qzv

#generate summarizes of tables 
qiime feature-table summarize \
  --i-table microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qza \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qzv \
  --m-sample-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt

qiime feature-table tabulate-seqs \
  --i-data microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs.qza \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs.qzv

qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs.qzv

#Generate a tree for phylogenetic diversity analyses

#perform a multiple sequence alignment of the sequences in  FeatureData[Sequence] to create a FeatureData[AlignedSequence]
qiime alignment mafft \
  --i-sequences microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs.qza \
  --o-alignment microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-aligned-rep-seqs.qza
  
#mask the alignment to remove positions that are highly variable to eliminate noise from the resulting phylogenetic tree
qiime alignment mask \
  --i-alignment microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-aligned-rep-seqs.qza \
  --o-masked-alignment microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-masked-aligned-rep-seqs.qza

#apply FastTree to generate a phylogenetic tree from the masked alignment
qiime phylogeny fasttree \
  --i-alignment microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-masked-aligned-rep-seqs.qza \
  --o-tree microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-unrooted-tree.qza
  
#apply midpoint rooting to place the root of the tree at the midpoint of the longest tip-to-tip distance in the unrooted tree
  qiime phylogeny midpoint-root \
  --i-tree microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-unrooted-tree.qza \
  --o-rooted-tree microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-rooted-tree.qza
    

#core alpha and beta diversity 
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-rooted-tree.qza \
  --i-table microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qza \
  --p-sampling-depth 45000 \
  --m-metadata-file  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt\
  --output-dir microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results


qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/unweighted_unifrac_emperor.qzv
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/jaccard_emperor.qzv
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/bray_curtis_emperor.qzv
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_emperor.qzv


qiime diversity alpha-group-significance \
  --i-alpha-diversity microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/shannon_vector.qza \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt\
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/shannon_vector.qzv

qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/shannon_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/observed_otus_vector.qza \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt\
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/observed_otus_vector.qzv
  
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/observed_otus_vector.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/evenness_vector.qza \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt\
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/evenness_vector.qzv

qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/evenness_vector.qzv

#analyze sample composition using PERMANOVA 
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/unweighted-unifrac-captive-significance.qzv 


qiime diversity beta-group-significance \
  --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
  --m-metadata-column captive \
  --o-visualization  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted-unifrac-captive-significance.qzv \
  --p-pairwise
  
qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted-unifrac-captive-significance.qzv 

#adonis analyses 

 qiime diversity adonis \
 --i-distance-matrix  /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula sex \
 --o-visualization /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/sex_weighed_unifrac_adonis.qzv

 
 qiime diversity adonis \
 --i-distance-matrix  /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula captive \
 --o-visualization /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/captive_weighed_unifrac_adonis.qzv
 
 
 
 qiime diversity adonis \
 --i-distance-matrix  /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
 --m-metadata-file  /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
 --p-formula species \
 --o-visualization /Users/arcova/Documents/microbiome/qiime_analysis_remove_duplicate_primers_marmosets/species_weighed_unifrac_adonis.qzv

  
 
qiime diversity beta-group-significance \
  --i-distance-matrix  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
  --m-metadata-column species \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted-unifrac-species-significance.qzv \
  --p-pairwise
 
 qiime tools view microbiome/qiime_analysis_remove_duplicate_primers_marmosets/core-metrics-results/weighted_unifrac_emperor.qzv
 qiime tools view  microbiome/qiime_analysis_remove_duplicate_primers/core-metrics-results/weighted-unifrac-hybrid-significance.qzv

#alpha rarefraction plotting 
  qiime diversity alpha-rarefaction \
  --i-table microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qza  \
  --i-phylogeny microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-rooted-tree.qza \
  --p-max-depth 100000 \
  --p-iterations 100 \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt\
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/alpha-rarefaction.qzv
  
# Taxonomy

mkdir training-feature-classifiers
    
#importing reference data sets
 qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path microbiome/gg_13_8_otus/rep_set/99_otus.fasta \
  --output-path microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/99_otus.qza

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --source-format HeaderlessTSVTaxonomyFormat \
  --input-path microbiome/gg_13_8_otus/taxonomy/99_otu_taxonomy.txt \
  --output-path microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/ref-taxonomy.qza


#Extract reference reads
qiime feature-classifier extract-reads \
  --i-sequences microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/99_otus.qza \
  --p-f-primer GTGCCAGCMGCCGCGGTAA \
  --p-r-primer GGACTACHVGGGTWTCTAAT \
  --p-trunc-len 500 \
  --o-reads microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/ref-seqs.qza
                                            
#train the classifier
#We can now train a Naive Bayes classifier as follows, using the reference reads and taxonomy that we just created.
qiime feature-classifier fit-classifier-naive-bayes \
 --i-reference-reads microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/ref-seqs.qza \
  --i-reference-taxonomy microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/ref-taxonomy.qza \
  --o-classifier microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/classifier.qza


#test the classifier
qiime feature-classifier classify-sklearn \
  --i-classifier microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/classifier.qza \
  --i-reads   microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs.qza  \
  --o-classification microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/taxonomy.qza

qiime metadata tabulate \
  --m-input-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/taxonomy.qza \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/taxonomy.qzv

#view the taxonomic composition of the samples with bar plots.
qiime taxa barplot \
  --i-table microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qza \
  --i-taxonomy microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/taxonomy.qza \
  --m-metadata-file microbiome/qiime_analysis_remove_duplicate_primers_marmosets/gut_metadatav5.txt \
  --o-visualization microbiome/qiime_analysis_remove_duplicate_primers_marmosets/training-feature-classifiers/taxa-bar-plots.qzv
  
    
#prepare biom inputs for PICRUST analysis 

#inputs
http://greengenes.secondgenome.com/downloads/database/13_5/gg_13_5.fasta.gz 


# build gg_16S_counts.tab and gg_ko_counts.tab
#gunzip -c 16S_13_5_precalculated.tab.gz | sed 's/\#OTU_IDs/taxon_oid/g' > gg_16S_counts.tab
sed -e 's/\#OTU_IDs/taxon_oid/g' microbiome/picrust/16S_13_5_precalculated.tab>  microbiome/picrust/gg_16S_counts.tab
#gunzip -c ko_13_5_precalculated.tab.gz | sed 's/\#OTU_IDs/GenomeID/g' | grep -v metadata_KEGG | cut -f 1-6910 > gg_ko_counts.tab
sed -e 's/\#OTU_IDs/GenomeID/g' microbiome/picrust/ko_13_5_precalculated.tab| grep -v metadata_KEGG | cut -f 1-6910 > microbiome/picrust/gg_ko_counts.tab
# remove empty lines in gg_ko_counts.tab .bak back up extension required on a mac 
sed -i .bak '/^\s*$/d' "microbiome/picrust/gg_ko_counts.tab"
rm "microbiome/picrust/gg_ko_counts.tab.bak"
# save KEGG Pathways and Description metadata
echo "" > kegg_meta
#gunzip -c ko_13_5_precalculated.tab.gz | grep metadata_KEGG >> kegg_meta
grep metadata_KEGG microbiome/picrust/ko_13_5_precalculated.tab >> microbiome/picrust/kegg_meta

#######
#pick OTUS

qiime tools import \
--input-path microbiome/gg_13_8_otus/rep_set/99_otus.fasta \
--output-path microbiome/picrust/gg_13_8_otu_99.qza \
--type 'FeatureData[Sequence]'

-output-dir microbiome/picrust/closedRef_forPICRUSt/

#galaxy online used 13_5

qiime tools import \
--input-path microbiome/gg_13_5_otus/rep_set/99_otus.fasta \
--output-path microbiome/picrust/gg_13_5_otu_99.qza \
--type 'FeatureData[Sequence]'

qiime vsearch cluster-features-closed-reference \
--i-sequences microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix-gut-rep-seqs.qza \
--i-table  microbiome/qiime_analysis_remove_duplicate_primers_marmosets/callithrix.table.qza \
--i-reference-sequences microbiome/picrust/gg_13_5_otu_99.qza \
--p-perc-identity 1 \
--p-threads 0 \
--output-dir microbiome/picrust/closedRef_forPICRUSt_13_5_v2

qiime tools export microbiome/picrust/closedRef_forPICRUSt_13_5_v2/clustered_table.qza \
--output-dir microbiome/picrust/closedRef_forPICRUSt_13_5_v2/

#processed biom file int http://galaxy.morganlangille.com

