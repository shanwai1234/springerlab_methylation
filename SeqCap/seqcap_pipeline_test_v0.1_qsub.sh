#!/bin/bash

#make folder structure
timestamp=$(date +%Y%m%d-%H%M%S)

workingdir=/scratch.global/pcrisp/SeqCap_1_Mei/testpipeline_SeqCap_1_Mei

analysis_dir=/scratch.global/pcrisp/SeqCap_1_Mei/testpipeline_SeqCap_1_Mei/analysis
mkdir $analysis_dir

log_folder=${analysis_dir}/logs
mkdir $log_folder

fastqcfolder=${analysis_dir}/fastqc
mkdir $fastqcfolder

trimmed=${analysis_dir}/trimmed
mkdir $trimmed

alignfolder=${analysis_dir}/bsmaped
mkdir $alignfolder

BSMAPratio_folder=${analysis_dir}/BSMAPratio
mkdir $BSMAPratio_folder

TempOut=${analysis_dir}/TempOut
mkdir $TempOut

OnTargetCoverage=${analysis_dir}/OnTargetCoverage
mkdir $OnTargetCoverage

#script path and cat a record of what was run
script_dir=/home/springer/pcrisp/gitrepos/springerlab_methylation/SeqCap
script_to_qsub=${script_dir}/seqcap_pipeline_test_v0.1.sh
cat $script_to_qsub > "$log_folder/script.log"
cat $0 > "$log_folder/runner.log"

#run script and pass args
#bash $script $workingdir $log_folder $fastqcfolder $trimmed $alignfolder $BSMAPratio_folder $TempOut $OnTargetCoverage
qsub -t 1-8 -v LIST=${workingdir}/samples.txt $script_to_qsub

#to run
#bash /home/springer/pcrisp/gitrepos/springerlab_methylation/SeqCap/seqcap_pipeline_test_v0.1_qsub.sh