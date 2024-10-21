
 ### Collection of scripts used for GWAS analysis pipeline in the Hines lab.
----

This pipeline takes as input a set of fastq files generated from a sequencing run. 

#### qc

- Uses fastqc and fastp for quality checks and subsequent trimming.

#### align
- Uses bwa-mem to align all reads and create a bam file. Manual visualization using IGV or some other tool is recommended. 

#### sample_variant_calling
- Uses GATK HaplotypeCaller to produce vcfs for each individual sample.

#### joint_variant_calling
- Used to genotype all samples jointly, producing a vcf that can be imported to PLINK to conduct association tests.

#### variant_type_selection
- Not necessary for a GWAS, but includes additional steps to filter for specific variant types and then uses bcftools to produce a joint vcf for use in PLINK.


Thanks to Tunc Dabak and Sarthok Rahman for their help and for sharing code.