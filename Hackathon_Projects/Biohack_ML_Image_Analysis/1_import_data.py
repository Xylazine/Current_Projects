import kagglehub
import pandas as pd
import os
from skimage import measure, filters, color, io, transform

cache_path = os.path.expanduser(
    "~/.cache/kagglehub/datasets/iarunava/cell-images-for-detecting-malaria"
)

if not os.path.exists(cache_path):
    print("Downloading dataset...")
    kagglehub.dataset_download("iarunava/cell-images-for-detecting-malaria")
else:
    print("Dataset already cached, skipping download.")

path = cache_path + "/versions/1/cell_images/"

print(f"Dataset path: {path}")

rows = []
img_sizes = []

for label, folder in [('parasitized', "Parasitized"), ('uninfected', "Uninfected")]:
    ind = 0
    for filename in os.listdir(path + folder):
        # Skip non-TIF files
        if not filename.lower().endswith(('.png')):
            continue
        # only use a subset of the data
        if ind > 100:
            break
        image = io.imread(path + folder + "/" + filename)
        image = transform.resize(image, (150, 150), anti_aliasing=True)
        # Convert to grayscale
        gray = color.rgb2gray(image)
        # Threshold to isolate cell from background
        thresh = filters.threshold_otsu(gray)
        binary = gray > thresh
        # Pools all cell pixels in the image
        labeled = measure.label(binary)
        # Measure properties
        props = measure.regionprops(labeled)[0]
        rows.append({
            'source_image': filename,
            'area': props.area,
            'perimeter': props.perimeter,
            'eccentricity': props.eccentricity,
            'mean_intensity': gray.mean(),
            'var_intensity': gray.var(),
            'label': label
        })
        ind += 1


df = pd.DataFrame(rows)
print("(Images, Features):", df.shape)
df.to_csv('features.csv', index=False)