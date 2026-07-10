#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
image_dir="${1:-$script_dir}"
delay_seconds="${2:-30}"

python3 - "$image_dir" "$delay_seconds" <<'PY'
import re
import sys
import tkinter as tk
from pathlib import Path
from PIL import Image, ImageTk


def natural_sort_key(path: Path):
    return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', path.name)]

image_dir = Path(sys.argv[1]).expanduser().resolve()
delay_ms = max(1, int(float(sys.argv[2]) * 1000))

extensions = {'.jpg', '.jpeg', '.png', '.bmp', '.gif', '.tif', '.tiff', '.webp'}
images = [p for p in image_dir.iterdir() if p.is_file() and p.suffix.lower() in extensions]
images.sort(key=natural_sort_key)

if not images:
    raise SystemExit(f"No image files found in {image_dir}")

root = tk.Tk()
root.title("Slideshow")
root.configure(background="black")
root.attributes("-fullscreen", True)
root.bind("<Escape>", lambda event: root.destroy())
root.bind("<q>", lambda event: root.destroy())

label = tk.Label(root, bg="black")
label.pack(fill="both", expand=True)


def show_next_image(index: int):
    image_path = images[index]
    with Image.open(image_path) as img:
        if img.mode != "RGB":
            img = img.convert("RGB")

        screen_w = root.winfo_screenwidth()
        screen_h = root.winfo_screenheight()
        image_w, image_h = img.size
        scale = min(screen_w / image_w, screen_h / image_h)
        target_w = max(1, int(image_w * scale))
        target_h = max(1, int(image_h * scale))
        resized = img.resize((target_w, target_h), Image.Resampling.LANCZOS)
        photo = ImageTk.PhotoImage(resized)

    label.config(image=photo)
    label.image = photo
    next_index = (index + 1) % len(images)
    root.after(delay_ms, show_next_image, next_index)

show_next_image(0)
root.mainloop()
PY
