Downscaled Images Download Script

#!/bin/bash

# Create directory for images
mkdir -p japanese_wallpapers

# Extract only downscaled image URLs and download them
grep "downscaled" paste.txt | tr -d '",' | while read -r url; do
    # Extract filename from URL
    filename=$(basename "$url")
    
    # Check if file already exists
    if [ -f "japanese_wallpapers/$filename" ]; then
        echo "Skipping existing file: $filename"
        continue
    fi
    
    # Download the image
    echo "Downloading: $filename"
    curl -s -L "$url" -o "japanese_wallpapers/$filename"
    
    # Add a small delay to be nice to the server
    sleep 0.1
done

# Print completion message
echo "Download complete! Files saved in japanese_wallpapers directory"
echo "Total files: $(ls japanese_wallpapers | wc -l)"
