# Create logo.ico for EXE and shortcut
# Sources (in order): assets/, frontend/public/, yp_posf/public/
# Output: assets/logo.ico and deploy/installer/logo.ico (for Inno Setup)

from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Pillow required: pip install pillow")
    exit(1)

script_dir = Path(__file__).resolve().parent
project_root = script_dir.parent.parent
assets_dir = project_root / "assets"

# Source paths (central assets first)
logo_png = assets_dir / "logo.png"
if not logo_png.exists():
    logo_png = project_root / "yp_posf" / "public" / "logo.png"
if not logo_png.exists():
    logo_png = project_root / "frontend" / "public" / "logo.png"

logo_svg = assets_dir / "logo.svg"
if not logo_svg.exists():
    logo_svg = project_root / "yp_posf" / "public" / "logo.svg"
favicon_ico = project_root / "yp_posf" / "public" / "favicon.ico"

# Output: assets/ and deploy/installer/ (for Inno Setup)
logo_ico_assets = assets_dir / "logo.ico"
logo_ico_deploy = script_dir / "logo.ico"
assets_dir.mkdir(parents=True, exist_ok=True)


def create_ico_from_png():
    if not logo_png.exists():
        return False
    img = Image.open(logo_png).convert("RGBA")
    if img.width < 256 or img.height < 256:
        img = img.resize((256, 256), Image.Resampling.LANCZOS)
    img.save(logo_ico_assets, format="ICO", sizes=[(256, 256), (48, 48), (32, 32), (16, 16)])
    return logo_ico_assets.stat().st_size > 100


def copy_favicon():
    if favicon_ico.exists() and favicon_ico.stat().st_size > 100:
        import shutil
        shutil.copy2(favicon_ico, logo_ico_assets)
        return True
    return False


def create_ico_from_svg():
    if not logo_svg.exists():
        return False
    try:
        import cairosvg
        import io
        png_data = cairosvg.svg2png(url=str(logo_svg), output_width=256, output_height=256)
        img = Image.open(io.BytesIO(png_data)).convert("RGBA")
        img.save(logo_ico_assets, format="ICO", sizes=[(256, 256), (48, 48), (32, 32), (16, 16)])
        return logo_ico_assets.stat().st_size > 100
    except ImportError:
        return False


def main():
    if create_ico_from_png():
        print(f"Created: {logo_ico_assets} (from logo.png)")
    elif create_ico_from_svg():
        print(f"Created: {logo_ico_assets} (from logo.svg)")
    elif copy_favicon():
        print(f"Created: {logo_ico_assets} (from favicon.ico)")
    else:
        img = Image.new("RGBA", (256, 256), (245, 158, 11, 255))
        img.save(logo_ico_assets, format="ICO", sizes=[(256, 256), (48, 48), (32, 32), (16, 16)])
        print(f"Created: {logo_ico_assets} (fallback - add assets/logo.png for your logo)")

    # Copy to deploy/installer for Inno Setup
    import shutil
    shutil.copy2(logo_ico_assets, logo_ico_deploy)
    print(f"Copied to: {logo_ico_deploy}")

    # Create logo.png for frontend (Register, Login) - from ico or svg
    logo_png_out = assets_dir / "logo.png"
    logo_png_public = project_root / "yp_posf" / "public" / "logo.png"
    if logo_png.exists():
        shutil.copy2(logo_png, logo_png_out)
        if logo_png_public.parent.exists():
            try:
                shutil.copy2(logo_png, logo_png_public)
            except OSError:
                pass  # File in use (e.g. Vite dev server)
        print(f"logo.png ready: {logo_png_out}")
    elif logo_svg.exists():
        try:
            import cairosvg
            import io
            png_data = cairosvg.svg2png(url=str(logo_svg), output_width=256, output_height=256)
            with open(logo_png_out, 'wb') as f:
                f.write(png_data)
            if logo_png_public.parent.exists():
                try:
                    shutil.copy2(logo_png_out, logo_png_public)
                except OSError:
                    pass
            print(f"Created logo.png from SVG: {logo_png_out}")
        except ImportError:
            pass  # cairosvg optional


if __name__ == "__main__":
    main()
