#Qiime2 commands for Malukiewicz et al. 2021 The Gut Microbiome of Exudivorous Wild andnon-Wild Marmosets
#biom table extraction commands are found at the end of this script 


conda activate qiime2-2021.2


#import demultiplexed PE data 

qiime tools import \
 --type 'SampleData[PairedEndSequencesWithQuality]' \
 --input-path  /qiime/microbiome_qiime \
 --input-format CasavaOneEightSingleLanePerSampleDirFmt \
 --output-path  /qiime/feature/callithrix-gut-demux-paired-end.qza
 
qiime demux summarize \
  --i-data  /qiime/feature/callithrix-gut-demux-paired-end.qza \
  --o-visualization  /qiime/feature/callithrix-gut-demux-paired-end.qzv
  
 
#Sequence quality control and feature table construction


  qiime dada2 denoise-paired \
 --i-demultiplexed-seqs  /qiime/feature/callithrix-gut-demux-paired-end.qza  \
 --o-table /qiime/feature/callithrix.table.qza\
 --o-representative-sequences /qiime/feature/callithrix-gut-rep-seqs.qza \
 --p-trim-left-f 0 \
 --p-trim-left-r 10 \
 --p-trunc-len-r 220 \
 --p-trunc-len-f 0 \
 --o-denoising-stats /qiime/feature/stats-dada2.qza
 
 qiime metadata tabulate \
  --m-input-file /qiime/feature/stats-dada2.qza \
  --o-visualization /qiime/feature/stats-dada2.qzv
 
 #FeatureTable and FeatureData summaries
 
 qiime feature-table summarize \
  --i-table /qiime/feature/callithrix.table.qza \
  --o-visualization /qiime/feature/table.qzv \
  --m-sample-metadata-file /qiime/metadata/gut_metadatav5.txt \
qiime feature-table tabulate-seqs \
  --i-data /qiime/feature/callithrix-gut-rep-seqs.qza  \
  --o-visualization /qiime/feature/rep-seqs.qzv
  
#make phylogenetic tree 

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences  /qiime/feature/callithrix-gut-rep-seqs.qza  \
  --o-alignment /qiime/feature/aligned-rep-seqs.qza \
  --o-masked-alignment /qiime/feature/masked-aligned-rep-seqs.qza \
  --o-tree /qiime/feature/unrooted-tree.qza \
  --o-rooted-tree /qiime/feature/rooted-tree.qza
  
  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny /qiime/feature/rooted-tree.qza \
  --i-table /qiime/feature/callithrix.table.qza \
  --p-sampling-depth 33000 \
  --m-metadata-file /qiime/metadata/gut_metadatav5.txt \
  --output-dir /qiime/feature/core-metrics-results
  
  
  #classify reads 
  qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads /qiime/feature/classifier/silva-138-99-seqs-515-806.qza\
  --i-reference-taxonomy /qiime/feature/classifier/silva-138-99-tax-515-806.qza \
  --o-classifier /qiime/feature/classifier/classifier.qza
  
  
  qiime feature-classifier classify-sklearn \
  --i-classifier /qiime/feature/classifier/classifier.qza \
  --i-reads /qiime/feature/callithrix-gut-rep-seqs.qza  \
  --o-classification /qiime/feature/classifier/callithrix-gut-rep-seqs-taxonomy.qza

qiime metadata tabulate \
  --m-input-file /qiime/feature/classifier/callithrix-gut-rep-seqs-taxonomy.qza \
  --o-visualization /qiime/feature/classifier/callithrix-gut-rep-seqs-taxonomy.qzv
  
  
#extract biom file 
qiime tools export \
  --input-path /qiime/feature/callithrix.table.qza \
   --output-path  /qiime/feature/biom

#then export taxonomy info
qiime tools export \
--input-path /qiime/feature/classifier/callithrix-gut-rep-seqs-taxonomy.qza \
  --output-path /qiime/feature/biom
  
  
biom add-metadata -i /qiime/feature/biom/feature-table.biom -o /qiime/feature/biom/table-with-taxonomy.biom --observation-metadata-fp /qiime/feature/biom/biom-taxonomy.tsv --sc-separated taxonomy


#export out other features 
#then export taxonomy info
qiime tools export \
--input-path /qiime/feature/core-metrics-results/weighted_unifrac_distance_matrix.qza \
  --output-path /qiime/feature/core-metrics-results/output_tables
  
#export out other features 
#then export taxonomy info
qiime tools export \
--input-path /qiime/feature/callithrix-gut-rep-seqs.qza\
  --output-path /qiime/feature/

  
  
