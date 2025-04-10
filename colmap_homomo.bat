@echo off

set DATASET_PATH=C:\Users\82105\output_homomo
set RESULT_PATH=C:\Users\82105\Desktop\result_homomo

colmap feature_extractor ^
--database_path "%DATASET_PATH%\database.db" ^
--image_path "%DATASET_PATH%" ^
--SiftExtraction.max_num_features 8192 ^
--SiftExtraction.estimate_affine_shape true ^
--SiftExtraction.domain_size_pooling true

colmap exhaustive_matcher ^
--database_path "%DATASET_PATH%\database.db" ^
--SiftMatching.guided_matching true ^
--SiftMatching.max_ratio 0.9


mkdir "%RESULT_PATH%\sparse"

colmap mapper ^
--database_path "%DATASET_PATH%\database.db" ^
--image_path "%DATASET_PATH%" ^
--output_path "%RESULT_PATH%\sparse" ^
--Mapper.min_num_matches 15 ^
--Mapper.init_min_num_inliers 30 ^
--Mapper.abs_pose_min_num_inliers 20 ^
--Mapper.abs_pose_min_inlier_ratio 0.15

mkdir "%RESULT_PATH%\dense"

colmap image_undistorter ^
--image_path "%DATASET_PATH%" ^
--input_path "%RESULT_PATH%\sparse\1" ^
--output_path "%RESULT_PATH%\dense" ^
--output_type COLMAP ^
--max_image_size 2000

colmap patch_match_stereo ^
--workspace_path "%RESULT_PATH%\dense" ^
--workspace_format COLMAP ^
--PatchMatchStereo.geom_consistency true

colmap stereo_fusion ^
--workspace_path "%RESULT_PATH%\dense" ^
--workspace_format COLMAP ^
--input_type geometric ^
--output_path "%RESULT_PATH%\dense\fused.ply"

pause
