#!/usr/bin/env python3
"""Generate a 1024x1024 Crown Bees app icon."""
import subprocess, sys, os

# Install Pillow if needed
try:
    from PIL import Image, ImageDraw
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow", "-q"])
    from PIL import Image, ImageDraw

import math

SIZE = 1024
img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Amber gradient background (simulate with horizontal gradient)
for y in range(SIZE):
    t = y / SIZE
    r = int(0x86 + t * (0xe6 - 0x86))
    g = int(0x53 + t * (0x91 - 0x53))
    b = 0
    draw.line([(0, y), (SIZE, y)], fill=(r, g, b, 255))

# Draw a simple stylized bee body (yellow oval with black stripes)
cx, cy = SIZE // 2, SIZE // 2 - 60
bw, bh = 220, 150  # body width/height

# Body (yellow)
draw.ellipse([cx - bw//2, cy - bh//2, cx + bw//2, cy + bh//2], fill=(255, 220, 0, 255))

# Black stripes
stripe_count = 3
for i in range(stripe_count):
    sy = cy - bh//2 + (i + 1) * bh // (stripe_count + 1) - 12
    # clip stripe to ellipse by drawing with mask
    stripe_img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(stripe_img)
    sd.ellipse([cx - bw//2, cy - bh//2, cx + bw//2, cy + bh//2], fill=(0, 0, 0, 255))
    # white band to mask
    sd.rectangle([0, sy, SIZE, sy + 22], fill=(0, 0, 0, 0))
    # re-draw stripe only inside ellipse
    draw.rectangle([cx - bw//2, sy, cx + bw//2, sy + 22], fill=(30, 30, 30, 200))

# Head (small yellow circle)
hcx, hcy = cx, cy - bh//2 - 44
draw.ellipse([hcx - 54, hcy - 54, hcx + 54, hcy + 54], fill=(255, 220, 0, 255))
draw.ellipse([hcx - 54, hcy - 54, hcx + 54, hcy + 54], outline=(30, 30, 30, 200), width=8)

# Wings (semi-transparent ellipses)
wing_color = (200, 230, 255, 140)
# Left wing
draw.ellipse([cx - bw//2 - 140, cy - bh//2 - 30, cx - bw//2 + 60, cy + 30], fill=wing_color)
# Right wing
draw.ellipse([cx + bw//2 - 60, cy - bh//2 - 30, cx + bw//2 + 140, cy + 30], fill=wing_color)

# Flower underneath (5 petals)
fx, fy = cx, cy + bh//2 + 100
petal_r = 60
for i in range(5):
    angle = math.radians(i * 72 - 90)
    px = fx + int(petal_r * 1.5 * math.cos(angle))
    py = fy + int(petal_r * 1.5 * math.sin(angle))
    draw.ellipse([px - petal_r, py - petal_r, px + petal_r, py + petal_r],
                 fill=(255, 180, 0, 200))
# Flower center
draw.ellipse([fx - 36, fy - 36, fx + 36, fy + 36], fill=(255, 230, 50, 255))

# Round the corners to match iOS app icon shape (180px radius)
mask = Image.new("L", (SIZE, SIZE), 0)
md = ImageDraw.Draw(mask)
md.rounded_rectangle([0, 0, SIZE, SIZE], radius=180, fill=255)
img.putalpha(mask)

# Save
out_dir = os.path.join(
    os.path.dirname(__file__),
    "CrownBeesApp/Assets.xcassets/AppIcon.appiconset"
)
os.makedirs(out_dir, exist_ok=True)
out_path = os.path.join(out_dir, "AppIcon.png")
img.save(out_path, "PNG")
print(f"Saved icon to {out_path}")

# Update Contents.json
import json
contents = {
    "images": [
        {
            "filename": "AppIcon.png",
            "idiom": "universal",
            "platform": "ios",
            "size": "1024x1024"
        }
    ],
    "info": {
        "author": "xcode",
        "version": 1
    }
}
contents_path = os.path.join(out_dir, "Contents.json")
with open(contents_path, "w") as f:
    json.dump(contents, f, indent=2)
print(f"Updated {contents_path}")
