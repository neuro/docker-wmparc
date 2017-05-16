#!/bin/bash
set -e

gunzip -c /input/T1w/Diffusion/data.nii.gz > /output/data.nii
gunzip -c /input/T1w/aparc+aseg.nii.gz > /output/aparc+aseg.nii
/dtk/dti_recon "/output/data.nii" "/output/dti" -gm "/opt/gradient_matrix.txt" 1 -b 3010 -b0 1 -oc -p 3 -sn 1 -ot nii
rm /output/data.nii
/dtk/dti_tracker "/output/dti" "/output/fact.trk" -at 60 -iz -m "/input/T1w/Diffusion/nodif_brain_mask.nii.gz" -it nii
fsl5.0-flirt -nosearch -interp nearestneighbour -applyxfm -in /output/aparc+aseg.nii -out /output/aparc+aseg_reg.nii -ref /output/dti_fa.nii
gunzip /output/aparc+aseg_reg.nii.gz
/opt/wmparc/target/release/wmparc /output/fact.trk -n /output/aparc+aseg_reg.nii -o /output/wm_parc.nii

for file in /output/*.nii; do
	gzip $file
done 
