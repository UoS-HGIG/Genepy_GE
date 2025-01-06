process CADD_score {
  //publishDir "${params.output}/${vcf_n}", mode: "copy", overwrite: true
  //maxForks 10
  input:
  tuple val(chrx), val(vcf_n), file(vcfFile)

  output:
  tuple val(chrx), path("p1.vcf"), path("wes_${chrx}.tsv.gz"), path("wes_${chrx}.tsv.gz.tbi"), val(vcf_n), file(vcfFile), emit: pre_proc_1
  
  script:
    """
    
    bcftools view -G ${vcfFile} -Ov -o p1.vcf
    
    awk -F"\t" '\$1 ~/#/ || length(\$4)>1||length(\$5)>1' p1.vcf | sed '3383,\$s/chr//g' p1.vcf > ${chrx}.p11.vcf
    CADD.sh -c 8 -o wes_${chrx}.tsv.gz ${chrx}.p11.vcf
    tabix -p vcf wes_${chrx}.tsv.gz
    
    
    """
}