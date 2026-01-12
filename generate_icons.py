#!/usr/bin/env python3
"""Generate placeholder app icons for iOS"""

import os
from PIL import Image, ImageDraw

# Icon specifications
icons = [
    {"name": "AppIcon-20x20@2x.png", "size": 40},
    {"name": "AppIcon-20x20@3x.png", "size": 60},
    {"name": "AppIcon-29x29@2x.png", "size": 58},
    {"name": "AppIcon-29x29@3x.png", "size": 87},
    {"name": "AppIcon-40x40@2x.png", "size": 80},
    {"name": "AppIcon-40x40@3x.png", "size": 120},
    {"name": "AppIcon-60x60@2x.png", "size": 120},
    {"name": "AppIcon-60x60@3x.png", "size": 180},
    {"name": "AppIcon-1024x1024.png", "size": 1024},
]

# Output directory
output_dir = "x5lite/App/Assets.xcassets/AppIcon.appiconset"
os.makedirs(output_dir, exist_ok=True)

# Generate icons
for icon in icons:
    # Create a simple blue placeholder
    img = Image.new('RGB', (icon["size"], icon["size"]), color='#007AFF')
    draw = ImageDraw.Draw(img)
    
    # Add a simple white circle
    center = icon["size"] // 2
    radius = icon["size"] // 3
    draw.ellipse(
        [(center - radius, center - radius), (center + radius, center + radius)],
        fill='#FFFFFF',
        outline='#FFFFFF'
    )
    
    # Save the icon
    img.save(os.path.join(output_dir, icon["name"]), 'PNG')
    print(f"Generated {icon['name']} ({icon['size']}x{icon['size']})")
