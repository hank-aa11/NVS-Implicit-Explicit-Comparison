git clone https://github.com/yenchenlin/nerf-pytorch.git
cd nerf-pytorch
pip install -r requirements.txt
sudo apt-get update
sudo apt-get install imagemagick
python run_nerf.py \
    --expname plant_final_high_quality \
    --basedir ./logs \
    --datadir ./data/my_scene \
    --dataset_type llff \
    --no_ndc \
    --spherify \
    --factor 2 \
    --netdepth 8 \
    --netwidth 256 \
    --netdepth_fine 8 \
    --netwidth_fine 256 \
    --N_rand 1024 \
    --N_samples 128 \
    --N_importance 256 \
    --use_viewdirs \
    --lrate 5e-4 \
    --lrate_decay 250 \
    --llffhold 8 \
    --i_print 100 \
    --i_img 1000 \
    --i_weights 10000 \
    --i_testset 50000 \
    --i_video 50000
