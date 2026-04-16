"""Procedural icon generator for Silver Suite (polished v2).

Design:
  · Blue-gradient background (lighter top-left → deeper bottom-right)
  · Crisp white rounded tile centered, with subtle inner highlight
  · Bold blue medical-cross plus inside
  · Warm amber sun accent top-right with soft halo

Emits:
  assets/icon/icon.png, assets/icon/icon_fg.png, web/favicon.png, docs/icon.png
"""
from __future__ import annotations
import math
import os
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

BG_TOP = (47, 129, 218)        # lighter blue
BG_BOTTOM = (13, 67, 135)      # deeper blue
PLUS = (24, 100, 192)          # primary blue
WHITE = (255, 255, 255)
SUN = (240, 170, 40)


def linear_gradient(size: int, top: tuple, bottom: tuple) -> Image.Image:
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        t = y / (size - 1)
        r = int(top[0] * (1 - t) + bottom[0] * t)
        g = int(top[1] * (1 - t) + bottom[1] * t)
        b = int(top[2] * (1 - t) + bottom[2] * t)
        for x in range(size):
            px[x, y] = (r, g, b)
    return img.convert("RGBA")


def compose(size: int, with_bg: bool) -> Image.Image:
    if with_bg:
        bg = linear_gradient(size, BG_TOP, BG_BOTTOM)

        # subtle diagonal glow
        glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        for i, a in enumerate([60, 35, 18]):
            r = int(size * (0.55 + i * 0.18))
            gd.ellipse(
                [size // 2 - r, size // 3 - r, size // 2 + r, size // 3 + r],
                fill=(255, 255, 255, a),
            )
        glow = glow.filter(ImageFilter.GaussianBlur(size // 12))
        bg.alpha_composite(glow)

        # rounded mask
        mask = Image.new("L", (size, size), 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            [0, 0, size, size], radius=int(size * 0.22), fill=255
        )
        img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        img.paste(bg, (0, 0), mask)
    else:
        img = Image.new("RGBA", (size, size), (0, 0, 0, 0))

    # White rounded tile (softer than a circle — reads more like a phone card)
    tile_size = int(size * 0.60)
    tx = (size - tile_size) // 2
    ty = int(size * 0.22)
    tile_radius = int(tile_size * 0.28)

    # shadow
    sh_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(sh_layer).rounded_rectangle(
        [tx, ty + int(size * 0.02), tx + tile_size, ty + tile_size + int(size * 0.02)],
        radius=tile_radius,
        fill=(0, 0, 0, 120),
    )
    sh_layer = sh_layer.filter(ImageFilter.GaussianBlur(size // 30))
    img.alpha_composite(sh_layer)

    # actual tile
    tile = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(tile).rounded_rectangle(
        [tx, ty, tx + tile_size, ty + tile_size],
        radius=tile_radius,
        fill=WHITE + (255,),
    )
    # inner top highlight
    hl = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(hl).rounded_rectangle(
        [tx + 6, ty + 6, tx + tile_size - 6, ty + int(tile_size * 0.35)],
        radius=tile_radius,
        fill=(255, 255, 255, 140),
    )
    hl = hl.filter(ImageFilter.GaussianBlur(size // 50))
    tile_mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(tile_mask).rounded_rectangle(
        [tx, ty, tx + tile_size, ty + tile_size],
        radius=tile_radius,
        fill=255,
    )
    masked_hl = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    masked_hl.paste(hl, (0, 0), tile_mask)
    tile.alpha_composite(masked_hl)
    img.alpha_composite(tile)

    # Bold plus inside (blue)
    d = ImageDraw.Draw(img)
    cx = tx + tile_size // 2
    cy = ty + tile_size // 2
    bar_w = int(tile_size * 0.66)
    bar_h = int(tile_size * 0.18)
    r = bar_h // 2
    d.rounded_rectangle(
        [cx - bar_w // 2, cy - bar_h // 2, cx + bar_w // 2, cy + bar_h // 2],
        radius=r,
        fill=PLUS + (255,),
    )
    d.rounded_rectangle(
        [cx - bar_h // 2, cy - bar_w // 2, cx + bar_h // 2, cy + bar_w // 2],
        radius=r,
        fill=PLUS + (255,),
    )

    # Warm sun top-right with halo
    halo = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    hr = int(size * 0.13)
    hx, hy = int(size * 0.80), int(size * 0.22)
    ImageDraw.Draw(halo).ellipse(
        [hx - hr, hy - hr, hx + hr, hy + hr],
        fill=(255, 200, 100, 140),
    )
    halo = halo.filter(ImageFilter.GaussianBlur(size // 30))
    img.alpha_composite(halo)

    sr = int(size * 0.075)
    d.ellipse([hx - sr, hy - sr, hx + sr, hy + sr], fill=SUN + (255,))
    # small highlight on sun
    d.ellipse(
        [
            hx - int(sr * 0.65),
            hy - int(sr * 0.65),
            hx - int(sr * 0.15),
            hy - int(sr * 0.15),
        ],
        fill=(255, 235, 170, 220),
    )

    return img


def main() -> None:
    out_dir = os.path.join(ROOT, "assets", "icon")
    os.makedirs(out_dir, exist_ok=True)

    icon = compose(1024, with_bg=True)
    icon.save(os.path.join(out_dir, "icon.png"), "PNG")

    fg = compose(1024, with_bg=False)
    fg.save(os.path.join(out_dir, "icon_fg.png"), "PNG")

    web_out = os.path.join(ROOT, "web")
    if os.path.isdir(web_out):
        icon.resize((64, 64), Image.LANCZOS).save(
            os.path.join(web_out, "favicon.png"), "PNG"
        )
    docs_out = os.path.join(ROOT, "docs")
    if os.path.isdir(docs_out):
        icon.resize((256, 256), Image.LANCZOS).save(
            os.path.join(docs_out, "icon.png"), "PNG"
        )

    print("Silver Suite icons (v2, polished):")
    print(f"  {os.path.join(out_dir, 'icon.png')}")
    print(f"  {os.path.join(out_dir, 'icon_fg.png')}")


if __name__ == "__main__":
    main()
